
define :python_build, :action => :build, :install_prefix => '/usr/local' do
  version = params[:name]
  archive_dir = Chef::Config[:file_cache_path]
  archive_file = "Python-#{version}.tar.bz2"
  if node[:python_build][:archive_url_base]
    #TODO: want to use string templating (it can use with ruby 1.9)
    archive_src = "#{node[:python_build][:archive_url_base]}/#{archive_file}"
  else
    archive_src = "http://www.python.org/ftp/python/#{version}/#{archive_file}"
  end

  install_prefix = params[:install_prefix]
  install_target = "#{install_prefix}/bin/python#{version.split('.')[0,2].join('.')}"

  case params[:action]
  when :build
    script "Download #{archive_file}" do
      interpreter "ruby"
      code <<-EOH
        require 'open-uri'
        open("#{archive_src}", 'rb') do |input|
          open("#{archive_dir}/#{archive_file}", 'wb') do |output|
            while data = input.read(8192) do
              output.write(data)
            end
          end
        end
      EOH

      not_if "test -f #{archive_dir}/#{archive_file}"
      notifies :run, "execute[extract-python-#{version}]"
    end

    execute "extract-python-#{version}" do
      #action :nothing
      cwd archive_dir
      command "tar jxf #{archive_file}"
      not_if "test -d #{archive_dir}/Python-#{version}"
      notifies :run, "execute[configure-python-#{version}]"
    end

    execute "configure-python-#{version}" do
      #action :nothing
      cwd "#{archive_dir}/Python-#{version}"
      command "./configure --prefix=#{install_prefix}"
      not_if "test -f #{archive_dir}/Python-#{version}/Makefile"
      notifies :create_if_missing, "cookbook_file[place-python-#{version}-setup.cfg]"
    end

    cookbook_file "place-python-#{version}-setup.cfg" do
      action :create_if_missing
      #action :nothing
      path "#{archive_dir}/Python-#{version}/setup.cfg"
      source 'setup.cfg'
      notifies :run, "execute[make-python-#{version}]"
    end

    execute "make-python-#{version}" do
      #action :nothing
      cwd "#{archive_dir}/Python-#{version}"
      command "make"
      not_if {File.exists?(install_target)}
      notifies :run, "execute[make-install-python-#{version}]"
    end

    execute "make-install-python-#{version}" do
      #action :nothing
      cwd "#{archive_dir}/Python-#{version}"
      command "make install"
      not_if {File.exists?(install_target)}
    end

  end
end

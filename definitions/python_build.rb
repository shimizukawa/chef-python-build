
define :python_build, :action => :build, :owner => 'root', :archive_dir => '/root/src', :install_prefix => '/usr/local' do
  version = params[:name]
  owner = params[:owner]
  archive_dir = params[:archive_dir]
  archive_file = "Python-#{version}.tar.bz2"
  install_prefix = params[:install_prefix]
  install_target = "#{install_prefix}/bin/python#{version.split('.')[0,2].join('.')}"

  case params[:action]
  when :build
    directory archive_dir do
      action :create
      owner owner
    end

    remote_file archive_file do
      action :create_if_missing
      path "#{archive_dir}/#{archive_file}"
      owner owner
      source "http://www.python.org/ftp/python/#{version}/#{archive_file}"
      notifies :run, "execute[extract-python-#{version}]"
    end

    execute "extract-python-#{version}" do
      #action :nothing
      cwd archive_dir
      user owner
      command "tar jxf #{archive_file}"
      not_if "test -d #{archive_dir}/Python-#{version}"
      notifies :run, "execute[configure-python-#{version}]"
    end

    execute "configure-python-#{version}" do
      #action :nothing
      cwd "#{archive_dir}/Python-#{version}"
      user owner
      command "./configure --prefix=#{install_prefix}"
      not_if "test -f #{archive_dir}/Python-#{version}/Makefile"
      notifies :run, "cookbook_file[place-python-#{version}-setup.cfg]"
    end

    cookbook_file "place-python-#{version}-setup.cfg" do
      path "#{archive_dir}/Python-#{version}/setup.cfg"
      source 'setup.cfg'
      action :create_if_missing
      owner owner
      mode "0664"
      notifies :run, "execute[make-python-#{version}]"
    end

    execute "make-python-#{version}" do
      #action :nothing
      cwd "#{archive_dir}/Python-#{version}"
      user owner
      command "make"
      not_if {File.exists?(install_target)}
      notifies :run, "execute[make-install-python-#{version}]"
    end

    execute "make-install-python-#{version}" do
      #action :nothing
      cwd "#{archive_dir}/Python-#{version}"
      user 'root'
      command "make install"
      not_if {File.exists?(install_target)}
    end

  end
end

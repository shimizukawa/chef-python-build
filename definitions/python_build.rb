
define :python_build, :action => :build, :install_prefix => '/usr/local', :owner => 'root', :group => 'group' do
  version = params[:name]
  owner = params[:owner]
  group = params[:group]
  archive_dir = Chef::Config[:file_cache_path]
  archive_file = node["python_build"]["archive_file"] || "Python-#{version}.tgz"
  if node["python_build"]["archive_url_base"]
    archive_src = "#{node["python_build"]["archive_url_base"]}/#{archive_file}"
  else
    archive_src = "http://www.python.org/ftp/python/#{version}/#{archive_file}"
  end

  install_prefix = params[:install_prefix]
  install_target = "#{install_prefix}/bin/python#{version.split('.')[0,2].join('.')}"

  extract_command = BuildHelper.make_extract_command(archive_file)
  extract_path = "#{archive_dir}/#{BuildHelper.extract_name(archive_file)}"

  expected_python = Proc.new{|target, expected_version|
    if File.exists?(target)
      actual_version = IO.popen("#{target} -V 2>&1", "w+") {|f| f.read}.split.last
      actual_version == expected_version
    else
      false
    end
  }

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

      user owner
      group group
      not_if {File.exists?("#{archive_dir}/#{archive_file}") || expected_python.call(install_target, version)}
    end

    execute "extract-python-#{version}" do
      cwd archive_dir
      command extract_command
      user owner
      group group
      not_if {File.exists?(extract_path) || expected_python.call(install_target, version)}
    end

    cookbook_file "#{extract_path}/py26-no-sslv2.patch" do
      action :create
      owner owner
      group group
      mode "0644"
      not_if {version[0,3] != '2.6' || expected_python.call(install_target, version)}
    end

    execute "patch py26-no-sslv2.patch to #{extract_path}" do
      cwd extract_path
      command "patch -p1 < py26-no-sslv2.patch"
      returns [0, 1]
      user owner
      group group
      not_if {version[0,3] != '2.6' || expected_python.call(install_target, version)}
    end

    execute "configure-python-#{version}" do
      cwd extract_path
      command "./configure --prefix=#{install_prefix}"
      user owner
      group group
      not_if {File.exists?("#{extract_path}/Makefile") || expected_python.call(install_target, version)}
    end

    template "place-python-#{version}-setup.cfg" do
      action :create
      path "#{extract_path}/setup.cfg"
      source 'setup.cfg.erb'
      owner owner
      group group
      not_if {expected_python.call(install_target, version)}
    end

    execute "make-python-#{version}" do
      cwd extract_path
      command "make"
      user owner
      group group
      not_if {expected_python.call(install_target, version)}
    end

    execute "make-install-python-#{version}" do
      cwd extract_path
      command "make install"
      user owner
      group group
      not_if {expected_python.call(install_target, version)}
    end

  end
end

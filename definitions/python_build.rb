
define :python_build, :action => :build, :install_prefix => '/usr/local', :configure_options => [], :owner => 'root', :group => 'group' do
  version = params[:name]
  owner = params[:owner]
  group = params[:group]
  configure_options = params[:configure_options]
  archive_dir = Chef::Config[:file_cache_path]
  archive_file = node["python_build"]["archive_file"] || "Python-#{version}.tgz"
  if node["python_build"]["archive_url_base"]
    archive_src = "#{node["python_build"]["archive_url_base"]}/#{archive_file}"
  else
    archive_src = "https://www.python.org/ftp/python/#{version}/#{archive_file}"
  end

  install_prefix = params[:install_prefix]
  install_target = "#{install_prefix}/bin/python#{version.split('.')[0,2].join('.')}"

  extract_path = "#{archive_dir}/#{BuildHelper.extract_name(archive_file)}"

  case params[:action]
  when :build
    ruby_block "Download #{archive_file}" do
      block do
        BuildHelper.download(archive_src, "#{archive_dir}/#{archive_file}")
        #user owner
        #group group
      end
      not_if {File.exists?("#{archive_dir}/#{archive_file}") || BuildHelper.expected_python(install_target, version)}
    end

    execute "extract-python-#{version}" do
      cwd archive_dir
      command BuildHelper.make_extract_command(archive_file)
      user owner
      group group
      not_if {File.exists?(extract_path) || BuildHelper.expected_python(install_target, version)}
    end

    cookbook_file "#{extract_path}/py26-no-sslv2.patch" do
      action :create
      owner owner
      group group
      mode "0644"
      not_if {version[0,3] != '2.6' || BuildHelper.expected_python(install_target, version)}
    end

    execute "patch py26-no-sslv2.patch to #{extract_path}" do
      cwd extract_path
      command "patch -p1 < py26-no-sslv2.patch"
      returns [0, 1]
      user owner
      group group
      not_if {version[0,3] != '2.6' || BuildHelper.expected_python(install_target, version)}
    end

    execute "configure-python-#{version}" do
      cwd extract_path
      command "./configure --prefix=#{install_prefix} #{configure_options.join(' ')}"
      user owner
      group group
      not_if {File.exists?("#{extract_path}/Makefile") || BuildHelper.expected_python(install_target, version)}
    end

    template "place-python-#{version}-setup.cfg" do
      action :create
      path "#{extract_path}/setup.cfg"
      source 'setup.cfg.erb'
      owner owner
      group group
      not_if {BuildHelper.expected_python(install_target, version)}
    end

    execute "make-python-#{version}" do
      cwd extract_path
      command "make"
      user owner
      group group
      not_if {BuildHelper.expected_python(install_target, version)}
    end

    execute "make-install-python-#{version}" do
      cwd extract_path
      command "make install"
      user owner
      group group
      not_if {BuildHelper.expected_python(install_target, version)}
    end

    case node["platform_family"]
    when "rhel", "fedora", "suse"
      file "/etc/ld.so.conf.d/python.conf" do
        content "#{install_prefix}/lib"
        user owner
        group group
        mode "644"
      end
    end

    execute "ldconfig-python-#{version}" do
      command "ldconfig"
    end

  end
end


define :python_package, :action => :install, :python_version => nil, :python_prefix => '/usr/local', :owner => 'root', :group => 'group' do
  package = params[:name]
  owner = params[:owner]
  group = params[:group]
  python_version = params[:python_version] || ''
  major_version = "#{python_version.split('.')[0,2].join('.')}"
  python_prefix = params[:python_prefix] || '/usr/local'
  python_bin = "#{python_prefix}/bin/python#{major_version}"
  easy_install = 'easy_install'
  if major_version
    easy_install += "-#{major_version}"
  end
  easy_install_bin = "#{python_prefix}/bin/#{easy_install}"

  case params[:action]
  when :install
    remote_file "#{Chef::Config[:file_cache_path]}/distribute_setup.py" do
      source "http://python-distribute.org/distribute_setup.py"
      mode "0644"
      owner owner
      group group
      not_if {::File.exists?(easy_install_bin)}
    end

    execute "install #{easy_install}" do
      cwd Chef::Config[:file_cache_path]
      command "#{python_bin} distribute_setup.py"
      user owner
      group group
      not_if {::File.exists?(easy_install_bin)}
    end

    execute "#{easy_install} #{package}" do
      command "#{easy_install_bin} #{package}"
      user owner
      group group
    end

  end
end

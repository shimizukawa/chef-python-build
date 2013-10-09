
define :python_package, :action => :install, :python_version => nil, :python_prefix => '/usr/local', :owner => 'root', :group => 'group', :find_links => [] do
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
  find_links_opt = params[:find_links].map{|url| "-f #{url}"}.join(' ')

  case params[:action]
  when :install
    remote_file "#{Chef::Config[:file_cache_path]}/ez_setup.py" do
      source "https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py"
      mode "0644"
      owner owner
      group group
      not_if {::File.exists?(easy_install_bin)}
    end

    execute "install #{easy_install}" do
      cwd Chef::Config[:file_cache_path]
      command "#{python_bin} ez_setup.py"
      user owner
      group group
      not_if {::File.exists?(easy_install_bin)}
    end

    execute "#{easy_install} #{package}" do
      command "#{easy_install_bin} #{find_links_opt} #{package}"
      user owner
      group group
    end

  end
end

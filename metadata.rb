name             "python-build"
maintainer       "Takayuki SHIMIZUKAWA"
maintainer_email "shimizukawa@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures python-build"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.5.2"

%w{ debian ubuntu centos suse fedora redhat }.each do |os|
  supports os
end

depends 'build-essential'

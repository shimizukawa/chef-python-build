#
# Cookbook Name:: python-build
# Recipe:: default
#
# Copyright 2013, Takayuki SHIMIZUKAWA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require_recipe 'build-essential'

package 'libsqlite3-dev'    #for python
package 'libreadline6-dev'  #for python
package 'libgdbm-dev'       #for python
package 'zlib1g-dev'        #for python
package 'libbz2-dev'        #for python
package 'sqlite3'           #for python
#pakcage 'tk-dev'           #for python, not found on ubuntu-12.04?
package "libjpeg62-dev"     #for PIL

package "gettext"           #for sphinx test
package "pypy"              #for sphinx test

node.python_build.versions.each do |version|
  python_build version do
    version
    install_prefix node.python_build.install_prefix
  end

  node.python_build.packages.each do |package|
    python_package package do
      python_version version
      python_prefix  node.python_build.install_prefix
    end
  end
end

# Cookbook Name:: python-version
# Attributes:: default
#
# Copyright 2013, Takayuki SHIMIZUKAWA.
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

default["python_build"]["archive_url_base"] = nil
default["python_build"]["install_prefix"] = '/usr/local'
default["python_build"]["versions"] = ['2.7.3']
default["python_build"]["packages"] = []
default["python_build"]["owner"] = "root"
default["python_build"]["group"] = "root"

case node["platform_family"]
when "debian"
  default["python_build"]["depends_libraries"] = [
    'libsqlite3-dev',
    'libreadline6-dev',
    'libgdbm-dev',
    'zlib1g-dev',
    'libbz2-dev',
    'sqlite3',
    'libjpeg62-dev',
    'libfreetype6-dev',
  ]

#TODO: freetype for PIL (centos: 'freetype-devel')
#TODO: tk-dev  # not found on ubuntu-12.04?
#TODO: lxml
#TODO: mod_wsgi

when "rhel", "fedora", "suse"
  default["python_build"]["depends_libraries"] = [
    'sqlite-devel',
    'readline-devel',
    'gdbm-devel',
    'zlib-devel',
    'bzip2-devel',
    'libjpeg-devel',
    'freetype-devel',
    #'sqlite3', #what package name on centos? and is this need?
  ]
end

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

default["python_build"]["archive_url_base"] = nil  #"http://python.org/ftp/python/{version}/"
default["python_build"]["archive_file"] = nil      #"Python-#{version}.tgz"
default["python_build"]["install_prefix"] = '/usr/local'
default["python_build"]["versions"] = []
default["python_build"]["packages"] = []
default["python_build"]["owner"] = "root"
default["python_build"]["group"] = "root"
default["python_build"]["find_links"] = []

case node["platform_family"]
when "debian"
  default["python_build"]["depends_libraries"] = [
    'libssl-dev',
    'libsqlite3-dev',    #'libsqlite-dev',
    'libreadline6-dev',  #'libreadline-dev',
    'libgdbm-dev',
    'zlib1g-dev',
    'libbz2-dev',
    'tk-dev',
    'libdb-dev',
    'libncurses-dev',
    'liblzma-dev',
    'sqlite3',
    'libjpeg62-dev',
    'libfreetype6-dev',
  ]

#TODO: lxml
#TODO: mod_wsgi

when "rhel", "fedora", "suse"
  default["python_build"]["depends_libraries"] = [
    'openssl-devel',
    'sqlite-devel',
    'readline-devel',
    'zlib-devel',
    'bzip2-devel',
    #'tk-dev',         #this is ubuntu package name. Find for RHEL.
    #'libdb-dev',      #this is ubuntu package name. Find for RHEL.
    #'libncurses-dev', #this is ubuntu package name. Find for RHEL.
    #'liblzma-dev',    #this is ubuntu package name. Find for RHEL.
    'libjpeg-devel',
    'freetype-devel',
    #'sqlite3', #what package name on centos? and is this need?
  ]
  unless node["platform"] == 'redhat' && node["platform_version"][0] == '6'
    default["python_build"]["depends_libraries"] << 'gdbm-devel'
  end
end

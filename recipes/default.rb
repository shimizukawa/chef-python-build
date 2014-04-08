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
include_recipe 'build-essential'

node.python_build.depends_libraries.each do |name|
  package name
end

node.python_build.versions.each do |version|
  python_build version do
    version
    configure_options node.python_build.configure_options
    install_prefix node.python_build.install_prefix
    owner node.python_build.owner
    group node.python_build.group
  end

  packages = Array(node.python_build.packages).dup
  packages << 'ssl' if version < '2.6'
  packages.each do |package|
    python_package package do
      python_version version
      python_prefix  node.python_build.install_prefix
      owner node.python_build.owner
      group node.python_build.group
      find_links node.python_build.find_links
    end
  end
end

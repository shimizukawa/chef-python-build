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

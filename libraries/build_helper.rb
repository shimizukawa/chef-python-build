#
# Cookbook Name:: python-build
# cookbook:: python-build
# Library:: extractor
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

require 'open-uri'

EXT_TYPE_CMD = {
  '.tar' => ['tar', 'xf'],
  '.tgz' => ['tar', 'zxf'],
  '.tar.gz' => ['tar', 'zxf'],
  '.tar.bz2' => ['tar', 'jxf'],
  '.tar.xz' => ['tar', 'Jxf'],
  '.zip' => ['unzip', ''],
  '.gz' => ['gzip', '-d'],
  '.bz2' => ['bzip2', '-d'],
}
EXT_TYPES = EXT_TYPE_CMD.keys.collect{|k| [k.length, k]}.sort.reverse.collect{|n,k|k}

class BuildHelper
  #attr_reader :node

  #def initialize(node)
  #  @node = node.to_hash
  #end

  def self.make_extract_command(path)
    lpath = path.downcase
    EXT_TYPES.each do |ext|
      if lpath[-ext.length..-1] == ext
        cmd, opt = EXT_TYPE_CMD[ext]
        return [cmd, opt, path].join(' ')
      end
    end
    "tar zxf #{path}"  #fall-back for unknown extension.
  end

  def self.extract_name(path)
    lpath = path.downcase
    EXT_TYPES.each do |ext|
      if lpath[-ext.length..-1] == ext
        return path[0...-ext.length]
      end
    end
    path[0..-File::extname(path).length]  #fall-back for unknown extension.
  end


  def self.expected_python(target, expected_version)
    if File.exists?(target)
      actual_version = IO.popen("#{target} -V 2>&1", "w+") {|f| f.read}.split.last
      actual_version == expected_version
    else
      false
    end
  end

  def self.download(archive_src, archive_dest)
    unless File.exists?(archive_dest)
      open(archive_src, 'rb') do |input|
        open(archive_dest, 'wb') do |output|
          while data = input.read(8192) do
            output.write(data)
          end
        end
      end
    end
  end

end


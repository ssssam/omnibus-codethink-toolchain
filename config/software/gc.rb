#
# Copyright 2018 Codethink Ltd.
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

name "gc"
default_version "7.6.4"

source :url => "http://www.hboehm.info/gc/gc_source/gc-#{version}.tar.gz",
       :md5 => "cf390c4f7f2556a67ec49e964c86c847"

dependency "libatomic_ops"

relative_path "gc-#{version}"

build do
  env = with_codethink_compiler_flags(ohai["platform"], with_embedded_path)

  configure_command = [
    "./configure --prefix=#{install_dir}",
    "--enable-cplusplus",
    ]

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end

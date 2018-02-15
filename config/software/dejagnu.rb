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

name "dejagnu"
default_version "1.6"

source :url => "http://ftp.gnu.org/gnu/dejagnu/dejagnu-#{version}.tar.gz",
       :md5 => "1fdc2eb0d592c4f89d82d24dfdf02f0b"


relative_path "dejagnu-#{version}"

build do
  env = with_codethink_compiler_flags(ohai["platform"], with_embedded_path)

  configure_command = [
    "./configure --prefix=#{install_dir}",
    ]

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end

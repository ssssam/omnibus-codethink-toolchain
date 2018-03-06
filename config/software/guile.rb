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

name "guile"
default_version "1.8.8"

source :url => "http://ftp.gnu.org/gnu/guile/guile-#{version}.tar.gz",
       :md5 => "18661a8fdfef13e2fcb7651720aa53f3"

dependency "libtool"
dependency "libunistring"
dependency "gc"

relative_path "guile-#{version}"

build do
  env = with_codethink_compiler_flags(ohai["platform"], with_embedded_path)
  env["CFLAGS"]  += " -I/opt/codethink-gcc/embedded/include"
  env["LDFLAGS"] += " -L/opt/codethink-gcc/embedded/lib"
  env["PKG_CONFIG_PATH"] += " /opt/codethink-gcc/lib/pkgconfig/"

  configure_command = [
    "./configure --prefix=#{install_dir}",
    "--disable-error-on-warning",
    ]

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end

#
# Copyright 2014 Chef Software, Inc.
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

name "mpc"
default_version "1.0.3"

dependency "gmp"
dependency "mpfr"

version("1.0.3") { source md5: "d6a1d5f8ddea3abd2cc3e98f58352d26" }

source url: "https://ftp.gnu.org/gnu/mpc/mpc-#{version}.tar.gz"

relative_path "mpc-#{version}"

build do
  env = with_codethink_compiler_flags(ohai["platform"], with_embedded_path)

  configure_command = ["./configure",
                       "--prefix=#{install_dir}"]

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end

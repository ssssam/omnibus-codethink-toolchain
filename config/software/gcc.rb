# Omnibus::Software definition to build the GNU Compiler Collection.
# Copyright 2017 Codethink Ltd.
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

name "gcc"
default_version "sam/fortran-legacy-support-7_0-20170322"

source git: "https://github.com/CodethinkLabs/gcc/"

dependency "gmp"
dependency "mpfr"
dependency "mpc"
dependency "libiconv"

build do
  env = with_codethink_compiler_flags(ohai["platform"], with_embedded_path)

  configure_command = [
    "./configure",
    "--prefix=#{install_dir}/embedded",
    "--enable-languages=c,c++,fortran",
    # This is (a) for speed, (b) because the embedded libintl breaks on AIX
    "--disable-nls",
    # Dependency requirements are higher on x86 when multilib is enabled,
    # we may need a multilib compiler soon though.
    "--disable-multilib"]

  if not solaris? and not aix?
    # Useful C++ debugging feature, see `-fvtable-verify=` option.
    configure_command += ["--enable-vtable-verify"]
  end

  if solaris?
    # Only the GNU version of M4 can be used
    env["M4"] = "gm4"
  end

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env, timeout: 14400
  make "-j #{workers} install", env: env
end

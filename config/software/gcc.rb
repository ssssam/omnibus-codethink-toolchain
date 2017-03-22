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
  # Setup a default environment from Omnibus - you should use this Omnibus
  # helper everywhere. It will become the default in the future.
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = [
    "./configure",
    "--prefix=#{install_dir}/embedded",
    "--enable-languages=c,c++,fortran",
    # Useful C++ debugging feature, see `-fvtable-verify=` option.
    "--enable-vtable-verify",
    # This is (a) for speed, (b) because the embedded libintl breaks on AIX
    "--disable-nls",
    # Dependency requirements are higher on x86 when multilib is enabled,
    # we may need a multilib compiler soon though.
    "--disable-multilib"]

  if solaris?
    # Only the GNU version of M4 can be used
    env["M4"] = "gm4"
    # The Solaris packages for GMP and MPFR put the headers in non-standard
    # places.
    configure_command += [
      "--with-gmp-include=/usr/include/gmp",
      "--with-mpfr-include=/usr/include/mpfr"]

    # The with_standard_compiler_flags function sets:
    #     CC=gcc -m64 -static-libgcc
    # It sets nothing for C++, so the build fails when trying to link some 32-bit C++
    # code against 64-bit C libraries.
    # This could possibly be upstreamed in Omnibus itself.
    # May also need doing for Fortran.
    env["CXX"] = "g++ -m64"
  end

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env, timeout: 14400
  make "-j #{workers} install", env: env
end

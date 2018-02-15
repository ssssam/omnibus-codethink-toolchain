#
# Omnibus::Software definition to build the GNU Compiler Collection.
# Copyright 2017,2018 Codethink Ltd.
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

# It would be nice to use the real GCC version number here, but the
# Omnibus Git fetcher uses this value as the ref name to fetch and
# there appears to be no way to override that.
default_version "#{ENV['OMNIBUS_GCC_GIT_REF']}"

source git: "https://github.com/CodethinkLabs/gcc/"

dependency "gmp"
dependency "mpfr"
dependency "mpc"
dependency "libiconv"
dependency "autogen"
dependency "dejagnu"

if solaris?
  dependency "binutils"
end

if default_version.to_s.strip.empty?
  abort("\n\tERROR: OMNIBUS_GCC_GIT_REF is empty. \n\tPlease, set OMNIBUS_GCC_GIT_REF with a valid git ref.")
end

build do
  env = with_codethink_compiler_flags(ohai["platform"], with_embedded_path)

  configure_command = [
    "./configure",
    "--prefix=#{install_dir}",
    "--enable-languages=c,c++,fortran",
    "--with-pkgversion=codethink-toolchain",
    # The bootstrap functions as a self-test, but we assume that if you are
    # building a package you already tested the commit being built.
    "--disable-bootstrap",
    # This is (a) for speed, (b) because the embedded libintl breaks on AIX
    "--disable-nls",
    ]

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env, timeout: 14400
  make "-j #{workers} install", env: env
  make "-j #{workers} check", env: env
end

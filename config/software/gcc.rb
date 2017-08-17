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

# It would be nice to use the real GCC version number here, but the
# Omnibus Git fetcher uses this value as the ref name to fetch and
# there appears to be no way to override that.
default_version "codethink/fortran-extra-legacy-7.2"

source git: "https://github.com/CodethinkLabs/gcc/"

dependency "gmp"
dependency "mpfr"
dependency "mpc"
dependency "libiconv"

if solaris?
  dependency "binutils"
end

build do
  env = with_codethink_compiler_flags(ohai["platform"], with_embedded_path)

  configure_command = [
    "./configure",
    "--prefix=#{install_dir}",
    "--enable-languages=c,c++,fortran",
    # The bootstrap functions as a self-test, but we assume that if you are
    # building a package you already tested the commit being built.
    "--disable-bootstrap",
    # This is (a) for speed, (b) because the embedded libintl breaks on AIX
    "--disable-nls",
    ]

  # Ideally we want to be able to produce 32- and 64-bit binaries on all
  # platforms.
  #
  # Currently the multilib build for GCC on AIX is broken so we can only
  # produce 32-bit versions of the support libraries on that platform, and thus
  # only 32-bit binaries. The first issue appears to be that both 32-bit and
  # 64-bit AIX are called powerpc-ibm-aix7.2.0.0 so the 32-bit and 64-bit
  # versions of the libraries are muddled together.
  #
  # There's actually no support for multilib on Solaris at this point.
  # Enabling it is harmless but we still only get the 32bit libraries.
  if aix?
    configure_command += ["--disable-multilib"]
  else
    configure_command += ["--enable-multilib"]
  end

  if solaris?
    # All this is required to make multilib work on Solaris. The architecture
    # is autodetected as 'sparc' but the multlib option is silently ignored
    # in that case. If we force 'sparcv9' it works. Except that the build
    # then fails at zlib -- we work around that by using the system version
    # of zlib (which is a good idea anyway).
    configure_command += ["--build=sparcv9-sun-solaris2.11",
                          "--host=sparcv9-sun-solaris2.11",
                          "--target=sparcv9-sun-solaris2.11",
                          "--with-system-zlib"]
  end

  if not solaris? and not aix?
    # Useful C++ debugging feature, see `-fvtable-verify=` option.
    configure_command += ["--enable-vtable-verify"]
  end

  if solaris?
    # Only the GNU version of M4 can be used
    env["M4"] = "gm4"
    # Configure with GNU linker instead of Solaris (default)
    configure_command += ["--with-gnu-ld", "--with-ld=#{install_dir}/bin/ld"]
    # Configure with GNU assembler instead of Solaris (default)
    configure_command += ["--with-gnu-as", "--with-as=#{install_dir}/bin/as"]
  end

  if aix?
    # Only the GNU version of M4 can be used
    env["M4"] = "/opt/freeware/bin/m4"
  end

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env, timeout: 14400
  make "-j #{workers} install", env: env
end

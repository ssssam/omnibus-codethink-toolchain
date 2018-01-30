# Codethink's Omnibus packaging for the GNU and LLVM Toolchains.

This is an example of building and packaging the GNU and LLVM toolchains
on x86_64 platform using Chef Software's [Omnibus](https://github.com/chef/omnibus/).

Our aim is to provide the C, C++ and Fortran compilers from GCC version 7 and
LLVM 5.x.x suite (Clang, PGI's Flang).

This project is not directly based on the Chef Software
[omnibus-software](https://github.com/chef/omnibus-software)
and [omnibus-toolchain](https://github.com/chef/omnibus-toolchain)
repos. Although these projects share some goals, the focus is different
and the small size of the packaging instructions means it's easier to
duplicate things here than it is to maintain non-upstreamable forks of
the Chef Software projects.

All code in this repository is licensed under the
[Apache License version 2.0](https://www.apache.org/licenses/LICENSE-2.0),
unless otherwise noted.

## Instructions

This README doesn't cover installing the necessary dependencies. In brief
you need a working GNU toolchain, GNU Flex, Ruby, Bundler and Omnibus. Maybe
more.

For LLVM toolchain, you also need GNU toolchain 4.8 (or higher), cmake 3.4.3
(or higher) and python (at least 2.7).

On Red Hat style systems we also require the rpm-build package.

### Running a build

You can run Omnibus from your own user account, or some kind of dedicated
'build' user if you prefer. Omnibus requires access to the package install
directory which is set as `/opt/codethink` so you'll need to create this
in advance and give write access to the correct user. For example:

    sudo mkdir /opt/codethink-toolchain
    sudo chown $(whoami):$(whoami) /opt/codethink-toolchain

Omnibus defaults to using /var/cache/omnibus for its intermediate files. You
can make it use a local directory instead by adding this to the commandline:

    --override base_dir:./local

Builds will then store all intermediate files in the ./local directory, and
will not require root privileges to install.

### Optional stuff

You can change the number of parallel workers by adding `workers:N` to the
--override parameter. For example, to set a base dir of ./local and enforce
`make -j 2`, you would run:

    omnibus build codethink-toolchain --override base_dir:./local workers:2

To run the same for PGI's Flang, you would execute:

    omnibus build codethink-flang --override base_dir:./local workers:2

## Platform notes

### x86_64-redhat-linux

We build 64-bit toolchain binaries on x86_64 hosts. The compilers default to
producing 64-bit binaries, but multilib is supported and so you can tell them
to output 32-bit binaries by passing `-m32`. This is a little-endian platform.

If you need 32-bit toolchain binaries, the simplest solution is to build the
package on an x86_32 host instead. Multilib should work there too.

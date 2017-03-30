# Codethink's example Omnibus packaging for the GNU Toolchain

This is an example of building and packaging the GNU toolchain on multiple
platforms using Chef Software's [Omnibus](https://github.com/chef/omnibus/).

Our aim is to support the C, C++ and Fortran compilers from GCC version 7 on
these platforms:

  * Red Hat Linux 6
  * Oracle Solaris 12.5
  * IBM AIX 7.3

Only native building is supported.

*This a work in progress, do not use for anything important yet!*

This project is not directly based on the Chef Software
[omnibus-software](https://github.com/chef/omnibus-software)
and [omnibus-toolchain](https://github.com/chef/omnibus-toolchain)
repos. Although these projects share some goals, the focus is different
and the small size of the packaging instructions means it's easier to
duplicate things here than it is to maintain non-upstreamable forks of
the Chef Software projects.

All code is licensed under the
[Apache License version 2.0](https://www.apache.org/licenses/LICENSE-2.0).

## Instructions

This README doesn't cover installing the necessary dependencies. In brief
you need a working GNU toolchain, GNU Flex, Ruby, Bundler and Omnibus. Maybe
more.

On Red Hat style systems we also require the rpm-build package.

### Building on a dedicated build worker

By default Omnibus operates as a system build service, which is useful on
dedicated build machines. To run in this mode, just execute the following
command as root:

    omnibus build codethink-toolchain

### Test builds for developers

If you are a developer running this on your laptop, you hopefully balked
at the idea of running a random command as root. To test things locally,
you'll probably want to download everything into the current directory,
which you can do by adding this to the Omnibus command line:

    base_dir --override base_dir:./local

You'll also need to precreate the target install directory and give your
user access:

    sudo mkdir /opt/codethink-toolchain
    sudo chown $(whoami):$(whoami) /opt/codethink-toolchain

Builds will then store all intermediate files in the ./local directory, and
will not require root privileges to install.

### Optional stuff

You can change the number of parallel workers by adding `workers:2` to the
--override parameter (which is a semicolon-separated list)

# Codethink's example Omnibus packaging for the GNU Toolchain

This is an example of building and packaging the GNU toolchain on multiple
platforms using Chef Software's [Omnibus](https://github.com/chef/omnibus/).

Our aim is to support the C, C++ and Fortran compilers from GCC version 7 these
platforms:

  * Red Hat Linux 6
  * Oracle Solaris 12.5
  * IBM AIX 7.3

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

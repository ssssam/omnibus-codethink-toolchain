# This contains overrides for the "standard" compiler flags built into Omnibus.
#
# To make it available to all software definitions, it's imported from the
# project definition using `require_relative`.
#
# The standard Omnibus flags maybe here:
#   https://github.com/chef/omnibus/blob/master/lib/omnibus/software.rb#L653

def with_codethink_compiler_flags(platform, env = {}, opts = {})
  env = with_standard_compiler_flags(env = env, opts = opts)

  compiler_flags = 
    case platform
    when "aix"
      # Chef Software use the IBM compiler on AIX, but it's probably more
      # reliable for us to compile GCC with GCC.
      #
      # We build a 32-bit GCC on AIX. A 64-bit compile is apparently
      # unsupported[1]. Certainly, adding -maix64 to CFLAGS, CXXFLAGS
      # and FCFLAGS isn't enough because some of GCC's nested configure
      # scripts ignore them. (If you see "redefined symbol" errors for
      # math functions like fabsl() while building libstdc++, check the
      # relevant config.log -- probably the configure tests failed because
      # it ignored CXXFLAGS). Passing --host=ppc64-ibm-aix7.2 doesn't
      # achieve anything, patching the GCC build system to add appropriate
      # flags when building for ppc64 on AIX is probably the way forward
      # if we do need to fix this.
      #
      # [1]. https://gcc.gnu.org/bugzilla/show_bug.cgi?id=25119
      {
	"ARFLAGS" => "",  # overriding -X64
        "CC" => "gcc",
        "CXX" => "g++",
        "CFLAGS" => "-I#{install_dir}/embedded/include -O2",
        "LDFLAGS" => "-L#{install_dir}/embedded/lib",
        "LD" => "ld",
	"OBJECT_MODE" => "32"
      }
    when "solaris2"
      {
        "CC" => "gcc",
        "CXX" => "g++",
        "CFLAGS" => "-I#{install_dir}/embedded/include -O2",
        "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib",
      }
    else {}
    end

  return env.merge(compiler_flags).
    merge("CXXFLAGS" => compiler_flags["CFLAGS"]).
    merge("CPPFLAGS" => compiler_flags["CFLAGS"])
end

# This is a hack to force Omnibus to use RPM packaging on AIX instead of
# BFF packaging. I know nothing about BFF except that we don't use it, and
# that Omnibus requires passwordless `sudo` access to be able to produce such a
# package.
#
# A neater fix would be to modify Omnibus upstream to allow choosing a
# different package format.
module Omnibus
  module Packager
    PLATFORM_PACKAGER_MAP = {
      "rhel"     => RPM,
      "aix"      => RPM,
      "solaris"  => Solaris,
      "ips"      => IPS,
    }.freeze
  end
end


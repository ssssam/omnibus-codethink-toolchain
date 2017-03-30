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
      {
        "ARFLAGS" => "-X64",
        "CC" => "gcc",
        "CXX" => "g++",
        "CFLAGS" => "-maix64 -I#{install_dir}/embedded/include -O2",
        "LDFLAGS" => "-L#{install_dir}/embedded/lib",
        "LD" => "ld",
        "OBJECT_MODE" => "64",
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

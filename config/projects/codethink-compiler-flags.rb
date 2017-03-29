# This contains overrides for the "standard" compiler flags built into Omnibus.
#
# To make it available to all software definitions, it's imported from the
# project definition using `require_relative`.

def with_codethink_compiler_flags(platform, env = {}, opts = {})
  env = with_standard_compiler_flags(env = env, opts = opts)
  compiler_flags = 
    case platform
    when "aix"
      # Use GCC instead of xlC on AIX.
      # For now we don't force a 64-bit build, it probably makes sense to do that though.
      {
        "CC" => "gcc",
        "CXX" => "gcc",
        "CFLAGS" => "-I#{install_dir}/embedded/include -O2",
        "LDFLAGS" => "-L#{install_dir}/embedded/lib",
        "LD" => "ld",
      }
    when "solaris2"
      {
        "CC" => "gcc",
        "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib",
        "CFLAGS" => "-I#{install_dir}/embedded/include -O2",
      }
    else {}
    end

  return env.merge(compiler_flags).
    merge("CXXFLAGS" => compiler_flags["CFLAGS"]).
    merge("CPPFLAGS" => compiler_flags["CFLAGS"])
end

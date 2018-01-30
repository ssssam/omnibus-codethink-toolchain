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

name "flang"
default_version "master"

source git: "https://github.com/flang-compiler/flang.git"

dependency "llvm"
dependency "clang-for-flang"
dependency "openmp-llvm"

flang_build_dir = "#{build_dir}/build-flang"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  mkdir flang_build_dir

  command "cmake3" \
    " -DCMAKE_INSTALL_PREFIX=#{install_dir}" \
    " -DCMAKE_INSTALL_RPATH=#{install_dir}/lib" \
    " -DCMAKE_BUILD_TYPE=Release" \
    " -DCMAKE_C_COMPILER=#{install_dir}/bin/clang" \
    " -DCMAKE_CXX_COMPILER=#{install_dir}/bin/clang++" \
    " -DCMAKE_Fortran_COMPILER=#{install_dir}/bin/flang" \
    " -DLLVM_CONFIG=#{install_dir}/bin/llvm-config" \
    " -DFLANG_LIBOMP=#{install_dir}/lib/libomp.so" \
    " #{project_dir}", env: env, cwd: flang_build_dir

  make "-j #{workers}", env: env, cwd: flang_build_dir
  make "-j #{workers} install", env: env, cwd: flang_build_dir
end

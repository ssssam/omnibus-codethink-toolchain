# Copyright 2018 Codethink Ltd.
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

name "clang-for-flang"
default_version "flang_release_50"

source git: "https://github.com/flang-compiler/clang.git"

dependency "ninja"
dependency "llvm"

clang_for_flang_build_dir = "#{build_dir}/build-clang-for-flang"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  mkdir clang_for_flang_build_dir

  command "cmake3" \
    " -G Ninja" \
    " -DCMAKE_BUILD_TYPE=Release" \
    " -DCMAKE_INSTALL_PREFIX=#{install_dir}" \
    " -DCMAKE_C_COMPILER=#{'$(which gcc)'}" \
    " -DCMAKE_CXX_COMPILER=#{'$(which g++)'}" \
    " -DCMAKE_CXX_LINK_FLAGS='-L$$/opt/rh/devtoolset-7/root/usr/lib64 -Wl,-rpath,$$/opt/rh/devtoolset-7/root/usr/lib64'" \
    " -DGCC_INSTALL_PREFIX=/opt/rh/devtoolset-7/root/usr" \
    " -DLLVM_CONFIG=#{install_dir}/bin/llvm-config" \
    " -DLLVM_TARGETS_TO_BUILD=X86" \
    " #{project_dir}", env: env, cwd: clang_for_flang_build_dir

  command "ninja -j #{workers}", env: env, cwd: clang_for_flang_build_dir
  command "ninja -j #{workers} install", env: env, cwd: clang_for_flang_build_dir
end

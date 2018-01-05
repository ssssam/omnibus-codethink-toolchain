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

name "openmp-llvm"
default_version "release_50"

source git: "https://github.com/llvm-mirror/openmp.git"

dependency "ninja"

openmp_llvm_dir = "#{build_dir}/build-openmp-llvm"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  mkdir openmp_llvm_dir

  command "cmake3" \
    " -G Ninja" \
    " -DCMAKE_INSTALL_PREFIX=#{install_dir}" \
    " -DCMAKE_BUILD_TYPE=Release" \
    " -DLIBOMP_LLVM_LIT_EXECUTABLE=#{build_dir}/build-llvm/bin/llvm-lit" \
    " #{project_dir}", env: env, cwd: openmp_llvm_dir

  command "ninja -j #{workers}", env: env, cwd: openmp_llvm_dir
  command "ninja -j #{workers} install", env: env, cwd: openmp_llvm_dir
end

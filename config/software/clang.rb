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

name "clang"
default_version "5.0.1"

source :url => "http://releases.llvm.org/#{version}/cfe-#{version}.src.tar.xz",
       :md5 => "e4daa278d8f252585ab73d196484bf11"

dependency "ninja"
dependency "llvm"

relative_path "cfe-#{version}.src"

clang_build_dir = "#{build_dir}/build-cfe"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  mkdir clang_build_dir

  command "cmake3" \
    " -G Ninja" \
    " -DLLVM_CONFIG=#{install_dir}/bin/llvm-config" \
    " -DBUILD_SHARED_LIBS=OFF" \
    " -DCMAKE_BUILD_TYPE=Release" \
    " -DCMAKE_INSTALL_PREFIX=#{install_dir}" \
    " -DLLVM_TARGETS_TO_BUILD=X86" \
    " -DCMAKE_C_COMPILER=#{'$(which gcc)'}" \
    " -DCMAKE_CXX_COMPILER=#{'$(which g++)'}" \
    " -DGCC_INSTALL_PREFIX=/opt/rh/devtoolset-7/root/usr" \
    " -DCMAKE_CXX_LINK_FLAGS='-L$$/opt/rh/devtoolset-7/root/usr/lib64 -Wl,-rpath,$$/opt/rh/devtoolset-7/root/usr/lib64'" \
    " #{project_dir}", env: env, cwd: clang_build_dir
   
  command "ninja -j #{workers}", env: env, cwd: clang_build_dir
  command "ninja -j #{workers} install", env: env, cwd: clang_build_dir

end

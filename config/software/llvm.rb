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

name "llvm"
default_version "5.0.1"

source :url => "http://releases.llvm.org/#{version}/llvm-#{version}.src.tar.xz",
       :md5 => "3a4ec6dcbc71579eeaec7cb157fe2168"

dependency "ninja"
dependency "zlib"
dependency "ncurses"

relative_path "llvm-#{version}.src"

llvm_build_dir = "#{build_dir}/build-llvm"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  mkdir llvm_build_dir

  command "cmake3" \
    " -G Ninja" \
    " -DCMAKE_BUILD_TYPE=Release" \
    " -DBUILD_SHARED_LIBS=OFF" \
    " -DCMAKE_C_COMPILER=#{'$(which gcc)'}" \
    " -DCMAKE_CXX_COMPILER=#{'$(which g++)'}" \
    " -DCMAKE_INSTALL_PREFIX=#{install_dir}" \
    " -DPYTHON_EXECUTABLE=#{'$(which python)'}" \
    " -DLLVM_TARGETS_TO_BUILD=X86" \
    " #{project_dir}", env: env, cwd: llvm_build_dir
  
  command "ninja -j #{workers}", env: env, cwd: llvm_build_dir
  command "ninja -j #{workers} install", env: env, cwd: llvm_build_dir

end

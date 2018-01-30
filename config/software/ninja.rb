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

name "ninja"
default_version "release"

source git: "git://github.com/ninja-build/ninja.git"

relative_path "ninja"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  mkdir "#{install_dir}/embedded/bin"
  command "./configure.py --bootstrap", env: env
  copy "./ninja", "#{install_dir}/embedded/bin"
end

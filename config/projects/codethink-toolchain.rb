#
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

name "codethink-toolchain"
maintainer "Codethink Ltd."
homepage "https://www.github.com/CodethinkLabs/omnibus-codethink-toolchain/"

install_dir "/opt/codethink-toolchain"

build_version Omnibus::BuildVersion.semver
build_iteration 1

# toolchain dependencies/components
dependency "gcc"

# Version manifest file
dependency "version-manifest"

exclude "**/.git"
exclude "**/bundler/git"

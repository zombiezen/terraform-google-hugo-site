# Copyright 2019 Ross Light
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

variable "project" {
  default     = ""
  description = "GCP/Firebase Project ID to use if different than google provider project"
}

variable "repository_name" {
  type        = string
  description = "Name of Google Source Repository to provision"
}

variable "cloud_build_trigger" {
  default     = false
  description = "If set to true, then run Cloud Build to deploy to Hugo on every commit to main."
}

variable "hugo_env" {
  default     = []
  description = "List of environment variables to pass to Hugo during build without the `HUGO_` prefix."
}

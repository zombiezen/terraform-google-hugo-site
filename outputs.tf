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

output "project" {
  value       = data.google_project.project.project_id
  description = "GCP/Firebase Project ID"
}

output "repository_project" {
  value       = google_sourcerepo_repository.site.project
  description = "Name of Google Source Repository to provision"
}

output "repository_name" {
  value       = google_sourcerepo_repository.site.name
  description = "Name of Google Source Repository to provision"
}

output "repository_url" {
  value       = "ssh://source.developers.google.com:2022/p/${data.google_project.project.project_id}/r/${google_sourcerepo_repository.site.name}"
  description = "Git remote URL for the Google Source Repository. Does not include username, which should be your Google account email."
}

output "hugo_image" {
  value       = local.hugo_image
  description = "Hugo Docker image name"
}

output "firebase_image" {
  value       = local.firebase_image
  description = "Firebase Docker image name"
}

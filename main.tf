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

terraform {
  required_version = ">=0.13"

  required_providers {
    google = {
      version = "~>3.40"
    }
  }
}

data "google_project" "project" {
  project_id = var.project
}

# Git repository

resource "google_project_service" "sourcerepo" {
  project            = data.google_project.project.project_id
  service            = "sourcerepo.googleapis.com"
  disable_on_destroy = false
}

resource "google_sourcerepo_repository" "site" {
  project = data.google_project.project.project_id
  name    = var.repository_name

  depends_on = [google_project_service.sourcerepo]
}

# Cloud Build

resource "google_project_service" "cloudbuild" {
  project            = data.google_project.project.project_id
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudresourcemanager" {
  project            = data.google_project.project.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "firebase" {
  project            = data.google_project.project.project_id
  service            = "firebase.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "firebasehosting" {
  project            = data.google_project.project.project_id
  service            = "firebasehosting.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  project            = data.google_project.project.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

locals {
  hugo_image     = "ghcr.io/zombiezen/hugo:0.80.0"
  firebase_image = "ghcr.io/zombiezen/firebase"
}

resource "google_project_iam_custom_role" "firebase_deploy" {
  project     = data.google_project.project.project_id
  role_id     = "firebaseHostingDeploy"
  title       = "Firebase Hosting Deploy"
  description = "Deployer to Firebase Hosting"

  # Required permissions detailed here:
  # https://firebase.google.com/docs/projects/iam/permissions#required_all_roles
  #
  # Skipped "resourcemanager.projects.list" because it can't be applied.

  permissions = [
    "firebase.billingPlans.get",
    "firebase.clients.get",
    "firebase.links.list",
    "firebase.projects.get",
    "firebasehosting.sites.create",
    "firebasehosting.sites.get",
    "firebasehosting.sites.list",
    "firebasehosting.sites.update",
    "firebaseanalytics.resources.googleAnalyticsReadAndAnalyze",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
    "servicemanagement.projectSettings.get",
    "serviceusage.apiKeys.get",
    "serviceusage.apiKeys.getProjectForKey",
    "serviceusage.apiKeys.list",
    "serviceusage.operations.get",
    "serviceusage.operations.list",
    "serviceusage.quotas.get",
    "serviceusage.services.get",
    "serviceusage.services.list",
  ]

  depends_on = [
    google_project_service.iam,
  ]
}

resource "google_project_iam_member" "cloudbuild_firebase_deploy" {
  project = data.google_project.project.project_id
  role    = "projects/${google_project_iam_custom_role.firebase_deploy.project}/roles/${google_project_iam_custom_role.firebase_deploy.role_id}"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_cloudbuild_trigger" "deploy" {
  project     = data.google_project.project.project_id
  description = "Deploy to Firebase on push to main"
  disabled    = false == var.cloud_build_trigger

  build {
    step {
      name = local.hugo_image
      args = []
      env  = formatlist("HUGO_%s", var.hugo_env)
    }

    step {
      name = local.firebase_image
      args = ["deploy"]
    }
  }

  trigger_template {
    branch_name = "^(main|master)$"
    project_id  = google_sourcerepo_repository.site.project
    repo_name   = google_sourcerepo_repository.site.name
  }

  depends_on = [
    google_project_iam_member.cloudbuild_firebase_deploy,
    google_project_service.cloudbuild,
    google_project_service.firebase,
    google_project_service.firebasehosting,
  ]
}

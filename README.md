# Terraform module for Hugo on Firebase Hosting

This is a Terraform module that I use to configure push-to-deploy (GitOps) Hugo
sites. It requires the [Google Cloud SDK][] to be installed locally and an
existing [Firebase project][Firebase console]. The module provisions:

- A [Cloud Source Repository][] to store your Hugo site
- A [Cloud Build][] trigger that will push the site to Firebase Hosting
- GCP project APIs and IAM policies needed to perform the above functions

To get started:

1.  Install the [Google Cloud SDK][], [Terraform][Terraform install], and
    [Git][Git install].

2.  Create a [Firebase project][Firebase console] with the Blaze Plan.

3.  [Create a Hugo site][].

4.  Add the following `firebase.json` file at the top of the Hugo site directory:

    ```
    {
      "hosting": {
        "public": "public",
        "ignore": [
          "firebase.json",
          "**/.*",
          "**/node_modules/**"
        ]
      }
    }
    ```

5.  Add the following `.firebaserc` file at the top of the Hugo site directory,
    replacing `PROJECTID` with your Firebase project ID.

    ```
    {
      "projects": {
        "default": "PROJECTID"
      }
    }
    ```

6.  Add the following `main.tf` file at the top of the Hugo site directory,
    replacing `PROJECTID` with your Firebase project ID and `NAME` with your
    site's directory name:

    ```terraform
    terraform {
      required_version = ">=0.13"
    }

    provider "google" {
      project = "PROJECTID"
    }

    module "hugo_site" {
      source  = "zombiezen/hugo-site/google"
      version = "0.3.3"

      repository_name     = "NAME"
      cloud_build_trigger = true
    }

    output "origin_url" {
      value = module.hugo_site.repository_url
    }
    ```

7.  Run `git init && git add . && git commit -m "first"` at the top of the Hugo
    site directory. This creates your initial commit.

8.  Run `terraform init && terraform apply` at the top of the Hugo site
    directory. This will provision the resources for your site.

9.  Run `git remote add origin $(terraform output origin_url)"` at the top of
    the Hugo site directory. This configures your local Git repository to push
    to the newly created Cloud Source Repository. You may need to follow the
    steps in [Cloning Repositories][Cloud Source Repository cloning] to get your
    SSH key set up.

10. Run `git push -u origin main` to deploy your website. Enjoy!

You may also want to [connect a custom domain][].

[Cloud Build]: https://cloud.google.com/cloud-build/
[Cloud Source Repository]: https://cloud.google.com/source-repositories/
[Cloud Source Repository cloning]: https://cloud.google.com/source-repositories/docs/cloning-repositories#ssh
[connect a custom domain]: https://firebase.google.com/docs/hosting/custom-domain
[Create a Hugo site]: https://gohugo.io/getting-started/quick-start/
[Firebase console]: https://console.firebase.google.com/
[Firebase Hosting]: https://firebase.google.com/products/hosting/
[Git install]: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
[Google Cloud SDK]: https://cloud.google.com/sdk/docs/
[Terraform install]: https://learn.hashicorp.com/terraform/getting-started/install.html

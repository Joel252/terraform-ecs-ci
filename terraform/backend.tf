/*
 * Configure the backend for the Terraform state
 *
 * In this project, the backend configuration is defined dynamically through GitLab CI/CD. 
 * This means that instead of specifying the backend details in this file, they are passed
 * as arguments during the pipeline execution.
 *
 * In the GitLab pipeline, the backend is defined with terraform init and the
 * -backend-config option, passing values such as the state URL, authentication, and locking.
 *
 * If you want to run Terraform manually, make sure to define the necessary variables for 
 * the backend during execution.
 */

terraform {
  backend "http" {
    # address        = "https://gitlab.com/api/v4/projects/{project_id}/terraform/state/{stage}"
    # lock_address   = "https://gitlab.com/api/v4/projects/{project_id}/terraform/state/{stage}/lock"
    # unlock_address = "https://gitlab.com/api/v4/projects/{project_id}/terraform/state/{stage}/lock"
    # lock_method    = "POST"
    # unlock_method  = "DELETE"
    # username       = "mytoken"
    # password       = "mytoken"
    # retry_wait_min = 5
  }
}

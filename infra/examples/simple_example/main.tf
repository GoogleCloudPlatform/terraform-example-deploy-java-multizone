/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "simple" {
  source     = "../../"
  project_id = var.project_id
  location = {
    region = "us-central1"
    zone   = "us-central1-a"
  }
  availability_type       = "ZONAL"
  vm_sa_email             = google_service_account.service_account.email
  xwiki_sql_user_password = random_password.password.result
  firewall_source_ranges  = ["0.0.0.0/0"]
  xwiki_img_info = {
    image_name    = "us-west1-xwiki-01t-img-efab2b30-5982-4ba0-a115-ffde4eee0434"
    image_project = "migrate-legacy-java-app-gce"
  }
}

resource "random_password" "password" {
  length = 8
}

resource "google_service_account" "service_account" {
  account_id   = "xwiki-compute"
  display_name = "XWiki Compute SA"
  project      = var.project_id
}

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
  source                 = "../../"
  project_id             = var.project_id
  region                 = "us-central1"
  zones                  = ["us-central1-a", "us-central1-f"]
  availability_type      = "ZONAL"
  firewall_source_ranges = ["0.0.0.0/0"]
  xwiki_img_info = {
    image_name    = "hsa-xwiki-vm-img-latest"
    image_project = "migrate-legacy-java-app-gce"
  }
}

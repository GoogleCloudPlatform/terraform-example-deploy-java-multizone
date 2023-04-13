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

resource "google_filestore_instance" "xwiki" {
  name     = "xwiki-${var.zone}-filestore"
  tier     = "BASIC_HDD"
  location = var.zone
  networks {
    network = var.private_network_id
    modes   = ["MODE_IPV4"]
  }
  file_shares {
    capacity_gb = 512
    name        = "xwiki_file_share"
  }
}

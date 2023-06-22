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

output "xwiki_entrypoint_url" {
  description = "Shows the URL of XWiki's index page."
  value       = "http://${module.load_balancer.lb_global_ip}/xwiki"
}

output "xwiki_mig_self_link" {
  description = "MIG hosting XWiki"
  value       = module.vm.xwiki_mig.self_link
}

output "neos_walkthrough_url" {
  description = "Neos Tutorial URL"
  value       = "https://console.cloud.google.com/products/solutions/deployments?walkthrough_id=panels--sic--deploy-java-gce_toc"
}

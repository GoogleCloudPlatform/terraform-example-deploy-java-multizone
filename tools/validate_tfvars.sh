#! /bin/bash
# Copyright 2023 Google LLC
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

PROJECT_ID=$1
REGION=$2
ZONES=$3

if [ -z "$PROJECT_ID" ]; then
  echo "Error: 'PROJECT_ID' is required"
  exit 1
elif [ -z "$REGION" ] || [ "${REGION}" = "global" ]; then
  echo "Error: 'REGION' is required, and it cannot be set to 'global'"
  exit 1
elif [ -z "$ZONES" ]; then
  echo "Error: 'ZONES' is required"
  exit 1
elif [ -n "$ZONES" ]; then
  IFS=" "
  read -ra ZONE_ARRAY <<< "$ZONES"
  for zone in "${ZONE_ARRAY[@]}"; do
    if [[ $zone != $REGION* ]]; then
      echo "Error: 'ZONES' should depend on chosen 'REGION'"
      exit 1
    fi
  done
fi

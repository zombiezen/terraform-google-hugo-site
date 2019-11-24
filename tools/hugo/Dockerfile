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

FROM debian:stretch-slim

ARG HUGO_VERSION=0.59.1
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gdebi-core \
  && curl -fsSLo /tmp/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb \
  && gdebi -n /tmp/hugo.deb \
  && apt-get remove -y \
    ca-certificates \
    curl \
    gdebi-core \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* /tmp/hugo.deb
LABEL com.zombiezen.hugo_version=$HUGO_VERSION

ENTRYPOINT ["/usr/local/bin/hugo"]

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:16.04
MAINTAINER Michael Joyce <joyce@apache.org>

WORKDIR /root/

# Install dependencies
RUN apt update
RUN apt install -y ant openssh-server vim telnet git rsync curl openjdk-8-jdk-headless

# Set up JAVA_HOME
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> $HOME/.bashrc

# Checkout and build the nutch trunk
RUN git clone -b NUTCH-2676-ignore-robot-txt-alt-images https://github.com/sbatururimi/nutch.git nutch_source

# build the nutch trunk with a workaround for the javax.ws packaging.type problem
# check for more details 
# 1) https://issues.apache.org/jira/browse/NUTCH-2676?page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel&focusedCommentId=16691835
# 2) https://issues.apache.org/jira/browse/NUTCH-2669
RUN cd nutch_source && (ant runtime || ant clean runtime)

# Convenience symlink to Nutch runtime local
RUN ln -s nutch_source/runtime/local $HOME/nutch


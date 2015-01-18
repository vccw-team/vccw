#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright:: Copyright (c) 2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.expand_path('../support/helpers', __FILE__)

describe "apache2::god_monitor" do
  include Helpers::Apache

  it 'starts god service to supervise apache2' do
    service("god").must_be_running
  end

  it 'creates the god service template for apache' do
    file("/etc/god/conf.d/apache2.god").must_exist
  end

  it 'starts an apache2 service that works like a regular service' do
    # to be implemented when COOK-744 is fixed
  end
end

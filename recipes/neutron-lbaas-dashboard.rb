# encoding: UTF-8
#
# Cookbook:: openstack-dashboard
# Recipe:: neutron-lbaas-dashboard
#
# Copyright:: 2020, Oregon State University
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

include_recipe 'openstack-dashboard::horizon'

case node['platform_family']
when 'debian'
  package 'python3-neutron-lbaas-dashboard'
when 'rhel'
  django_path = node['openstack']['dashboard']['django_path']

  python_package 'neutron-lbaas-dashboard' do
    version node['openstack']['dashboard']['lbaas']['version']
    notifies :run, 'execute[openstack-dashboard collectstatic]'
  end

  remote_file "#{django_path}/openstack_dashboard/local/enabled/_1481_project_ng_loadbalancersv2_panel.py" do
    source 'https://opendev.org/openstack/neutron-lbaas-dashboard/raw/branch/stable/rocky/neutron_lbaas_dashboard/enabled/_1481_project_ng_loadbalancersv2_panel.py'
    owner 'root'
    mode '644'
    notifies :run, 'execute[openstack-dashboard collectstatic]'
  end
end

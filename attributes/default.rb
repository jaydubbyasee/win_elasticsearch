default['elasticsearch']['version'] = '1.5.2'
default['elasticsearch']['download_url'] = "https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-#{node['elasticsearch']['version']}.zip"
default['elasticsearch']['checksum'] = 'e900f7c60b1874a3530706337dfb0f29df467425'
default['elasticsearch']['configure'] = {}
default['elasticsearch']['cluster']['name'] = 'local'

if !node['opsworks'].nil?
    default['elasticsearch']['node']['name'] = node['opsworks']['layers'][node['elasticsearch']['cluster']['name']]['name']
else
    default['elasticsearch']['node']['name'] = node['hostname']
end
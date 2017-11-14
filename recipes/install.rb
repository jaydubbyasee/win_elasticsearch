# Download and extract elasticsearch archive
seven_zip_archive 'elasticsearch' do
  path 'C:/elasticsearch'
  source node['elasticsearch']['download_url']
  overwrite true
end

template "C:/elasticsearch/elasticsearch-#{node['elasticsearch']['version']}/config/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  variables(
    :config => node['elasticsearch']['configure'],
    :cluster_name => node['elasticsearch']['cluster']['name'],
    :node_name => node['elasticsearch']['node']['name']
  )
end

# Install elasticsearch-cloud-aws plugin
execute 'Installing elasticsearch-cloud-aws plugin' do
  command "C:/elasticsearch/elasticsearch-#{node['elasticsearch']['version']}/bin/plugin.bat install elasticsearch/elasticsearch-cloud-aws/#{node['elasticsearch']['plugin']['elasticsearch-cloud-aws']['version']}"
end

# Install marvel
execute 'Installing marvel plugin' do
  command "C:/elasticsearch/elasticsearch-#{node['elasticsearch']['version']}/bin/plugin.bat install elasticsearch/marvel/latest"
end

powershell_script 'delete_if_exist' do
  code <<-EOH
     $Service = Get-WmiObject -Class Win32_Service -Filter "Name='elasticsearch-service-x64'"
     if ($Service) {
        $Service.Delete() 
     }
  EOH
  notifies :run, 'execute[Installing Service elasticsearch-service-x64]', :immediately
end

execute 'Installing Service elasticsearch-service-x64' do
  command "C:/elasticsearch/elasticsearch-#{node['elasticsearch']['version']}/bin/service.bat install "
  action :nothing
  notifies :run, 'execute[Start Service elasticsearch-service-x64]', :immediately
end

execute 'Start Service elasticsearch-service-x64' do
  command "C:/elasticsearch/elasticsearch-#{node['elasticsearch']['version']}/bin/service.bat start "
  action :nothing
end

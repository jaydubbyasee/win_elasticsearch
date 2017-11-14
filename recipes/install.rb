# Download and extract elasticsearch archive
seven_zip_archive 'elasticsearch' do
  path 'C:/elasticsearch'
  source node['elasticsearch']['download_url']
  overwrite true
end

template "C:/elasticsearch/elasticsearch-1.5.2/config/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  variables(
    :config => node['elasticsearch']['configure']
  )
end

# Install elasticsearch-cloud-aws plugin
execute 'Installing elasticsearch-cloud-aws plugin' do
  command "C:/elasticsearch/elasticsearch-1.5.2/bin/plugin.bat install elasticsearch/elasticsearch-cloud-aws/#{node['elasticsearch']['plugin']['elasticsearch-cloud-aws']['version']}"
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
  command "C:/elasticsearch/elasticsearch-1.5.2/bin/service.bat install "
  action :nothing
end

execute 'Start Service elasticsearch-service-x64' do
  command "C:/elasticsearch/elasticsearch-1.5.2/bin/service.bat start "
  action :nothing
end

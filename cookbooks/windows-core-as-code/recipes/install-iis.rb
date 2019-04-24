windows_feature 'IIS-WebServerRole' do
  action :install
  install_method :windows_feature_dism
end

service 'w3svc' do
  action [:enable, :start]
end

node.override['install-iis-serverinfo']['infopage-path'] = 'c:/inetpub/wwwroot'

template "#{node['install-iis-serverinfo']['infopage-path']}/mypage.htm" do
  source 'mypage.htm.erb'
end

cookbook_file "#{node['install-iis-serverinfo']['infopage-path']}/mystyle.css" do
  source 'mystyle.css'
end

node.default['install-iis-serverinfo']['ps-version'] = ps_ver
node.default['install-iis-serverinfo']['ps-network'] = ps_net
node.default['install-iis-serverinfo']['ps-service'] = ps_service
node.default['install-iis-serverinfo']['last-update'] = ps_lastupdate
node.default['install-iis-serverinfo']['ntp-obj'] = JSON.parse(ps_ntp)
# This attribute from PS Script takes the domain attribute as input
node.default['install-iis-serverinfo']['ping-domain'] = ps_pingdomain node['domain'].to_s

# Get a list of Chocolatey packages
node.default['install-iis-serverinfo']['choco-list'] = ps_chocolist
node.default['install-iis-serverinfo']['choco-outdated'] = ps_chocooutdated

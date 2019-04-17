directory "c:/scriptees"

include_recipe 'chocolatey::default'

chocolatey_package 'git' do
  options '--params /GitAndUnixToolsOnPath'
  # action :uninstall
end

powershell_package 'PSWindowsUpdate' do
  version '2.1.1.2'
end

ps_demo_script = <<-EOH
  Set-ItemProperty -path 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon' -name Shell -value 'PowerShell.exe -NoExit'
EOH
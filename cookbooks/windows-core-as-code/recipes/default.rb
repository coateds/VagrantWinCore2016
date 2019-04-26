directory "c:/scripts"

include_recipe 'chocolatey::default'

chocolatey_package 'git' do
  options '--params /GitAndUnixToolsOnPath'
  # action :uninstall
end

powershell_package 'PSWindowsUpdate' do
  version '2.1.1.2'
end

ps_demo_script = <<-EOH
  # Set-ItemProperty -path 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon' -name Shell -value 'PowerShell.exe -NoExit'
  # Set-TimeZone -Name "Pacific Standard Time"
EOH

# ps = powershell_out(ps_demo_script)
# puts ps.stdout.chop.to_s

registry_key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon" do
  values [{
    name: "Shell",
    type: :string,
    data: "powershell.exe"
  }]
  action :create
end

timezone 'Pacific Standard Time'

windows_task 'windows-update' do
  command 'powershell get-date | out-file -append c:\scripts\WindowsUpdateLog.log; Install-WindowsUpdate -AcceptAll -AutoReboot | out-file -append c:\scripts\WindowsUpdateLog.log'
  run_level :highest
  frequency :daily
  start_time "02:00"
  force
end

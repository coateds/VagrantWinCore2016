module VagrantWinCore2016
  module HelperHelpers
    # A Function to return the PowerShell Version using PowerShell
    def ps_ver
      ps_psver_script = <<-EOH
      $PSVersionTable.PSVersion.Major.ToString()+'.'+$PSVersionTable.PSVersion.Minor.ToString()
      EOH
      powershell_out(ps_psver_script).stdout.chop.to_s
    end

    def ps_net
      ps_net_script = <<-EOH
        Get-WMIObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Select-Object Description, DHCPEnabled, DHCPServer | ConvertTo-Html
      EOH
      powershell_out(ps_net_script).stdout.chop.to_s
    end

    def ps_service
      ps_service_script = <<-EOH
      Get-Service | Where-Object {($_.status -ne 'running') -and ($_.StartType -eq 'Automatic')} | Select-Object Status, Name, DisplayName, StartType | ConvertTo-Html
      EOH
      powershell_out(ps_service_script).stdout.chop.to_s
    end

    def ps_lastupdate
      ps_lastupdate_script = <<-EOH
      (get-hotfix | sort installedon | select -last 1).InstalledOn
      EOH
      powershell_out(ps_lastupdate_script).stdout.chop.to_s
    end
    
    def ps_ntp
      ps_ntp_script = <<-EOH
      $NTPServer = '129.6.15.28'
      # Build NTP request packet. We'll reuse this variable for the response packet
      $NTPData    = New-Object byte[] 48  # Array of 48 bytes set to zero
      $NTPData[0] = 27                    # Request header: 00 = No Leap Warning; 011 = Version 3; 011 = Client Mode; 00011011 = 27

      # Open a connection to the NTP service
      $Socket = New-Object Net.Sockets.Socket ( 'InterNetwork', 'Dgram', 'Udp' )
      $Socket.SendTimeOut    = 2000  # ms
      $Socket.ReceiveTimeOut = 2000  # ms
      $Socket.Connect( $NTPServer, 123 )

      # Make the request
      $Null = $Socket.Send(    $NTPData )
      $Null = $Socket.Receive( $NTPData )

      # Clean up the connection
      $Socket.Shutdown( 'Both' )
      $Socket.Close()

      # Extract relevant portion of first date in result (Number of seconds since "Start of Epoch")
      $Seconds = [BitConverter]::ToUInt32( $NTPData[43..40], 0 )

      # Add them to the "Start of Epoch", convert to local time zone, and return
      $NTPTime = ([datetime]'1/1/1900' ).AddSeconds( $Seconds ).ToLocalTime()
      $SysTime = Get-Date
      $DiffTime = [math]::abs(($NTPTime - $SysTime).TotalSeconds)

      $obj = New-Object -TypeName PSObject
      Add-Member -InputObject $obj -MemberType NoteProperty -Name NTPTime -Value $NTPTime.ToString()
      Add-Member -InputObject $obj -MemberType NoteProperty -Name SYSTime -Value $SysTime.ToString()
      Add-Member -InputObject $obj -MemberType NoteProperty -Name DIFFTime -Value $DiffTime

      return $obj | ConvertTo-Json
      EOH
      powershell_out(ps_ntp_script).stdout.chop.to_s
    end

    def ps_pingdomain(domain)
      ps_ping_domain = <<-EOH
      Test-Connection "#{domain}" -count 1 | Select-Object PSComputerName,Address,IPV4Address | ConvertTo-Html
      EOH
      powershell_out(ps_ping_domain).stdout.chop.to_s
    end

    def ps_chocolist
      ps_choco_list_script = <<-EOH
      $pkgs = Invoke-Expression "choco list -l -r"
      foreach ($item in $pkgs) {$ret += $item + '<br>'}
      $ret
      # choco list -l
      EOH
      powershell_out(ps_choco_list_script).stdout.chop.to_s
    end

    def ps_chocooutdated
      ps_choco_outdated_script = <<-EOH
      $pkgs = Invoke-Expression "choco outdated -r"
      foreach ($item in $pkgs) {$ret += $item + '<br>'}
      $ret
      EOH
      powershell_out(ps_choco_outdated_script).stdout.chop.to_s
    end

    def ps_winupdatemod
      ps_winupdate_script = <<-EOH
      Get-Module -ListAvailable -Name PSWindowsUpdate | Select-Object ModuleType, Version, Name | ConvertTo-Html
      EOH
      powershell_out(ps_winupdate_script).stdout.chop.to_s
    end

    def ps_defaultshell
      ps_defaultshell_script = <<-EOH
      (Get-ItemProperty -path 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon' -name shell).shell
      EOH
      powershell_out(ps_defaultshell_script).stdout.chop.to_s
    end

    def ps_get_timezone
      powershell_out('(Get-TimeZone).Id').stdout.chop.to_s
    end

    def ps_update_task
      powershell_out('Get-ScheduledTask -taskname windows-update | Get-ScheduledTaskInfo | Select-Object TaskName, LastRunTime, NextRunTime | ConvertTo-Html').stdout.chop.to_s
    end
  end
end

Chef::Recipe.send(:include, VagrantWinCore2016::HelperHelpers)

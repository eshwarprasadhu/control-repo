class sqlserveralwayson::install inherits sqlserveralwayson {

	#reboot { 'before':
	#  when => pending,
	#}

	dsc_windowsfeature{'NET-Framework-Core':
	  dsc_ensure => 'Present',
	  dsc_name   => 'NET-Framework-Core',
	  dsc_includeallsubfeature => true
	}

	dsc_windowsfeature{'NET-Framework-45-Core':
	  dsc_ensure => 'Present',
	  dsc_name   => 'NET-Framework-45-Core',
	  dsc_includeallsubfeature => true
	}

	dsc_windowsfeature{'RSAT-AD-PowerShell':
    dsc_ensure => 'Present',
    dsc_name   => 'RSAT-AD-PowerShell'
  }

   dsc_windowsfeature{'Failover-Clustering':
    dsc_ensure => 'Present',
    dsc_name   => 'Failover-Clustering'
  }

  dsc_windowsfeature{'RSATClusteringPowerShell':
    dsc_ensure => 'Present',
    dsc_name   => 'RSAT-Clustering-PowerShell',
    require => [ Dsc_windowsfeature['Failover-Clustering'] ]
  }

  #Not working on Windows Server Core edition
  #dsc_windowsfeature{'RSATClusteringMgmt':
  #  dsc_ensure => 'Present',
  #  dsc_name   => 'RSAT-Clustering-Mgmt',
  #  require => [ Dsc_windowsfeature['Failover-Clustering'] ]
  #}

  dsc_windowsfeature{'RSATClusteringCmdInterface':
    dsc_ensure => 'Present',
    dsc_name   => 'RSAT-Clustering-CmdInterface',
    require => [ Dsc_windowsfeature['RSATClusteringPowerShell'] ]
  }

	dsc_sqlsetup{ 'InstallSQLDefaultInstance':
	    dsc_action => 'Install',
      dsc_instancename => 'MSSQLSERVER',
      dsc_features => 'SQLENGINE,AS',
      dsc_sqlcollation => 'SQL_Latin1_General_CP1_CI_AS',
      dsc_securitymode => 'SQL',
      dsc_sapwd => {'user' => 'sa', 'password' => $sa_password},
      dsc_productkey => $productkey,
      dsc_sqlsvcaccount => {'user' => "$domainnetbiosname\\$sqlservicecredential_username", 'password' => $sqlservicecredential_password},
      dsc_agtsvcaccount => {'user' => "$domainnetbiosname\\$sqlagentservicecredential_username", 'password' => $sqlagentservicecredential_password},
      dsc_assvcaccount => {'user' => "$domainnetbiosname\\$sqlservicecredential_username", 'password' => $sqlservicecredential_password},
      dsc_sqlsysadminaccounts => $sqladministratoraccounts,
      dsc_assysadminaccounts  => $sqladministratoraccounts,
      dsc_installshareddir => $installshareddir,
      dsc_installsharedwowdir => $installsharedwowdir,
      dsc_instancedir => $instancedir,
      dsc_installsqldatadir => $installsqldatadir,
      dsc_sqluserdbdir => $sqluserdbdir,
      dsc_sqluserdblogdir => $sqluserdblogdir,
      dsc_sqltempdbdir => $sqltempdbdir,
      dsc_sqltempdblogdir => $sqltempdblogdir,
      dsc_sqlbackupdir => $sqlbackupdir,
      dsc_asconfigdir => 'C:\\OLAP\\Config',
      dsc_asdatadir => 'C:\\OLAP\\Data',
      dsc_aslogdir => 'C:\\OLAP\\Log',
      dsc_asbackupdir => 'C:\\OLAP\\Backup',
      dsc_astempdir => 'C:\\OLAP\\Temp',
      dsc_sourcepath => $setupdir,
      dsc_updateenabled => 'False',
      dsc_forcereboot => true,
      dsc_psdscrunascredential => {'user' => $setup_svc_username, 'password' => $setup_svc_password},
      require => [ Dsc_windowsfeature['NET-Framework-Core'], Dsc_windowsfeature['NET-Framework-45-Core'],  Dsc_windowsfeature['Failover-Clustering'] ],
      notify => Reboot['after_run']
  }

	reboot { 'after_run':
	  apply => finished,
	}



}

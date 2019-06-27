class myserviceaccounts inherits sqlserveralwayson::serviceaccounts {

	#SQL service account creation (Active Directory)
	dsc_xaduser{'SvcSQLAccount':
		dsc_domainname => $domain,
		dsc_domainadministratorcredential => undef,
		dsc_username => $sqlservicecredential_username,
		dsc_password => {'user' => $sqlservicecredential_username, 'password' => $sqlservicecredential_password},
		dsc_ensure => 'Present',
		require => Dsc_windowsfeature['RSAT-AD-Powershell']
	}


	#SQL Agent service account creation (Active Directory)
	dsc_xaduser{'SvcSQLAgentAccount':
		dsc_domainname => $domain,
		dsc_domainadministratorcredential => undef,
		dsc_username => $sqlagentservicecredential_username,
		dsc_password => {'user' => $sqlagentservicecredential_username, 'password' => $sqlagentservicecredential_password},
		dsc_ensure => 'Present',
		require => Dsc_windowsfeature['RSAT-AD-Powershell']
	}

}

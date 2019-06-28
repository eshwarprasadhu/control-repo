class myclusterconfig inherits sqlserveralwayson::clusterconfig {
  
  if ( $role == 'primary' ) {
    #Failover cluster creation
    dsc_xcluster{'CreateFailoverCluster19':
      dsc_name => $clusterName,
      dsc_staticipaddress => $clusterIP,
      dsc_domainadministratorcredential => undef
    }

    #File share whitness configuration
    #Warning, bug https://github.com/PowerShell/xFailOverCluster/issues/35 on Windows 2016
    dsc_xclusterquorum{'SetQuorumToNodeAndDiskMajority19':
      dsc_issingleinstance => 'Yes',
      dsc_type => 'NodeAndFileShareMajority',
      dsc_resource => $fileShareWitness,
      require => Dsc_xcluster['CreateFailoverCluster']
    }

  }
  else {
    dsc_xwaitforcluster{'SecondaryReplicaWaitForCluster19':
      dsc_name => $clusterName,
      dsc_retryintervalsec => 10,
      dsc_retrycount => 6
    }

    dsc_xcluster{'JoinCluster19':
      dsc_name => $clusterName,
      dsc_staticipaddress => $clusterIP,
      dsc_domainadministratorcredential => undef,
      require => Dsc_xwaitforcluster['SecondaryReplicaWaitForCluster']
    }
  }
  
}

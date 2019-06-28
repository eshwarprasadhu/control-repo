class myclusterconfig inherits sqlserveralwayson::clusterconfig {
  
  if ( $role == 'primary' ) {
    #Failover cluster creation
    dsc_xcluster{'CustomCreateFailoverCluster':
      dsc_name => $clusterName,
      dsc_staticipaddress => $clusterIP,
      dsc_domainadministratorcredential => ''
    }

    #File share whitness configuration
    #Warning, bug https://github.com/PowerShell/xFailOverCluster/issues/35 on Windows 2016
    dsc_xclusterquorum{'CustomSetQuorumToNodeAndDiskMajority':
      dsc_issingleinstance => 'Yes',
      dsc_type => 'NodeAndFileShareMajority',
      dsc_resource => $fileShareWitness,
      require => Dsc_xcluster['CreateFailoverCluster']
    }

  }
  else {
    dsc_xwaitforcluster{'CustomSecondaryReplicaWaitForCluster':
      dsc_name => $clusterName,
      dsc_retryintervalsec => 10,
      dsc_retrycount => 6
    }

    dsc_xcluster{'CustomJoinCluster':
      dsc_name => $clusterName,
      dsc_staticipaddress => $clusterIP,
      dsc_domainadministratorcredential => '',
      require => Dsc_xwaitforcluster['SecondaryReplicaWaitForCluster']
    }
  }
  
}

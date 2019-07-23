    
class sqlserveralwayson::clusterconfig inherits sqlserveralwayson {

  if ( $role == 'primary' ) {
    #Failover cluster creation
    dsc_xcluster{'CreateFailoverCluster':
      dsc_name => $clusterName,
      dsc_staticipaddress => $clusterIP,
      dsc_domainadministratorcredential => {'user' => $setup_svc_username, 'password' => $setup_svc_password}
    }

    dsc_xclusterquorum{'SetQuorumToNodeAndCloudMajority':
      dsc_issingleinstance => 'Yes',
      dsc_type => 'NodeAndCloudMajority',
      dsc_resource => $fileShareWitness,
      dsc_storageaccountaccesskey => 'tVuGtuNmbwGeqYcS2r+9JyLjavECkGRPgEUPpN4sPrkQ5swbcrkjxBYzqIE1eh9EXCB63/HVxU3LuOxBxvIhPQ==',
      require => Dsc_xcluster['CreateFailoverCluster']
    }

  }
  else {
    dsc_xwaitforcluster{'SecondaryReplicaWaitForCluster':
      dsc_name => $clusterName,
      dsc_retryintervalsec => 10,
      dsc_retrycount => 6
    }

    dsc_xcluster{'JoinCluster':
      dsc_name => $clusterName,
      dsc_staticipaddress => $clusterIP,
      dsc_domainadministratorcredential => {'user' => $setup_svc_username, 'password' => $setup_svc_password},
      require => Dsc_xwaitforcluster['SecondaryReplicaWaitForCluster']
    }
  }
}

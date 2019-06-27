class psgallery_install {

pspackageprovider {'Nuget':
  ensure => 'present'
}

psrepository { 'PSGallery':
  ensure              => present,
  source_location     => 'https://www.powershellgallery.com/api/v2/',
  installation_policy => 'trusted',
}

package { 'xPSDesiredStateConfiguration':
  ensure   => latest,
  provider => 'windowspowershell',
  source   => 'PSGallery',
}

package { 'Pester':
  ensure   => latest,
  provider => 'powershellcore',
  source   => 'PSGallery',
}

package { 'PowerShellGet':
  ensure   => latest,
  provider => 'windowspowershell',
  source   => 'PSGallery',
}

}


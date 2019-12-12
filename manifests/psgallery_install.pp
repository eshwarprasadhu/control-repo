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

package { 'PackageManagement':
  ensure   => latest,
  provider => 'windowspowershell',
  source   => 'PSGallery',
}

package { 'Pester':
  ensure   => present,
  provider => 'windowspowershell',
  source   => 'PSGallery',
}

package { 'PowerShellGet':
  ensure   => latest,
  provider => 'windowspowershell',
  source   => 'PSGallery',
}

package { 'xActiveDirectory':
  ensure   => latest,
  provider => 'windowspowershell',
  source   => 'PSGallery',
}

package { 'Posh-SSH':
  ensure   => latest,
  provider => 'windowspowershell',
  source   => 'PSGallery',
}

}


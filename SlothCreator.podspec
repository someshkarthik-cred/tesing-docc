Pod::Spec.new do |s|
  s.name             = 'SlothCreator'
  s.version          = ENV['LIB_VERSION'] || '0.0.2'
  s.summary          = "jfnjwefw efj wekf wef we"
  s.homepage         = 'https://github.com/SomeshKarthikK/tesing-docc'
    s.license          = { :type => 'Apache-2.0', :file => 'LICENSE/LICENSE.txt' }
  s.authors          = { 'somesh' => 'somesh.karthik@cred.club' }
  s.source           = { :git => 'https://github.com/SomeshKarthikK/tesing-docc.git', :tag => s.version.to_s }
  s.ios.deployment_target = '14.0'
  s.swift_version    = '5.5'
  s.source_files     = 'Sources/SlothCreator/**/*.{swift, plist, podspec}'
  s.exclude_files = "Sources/SlothCreator/SlothCreator.docc"
  s.resources = "Sources/SlothCreator/**/*.{xcassets}"
  s.module_name    = 'SlothCreator'
end

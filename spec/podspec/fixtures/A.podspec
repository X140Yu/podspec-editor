Pod::Spec.new do |s|
  s.name         = 'TestPod'
  s.version      = '1.0.0'
  s.summary      = 'TestPod summary'
  s.license      = 'MIT'
  s.authors       = { 'test' => 'test@test.com' }
  s.homepage     = 'https://www.example.com'
  s.source       = { :git => 'https://test@test.git', :tag => '#{s.version}' }
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.requires_arc = true

  s.public_header_files = 'Classes/Public/**/*.h'
  s.source_files = 'Classes/Sources/**/*.{h,m,swift,mm}'

  s.subspec 'SubSpecA' do |ss|
    ss.private_header_files = 'Classes/A/Private/**/*.{swift,h,m,mm}'
    ss.source_files = [
      'Classes/A/API/**/*.{swift,h,m,c,mm}',
      'Classes/A/Private/DebugUI/*.{swift,h,m,c,mm}',
      'Classes/A/Private/Tab/**/*.{swift,h,m,c,mm}',
      'Resources/**/*.{h,m}',
    ]

    ss.resource = [
      'Resources/**/*.strings',
      'Resources/**/*.bundle'
    ]

    ss.dependency 'Masonry'
    ss.dependency 'ReactiveObjC'
    ss.dependency 'SDWebImage'

  end

  s.subspec 'SubSpecB' do |ss|
    ss.private_header_files = 'Classes/B/Private/**/*.{h,m,mm}'
    ss.source_files = [
      'Classes/B/**/*.{swift,h,m,c,mm}',
      'Resources/B/**/*.{h,m}',
    ]

    ss.resource = ['Resources/B/**/*.strings','Resources/B/**/*.bundle']

    ss.dependency 'TestPod/A'
    ss.dependency 'Masonry'
    ss.dependency 'ReactiveObjC'
  end

  s.subspec 'SubSpecC' do |ss|
    ss.private_header_files = 'Classes/C/Basic/C.h'
    ss.source_files = [
        'Classes/C/**/*.{swift,h,m,c,mm}',
        'Resources/C/**/*.{h,m}',
    ]

    ss.resource = ['Resources/C/**/*.strings','Resources/C/**/*.bundle']

    ss.dependency 'TestPod/A'
    ss.dependency 'Masonry'
    ss.dependency 'ReactiveObjC'
  end

end

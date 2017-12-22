Pod::Spec.new do |spec|
  spec.platform       = :ios, "7.0"
  spec.name           = 'ZLNetworkRequestsPerformer'
  spec.version        = '0.1'
  spec.homepage       = 'https://github.com/Ilushkanama/ZLNetworkRequestsPerformer'
  spec.authors        = { 'Ilya Dyakonov' => 'ilya@zappylab.com' }
  spec.summary        = 'simple AFNetworking wrapper for ZappyLab'
  spec.source         = { :git => 'https://github.com/zappylab/ZLNetworkRequestsPerformer.git', :branch => "dev" }
  spec.source_files   = 'NetworkRequestsPerformer/*.{h,m}'
  spec.requires_arc   = true
  spec.dependency       'AFNetworking'
end

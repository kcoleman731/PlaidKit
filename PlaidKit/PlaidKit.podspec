
Pod::Spec.new do |s|
  s.name                        = "PlaidKit"
  s.version                     = "0.1.0"
  s.summary                     = "An iOS client library for the Plaid REST API."
  s.license                     = 'Apache'
  s.author                      = { 'Kevin Coleman'   => 'kcoleman731@gmail.com' }
  s.source                      = { :git => "https://github.com/kcoleman731/PlaidKit.git", :tag => s.version.to_s }
  s.platform                    = :ios, '7.0'
  s.requires_arc                = true
  s.source_files                = 'Code/**/*.{h,m}'
  s.ios.resource_bundle         = {'PlaidKitResource' => 'Resources/*'}
  s.header_mappings_dir         = 'Code'
  s.ios.frameworks              = 'UIKit'
  s.ios.deployment_target       = '7.0'
  
end

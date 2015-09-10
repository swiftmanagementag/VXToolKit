@version = "1.0.1"

Pod::Spec.new do |s|
  s.name         	= 'VXToolKit'
  s.version      	= @version
  s.summary     	= 'Collection of utility functions.'
  s.homepage 	   	= 'https://github.com/swiftmanagementag/VXToolKit'
  s.license			= { :type => 'MIT', :file => 'LICENSE' }
  s.author       	= { 'Graham Lancashire' => 'lancashire@swift.ch' }
  s.source       	= { :git => 'https://github.com/swiftmanagementag/VXToolKit.git', :tag => s.version.to_s }
  s.platform     	= :ios, '7.0'
  s.source_files 	= 'pod/*.{h,m}'
  s.resources 		= 'pod/*.{bundle,xib,png,lproj,storyboard}'
  s.requires_arc 	= true

	subspec 'chart' do |sp|
		sp.source_files = 'pod/chart/*.{h,m}'
		sp.resources 	= 'pod/chart/*.{bundle,xib,png,lproj,storyboard}'
	end
end

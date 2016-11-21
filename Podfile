
target "MiaoMiaoHealth" do
    
    platform:ios, '8.0'
    
    pod 'Masonry', '~> 1.0.1'
    pod 'FDFullscreenPopGesture', '~> 1.1'
    pod 'YYModel', '~> 1.0.4'
    pod 'IQKeyboardManager', '~> 4.0.4'
    pod 'THLabel', '~> 1.4.7'
    pod 'UMengAnalytics-NO-IDFA', '~> 4.1.5'
    pod 'DVVAlertView', :git => 'https://github.com/devdawei/DVVAlertView.git', :tag => 'v1.0.2'
    pod 'DVVActionSheetView', :git => 'https://github.com/devdawei/DVVActionSheetView.git', :tag => 'v1.0.1'
    pod 'DVVLoading', :git => 'https://github.com/devdawei/DVVLoading.git', :tag => 'v1.0.1'
    pod 'DVVToast', :git => 'https://github.com/devdawei/DVVToast.git', :tag => 'v1.0.1'
    pod 'DVVCoding', :git => 'https://github.com/devdawei/DVVCoding.git', :tag => 'v1.0.1'
    pod 'DVVArchiver', :git => 'https://github.com/devdawei/DVVArchiver.git', :tag => 'v1.0.0'
    pod 'DVVImagePickerControllerManager', :git => 'https://github.com/devdawei/DVVImagePickerControllerManager.git', :tag => 'v1.0.0'
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
        end
    end
    
end

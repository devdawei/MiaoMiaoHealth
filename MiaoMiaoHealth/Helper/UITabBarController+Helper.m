//
//  UITabBarController+Helper.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "UITabBarController+Helper.h"
#import <objc/runtime.h>

@implementation UITabBarController (Helper)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 交换shouldAutorotate的实现
        Method originShouldAutorotateImp = class_getInstanceMethod(self, @selector(shouldAutorotate));
        Method swizzShouldAutorotateImp  = class_getInstanceMethod(self, @selector(mmh_shouldAutorotate));
        method_exchangeImplementations(originShouldAutorotateImp, swizzShouldAutorotateImp);

        // 交换supportedInterfaceOrientations的实现
        Method originSupportedInterfaceOrientationsImp = class_getInstanceMethod(self, @selector(supportedInterfaceOrientations));
        Method swizzSupportedInterfaceOrientationsImp  = class_getInstanceMethod(self, @selector(mmh_supportedInterfaceOrientations));
        method_exchangeImplementations(originSupportedInterfaceOrientationsImp, swizzSupportedInterfaceOrientationsImp);
    });
}

#pragma mark - Autorotate

- (BOOL)mmh_shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)mmh_supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end

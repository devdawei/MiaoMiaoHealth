//
//  UINavigationController+Helper.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "UINavigationController+Helper.h"
#import <objc/runtime.h>

@implementation UINavigationController (Helper)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 交换preferredStatusBarStyle的实现
        Method originPreferredStatusBarStyleImp = class_getInstanceMethod(self, @selector(preferredStatusBarStyle));
        Method swizzPreferredStatusBarStyleImp  = class_getInstanceMethod(self, @selector(ddb_preferredStatusBarStyle));
        method_exchangeImplementations(originPreferredStatusBarStyleImp, swizzPreferredStatusBarStyleImp);
        
        // 交换viewWillAppear的实现
        Method originViewWillAppearImp = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method swizzViewWillAppearImp  = class_getInstanceMethod(self, @selector(mmh_viewWillAppear:));
        method_exchangeImplementations(originViewWillAppearImp, swizzViewWillAppearImp);
    });
}

- (void)mmh_viewWillAppear:(BOOL)animated
{
    // 隐藏NaviBar底部分割线
    [UIView mmh_findHairlineImageView:self.navigationBar].hidden = YES;
    
    [self mmh_viewWillAppear:animated]; // 调用原Imp
}

#pragma mark StatusBarStyle
-(UIStatusBarStyle)ddb_preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

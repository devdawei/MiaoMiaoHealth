//
//  AppDelegate+DidFinishLaunchHandle.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/29.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "AppDelegate+DidFinishLaunchHandle.h"
#import <UMMobClick/MobClick.h>

@implementation AppDelegate (DidFinishLaunchHandle)

#pragma mark 注册启动完成后的事件处理
+ (void)registerDidFinishLaunchHandle
{
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        DLog(@"handle didFinshLaunch!");
        
        /* 配置友盟统计 */
        UMConfigInstance.appKey = kUMengAppKey;
        UMConfigInstance.channelId = @"App Store";
        UMConfigInstance.eSType = E_UM_NORMAL;
        UMConfigInstance.ePolicy = BATCH;
        [MobClick setAppVersion:APPVersion];
        [MobClick startWithConfigure:UMConfigInstance];
        
        [MobClick event:@"LaunchAPP"]; // 统计启动了APP
        
        observer = nil;
    }];
}

@end

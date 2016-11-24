//
//  AppDelegate+ShortcutItem.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/11/22.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (ShortcutItem)

- (void)mmh_handleShortcutItemWithApplication:(UIApplication *)application
                 performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
                            completionHandler:(void (^)(BOOL))completionHandler;

@end


//
//  AppDelegate+ShortcutItem.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/11/22.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "AppDelegate+ShortcutItem.h"
#import "MMHTabBarController.h"
#import "MMHUserCenterController.h"

/** 关于我们 */
static NSString * const kShortcutItemAboutUS = @"kShortcutItemAboutUS";
/** 步数目标 */
static NSString * const kShortcutItemStepGoal = @"kShortcutItemStepGoal";

@implementation AppDelegate (ShortcutItem)

- (void)mmh_handleShortcutItemWithApplication:(UIApplication *)application
                 performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
                            completionHandler:(void (^)(BOOL))completionHandler
{
    [self ddb_handleShortcutItemWithApplication:application shortcutItem:shortcutItem];
    completionHandler(YES);
}

- (void)ddb_handleShortcutItemWithApplication:(UIApplication *)application
                                 shortcutItem:(UIApplicationShortcutItem *)shortcutItem
{
    NSString *itemType = shortcutItem.type;
    
    MMHTabBarController *tabBarVC = [MMHTabBarController sharedTabBarController];
    [tabBarVC naviControllerPopToRootController];
    if ([kShortcutItemAboutUS isEqualToString:itemType])
    {
        [tabBarVC setSelectedViewController:tabBarVC.userCenterNaviVC];
        [tabBarVC.userCenterVC pushToAboutUSController];
    }
    else if ([kShortcutItemStepGoal isEqualToString:itemType])
    {
        [tabBarVC setSelectedViewController:tabBarVC.userCenterNaviVC];
        [tabBarVC.userCenterVC pushToStepGoalController];
    }
}

@end

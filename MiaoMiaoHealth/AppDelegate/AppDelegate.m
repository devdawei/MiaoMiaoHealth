//
//  AppDelegate.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+DidFinishLaunchHandle.h"
#import "MMHTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [MMHAppConst naviBgColor];
    
    // 注册完成加载后的事务处理
    [AppDelegate registerDidFinishLaunchHandle];
    
    /* 注册是否强制使用苹果键盘的通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(forcedUseAppleKeyboardValueChangeNotify:)
                                                 name:kForcedUseAppleKeyboardNotify
                                               object:nil];
    
    // ios8 registerUserNotificationSettings
    UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:userNotificationSettings];
    
    MMHTabBarController *tabBarVC = [MMHTabBarController sharedTabBarController];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    
    DLog(@"willDidFinishLaunch!");
    return YES;
}

#pragma mark 接收到强制使用苹果键盘值改变的通知
- (void)forcedUseAppleKeyboardValueChangeNotify:(NSNotification *)notification
{
    _forcedUseAppleKeyboard = [notification.object boolValue];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark iOS8之后还需要通过这个方法注册推送
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSetting
{
    [application registerForRemoteNotifications];
}

#pragma mark 接收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if ([notification.category isEqualToString:kDrinkWaterLocalNotificationCategory])
    {
        [DVVToast showMessage:kDrinkWaterAlertBody];
    }
}

#pragma mark 接收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

#pragma mark 接收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}

#pragma mark 是否允许使用第三方键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    DLog(@"extensionPointIdentifier: %@ %zi", extensionPointIdentifier, _forcedUseAppleKeyboard);
    if (_forcedUseAppleKeyboard)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end

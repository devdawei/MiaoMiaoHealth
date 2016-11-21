//
//  MMHDrinkWaterController.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMHDrinkWaterController : UIViewController

/** 用来判断是否所有的喝水提醒都打开了 */
@property (nonatomic, readonly, assign) BOOL isAllLocalNotificationsOn;

/**
 *  取消所有的喝水提醒
 */
- (void)cancelAllLocalNotifications;

/**
 *  打开所有的喝水提醒
 */
- (void)openAllLocalNotifications;

@end

//
//  MMHDrinkWaterNotifyManager.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/29.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMHDrinkWaterDMData;

@interface MMHDrinkWaterNotifyManager : NSObject

/**
 *  添加一个本地通知
 *
 *  @param dmData MMHDrinkWaterDMData
 */
+ (void)addLocalNotification:(MMHDrinkWaterDMData *)dmData;

/**
 *  取消一个本地通知
 *
 *  @param dmData MMHDrinkWaterDMData
 */
+ (void)cancelLocalNotification:(MMHDrinkWaterDMData *)dmData;

/**
 *  取消所有的本地通知
 */
+ (void)cancelAllLocalNotifications;

@end

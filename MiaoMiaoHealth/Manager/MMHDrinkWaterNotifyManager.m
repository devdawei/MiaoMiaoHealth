//
//  MMHDrinkWaterNotifyManager.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/29.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHDrinkWaterNotifyManager.h"
#import "MMHDrinkWaterDMData.h"

@implementation MMHDrinkWaterNotifyManager

#pragma mark 添加一个本地通知
+ (void)addLocalNotification:(MMHDrinkWaterDMData *)dmData
{
    if (NO == dmData.isTurnOn) return;
    // 如果有相同的通知，则直接 return
    if ([self hasSameLocalNotification:dmData]) return;
    
    UILocalNotification *localNotification = [UILocalNotification new];
    if (localNotification == nil) return;
    
    // 通知的类型
    localNotification.category = kDrinkWaterLocalNotificationCategory;
    
    // 设置本地通知的时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone defaultTimeZone];
    // HH是24进制，hh是12进制
    formatter.dateFormat = @"HH:mm:ss";
    NSDate *date = [formatter dateFromString:[dmData.time stringByAppendingString:@":00"]];
    DLog(@"date: %@", date);
    // 设置本地通知的触发时间
    localNotification.fireDate = date;
    
    // 设置通知的内容
    localNotification.alertBody = kDrinkWaterAlertBody;
    
    // 设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    // 设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
    localNotification.userInfo = [dmData yy_modelToJSONObject];
    
    // 重复触发的类型
    localNotification.repeatInterval = kCFCalendarUnitDay;
    
    // 在规定的时间触发通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark 取消一个本地通知
+ (void)cancelLocalNotification:(MMHDrinkWaterDMData *)dmData
{
    UILocalNotification *localNotification = [self hasSameLocalNotification:dmData];
    if (localNotification)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    }
}

#pragma mark 取消所有的本地通知
+ (void)cancelAllLocalNotifications
{
    NSArray<UILocalNotification *> *notifyArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    DLog(@"通知的个数: %zd", notifyArray.count);
    
    [notifyArray enumerateObjectsUsingBlock:^(UILocalNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.category &&
            [obj.category isEqualToString:kDrinkWaterLocalNotificationCategory])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:obj];
            DLog(@"%zd", idx);
        }
    }];
}

#pragma mark 检查本地是否有相同的通知
+ (UILocalNotification *)hasSameLocalNotification:(MMHDrinkWaterDMData *)dmData
{
    NSArray<UILocalNotification *> *notifyArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification * obj in notifyArray)
    {
        if (obj.category &&
            [obj.category isEqualToString:kDrinkWaterLocalNotificationCategory])
        {
            MMHDrinkWaterDMData *tmp_dmData = [MMHDrinkWaterDMData yy_modelWithDictionary:obj.userInfo];
            if ([dmData.time isEqualToString:tmp_dmData.time])
            {
                return obj;
            }
        }
    }
    
    return nil;
}

@end

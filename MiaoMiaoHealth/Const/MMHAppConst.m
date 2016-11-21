//
//  MMHAppConst.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHAppConst.h"

/** 布局控件时的左边距 Key */
CGFloat const kLayoutLeftMargin = 12.0f;

/** 喝水提醒本地通知的category Key */
NSString * const kDrinkWaterLocalNotificationCategory = @"kDrinkWaterLocalNotificationCategory";
/** 喝水提醒通知的 alertBody Key */
NSString * const kDrinkWaterAlertBody = @"小喵提醒：主人记得喝水哟！";

/** 大按钮圆角度数 */
CGFloat const kLargeButtonCornerRadius = 8.0f;

@implementation MMHAppConst

#pragma mark 导航栏背景色
+ (UIColor *)naviBgColor
{
    return RGBColor(0, 0, 0);
}

#pragma mark 导航栏前景色
+ (UIColor *)naviFgColor
{
    return RGBColor(255, 255, 255);
}

#pragma mark 导航栏标题字体
+ (UIFont *)naviTitleFont
{
    return [UIFont systemFontOfSize:16];
}

#pragma mark 导航栏Item字
+ (UIFont *)naviItemFont
{
    return [UIFont systemFontOfSize:16];
}

#pragma mark Controller背景色
+ (UIColor *)controllerBgColor
{
    return RGBColor(240, 240, 240);
}

@end

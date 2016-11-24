//
//  MMHAppConst.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QA_TEST // 测试是打开此行注释

/** APP ID */
#define MMH_APP_ID @"1150244313"

/** 正式版本号 */
#define APPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/** Build版本号 */
#define APPBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

/** 屏幕宽 */
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
/** 屏幕高 */
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

// iOS版本
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IOS7                             (IOSVersion == 7.0)
#define IS_IOS7_LATER                       (IOSVersion >= 7.0)
#define IS_IOS8                             (IOSVersion == 8.0)
#define IS_IOS8_LATER                       (IOSVersion >= 8.0)
#define IS_IOS9                             (IOSVersion == 9.0)
#define IS_IOS9_LATER                       (IOSVersion >= 9.0)

// 颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]

// NSLog
#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

// 弱引用
#define WS __weak typeof(self) weakSelf = self
#define WeakObj(obj, name) __weak typeof(obj) name = obj
// 强引用
#define SWS __strong typeof(weakSelf) strongSelf = weakSelf
#define StrongObj(obj, name) __strong typeof(obj) name = obj

/** 格式化字符串 */
#define FormatString( format, ... ) [NSString stringWithFormat:(format), ##__VA_ARGS__]

/** 布局控件时的左边距 Key */
extern CGFloat const kLayoutLeftMargin;

/** 喝水提醒本地通知的category Key */
extern NSString * const kDrinkWaterLocalNotificationCategory;
/** 喝水提醒通知的 alertBody Key */
extern NSString * const kDrinkWaterAlertBody;

/** 大按钮的圆角度数 */
extern CGFloat const kLargeButtonCornerRadius;

@interface MMHAppConst : NSObject

/**
 *  导航栏背景色
 *
 *  @return UIColor
 */
+ (UIColor *)naviBgColor;

/**
 *  导航栏前景色
 *
 *  @return UIColor
 */
+ (UIColor *)naviFgColor;

/**
 *  导航栏标题字体
 *
 *  @return UIFont
 */
+ (UIFont *)naviTitleFont;

/**
 *  导航栏Item字体
 *
 *  @return UIFont
 */
+ (UIFont *)naviItemFont;

/**
 *  Controller背景色
 *
 *  @return UIColor
 */
+ (UIColor *)controllerBgColor;

@end

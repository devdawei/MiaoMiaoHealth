//
//  MMHNotifyConst.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/31.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 步数目标改变的通知 Key */
extern NSString * const kStepGoalChangeNotify;

/** 喝水提醒状态全部开启或关闭的通知 Key */
extern NSString * const kDrinkWaterAllOnStatusChangeNotify;

/** 强制使用苹果键盘的通知 Key */
extern NSString * const kForcedUseAppleKeyboardNotify;
/** 强制使用苹果键盘 */
extern NSString * const kForcedUseAppleKeyboard;
/** 不强制使用苹果键盘 */
extern NSString * const kNotForceUseAppleKeyboard;

@interface MMHNotifyConst : NSObject

@end

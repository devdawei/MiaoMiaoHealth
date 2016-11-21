//
//  MMHHealthManager.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/30.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMHHealthManager : NSObject

/**
 *  单利
 *
 *  @return instancetype
 */
+ (instancetype)sharedManager;

/**
 *  向 HealthKit 获取权限
 *
 *  @param compltion 处理结果
 */
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;

/**
 *  读取今日步数
 *
 *  @param completion 处理结果
 */
- (void)readStepCount:(void(^)(double value, NSError *error))completion;

/**
 *  读取今日步行+跑步距离
 *
 *  @param completion 处理结果
 */
- (void)readDistance:(void(^)(double value, NSError *error))completion;

@end

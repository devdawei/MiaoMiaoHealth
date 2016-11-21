//
//  MMHDrinkWaterDMData.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMHDrinkWaterDMData : NSObject

/** 提醒时间，格式为：14：20 */
@property (nonatomic, copy) NSString *time;
/** 是否开启提醒 */
@property (nonatomic, assign) BOOL isTurnOn;

@end

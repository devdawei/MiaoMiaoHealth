//
//  MMHUserManager.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/29.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMHUserManager : NSObject

/** 步数目标 */
@property (nonatomic, assign) NSUInteger stepGoal;

/** 用户中心 header 中的背景图片 */
@property (nonatomic, copy) UIImage *userCenterheaderBgImage;
/** 用户中心 header 中的头像 */
@property (nonatomic, copy) UIImage *userCenterheaderPortraitImage;

/**
 *  单例
 *
 *  @return instancetype
 */
+ (instancetype)sharedManager;

/**
 *  将这个类中的数据缓存到本地
 */
- (BOOL)storage;

@end

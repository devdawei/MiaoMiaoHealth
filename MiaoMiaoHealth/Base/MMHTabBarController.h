//
//  MMHTabBarController.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMHSportController;
@class MMHDrinkWaterController;
@class MMHUserCenterController;

@interface MMHTabBarController : UITabBarController

@property (nonatomic, strong) UINavigationController *sportNaviVC;
@property (nonatomic, strong) MMHSportController *sportVC;

@property (nonatomic, strong) UINavigationController *drinkWaterNaviVC;
@property (nonatomic, strong) MMHDrinkWaterController *drinkWaterVC;

@property (nonatomic, strong) UINavigationController *userCenterNaviVC;
@property (nonatomic, strong) MMHUserCenterController *userCenterVC;

@property (nonatomic, assign) BOOL canRotate;

+ (instancetype)sharedTabBarController;

- (void)naviControllerPopToRootController;

@end

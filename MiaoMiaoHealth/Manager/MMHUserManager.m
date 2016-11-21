//
//  MMHUserManager.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/29.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHUserManager.h"
#import <DVVArchiver.h>

static NSString * const kStorageFileName = @"mmh_userManager";

@implementation MMHUserManager

DVVCodingImplementation

#pragma mark 单例
+ (instancetype)sharedManager
{
    static MMHUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DVVArchiver unarchiveWithType:DVVArchiverTypePreferences name:kStorageFileName];
        if (!manager) manager = [self new];
    });
    return manager;
}

#pragma mark 将这个类中的数据缓存到本地
- (BOOL)storage
{
    return [DVVArchiver archiverWithType:DVVArchiverTypePreferences object:self name:kStorageFileName];
}

@end

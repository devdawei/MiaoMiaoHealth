//
//  DVVAppStoreTool.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/31.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVVAppStoreTool : NSObject

/**
 *  去AppStore下载
 *
 *  @param appID 应用的appID
 */
+ (void)goAppStoreDownload:(NSString *)appID;

/**
 *  去AppStore评分
 *
 *  @param appID 应用的appID
 */
+ (void)goAppStoreScore:(NSString *)appID;

@end

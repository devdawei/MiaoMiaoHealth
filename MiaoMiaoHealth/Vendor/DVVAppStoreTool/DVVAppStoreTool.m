//
//  DVVAppStoreTool.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/31.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "DVVAppStoreTool.h"

@implementation DVVAppStoreTool

#pragma mark 去AppStore下载
+ (void)goAppStoreDownload:(NSString *)appID
{
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?mt=8", appID];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [DVVToast showMessage:@"跳转失败"];
    }
}

#pragma mark 去AppStore评分
+ (void)goAppStoreScore:(NSString *)appID
{
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",appID];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [DVVToast showMessage:@"跳转失败"];
    }
}

@end

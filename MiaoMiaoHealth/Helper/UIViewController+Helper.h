//
//  UIViewController+Helper.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helper)

@property (nonatomic, strong) UIButton *naviLeftButton;
@property (nonatomic, copy) NSString *naviLeftTitle;

@property (nonatomic, strong) UIButton *naviRightButton;
@property (nonatomic, copy) NSString *naviRightTitle;

@property (nonatomic, strong) UIButton *naviTitleButton;
@property (nonatomic, copy) NSString *naviTitle;

- (void)mmh_addBackBarButtonItem;

@end

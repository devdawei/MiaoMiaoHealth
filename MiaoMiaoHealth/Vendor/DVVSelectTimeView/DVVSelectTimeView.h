//
//  DVVSelectTimeView.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/9/1.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DDBAddressViewSelectedBlock)(NSString *hour, NSString *minute);

@interface DVVSelectTimeView : UIView

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) NSUInteger firstIdx;
@property (nonatomic, assign) NSUInteger secondIdx;

@property (nonatomic, copy) DDBAddressViewSelectedBlock didSelectedBlock;
- (void)setDidSelectedBlock:(DDBAddressViewSelectedBlock)didSelectedBlock;

/**
 *  显示出来的方法
 *
 *  @param superView 在这个视图上显示
 */
- (void)showFromView:(UIView *)superView;

/**
 *  预先选择一个值
 *
 *  @param hour   小时 格式如：03
 *  @param minute 分钟 格式如：59
 */
- (void)defaultSelectedWithhour:(NSString *)hour
                         minute:(NSString *)minute;

@end

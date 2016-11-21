//
//  MMHTableCell.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMHTableCell : UITableViewCell

/** 设置 icon 图片 */
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) UIImageView *iconImageView;
/** 设置 Title 文字 */
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) UILabel *titleLabel;
/** 设置 detail 文字 */
@property (nonatomic, strong) NSString *markString;
@property (nonatomic, strong) UILabel *markLabel;
/** 设置右箭头显示或隐藏 */
@property (nonatomic, assign) BOOL arrowImageViewHidden;
@property (nonatomic, strong) UIImageView *arrowImageView;
/** cell 底部的细线 */
@property (nonatomic, strong) UIImageView *bottomLineImageView;
/** 这个当做每一组底部的细线 */
@property (nonatomic, strong) UIImageView *sectionBottomLineImageView;

/** 显示或隐藏右侧的 UISwitch 控件 */
@property (nonatomic, assign) BOOL switchControlHidden;
/** 在右侧显示的 UISwitch 控件 */
@property (nonatomic, strong) UISwitch *switchControl;

@end

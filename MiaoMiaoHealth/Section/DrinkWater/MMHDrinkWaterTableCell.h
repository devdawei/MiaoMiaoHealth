//
//  MMHDrinkWaterTableCell.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMHTableCell.h"
@class MMHDrinkWaterTableCell;
@class MMHDrinkWaterDMData;

typedef void(^MMHDrinkWaterTableCellSwitchValueChangeBlock)(MMHDrinkWaterTableCell *cell, BOOL isTurnOn);

@interface MMHDrinkWaterTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *controlSwitch;
@property (nonatomic, strong) UIImageView *bottomLineImageView;

@property (nonatomic, strong) MMHDrinkWaterDMData *dmData;

@property (nonatomic, copy) MMHDrinkWaterTableCellSwitchValueChangeBlock switchValueChangeBlock;
- (void)setSwitchValueChangeBlock:(MMHDrinkWaterTableCellSwitchValueChangeBlock)switchValueChangeBlock;

@end

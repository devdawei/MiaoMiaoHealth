//
//  MMHDrinkWaterTableCell.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHDrinkWaterTableCell.h"
#import "MMHDrinkWaterDMData.h"

@implementation MMHDrinkWaterTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_controlSwitch addTarget:self action:@selector(switchValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:self.bottomLineImageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self configUI];
}

- (void)configUI
{
    CGSize size = self.bounds.size;
    _bottomLineImageView.frame = CGRectMake(kLayoutLeftMargin, size.height - 0.5, size.width - kLayoutLeftMargin, 0.5);
}

- (void)setDmData:(MMHDrinkWaterDMData *)dmData
{
    _dmData = dmData;
    
    _titleLabel.text = dmData.time;
    _controlSwitch.on = dmData.isTurnOn;
}

- (void)switchValueChangeAction:(UISwitch *)sender
{
    if (_switchValueChangeBlock) _switchValueChangeBlock(self, sender.on);
}

- (UIImageView *)bottomLineImageView
{
    if (!_bottomLineImageView)
    {
        _bottomLineImageView = [UIImageView new];
        _bottomLineImageView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _bottomLineImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

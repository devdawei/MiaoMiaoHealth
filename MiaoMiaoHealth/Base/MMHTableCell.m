//
//  MMHTableCell.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHTableCell.h"

static CGFloat const kTitleLabelFontSize = 15.0;
static CGFloat const kMarkLabelFontSize = 14.0;

@implementation MMHTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    _switchControlHidden = YES; // 默认隐藏 UISwitch 控件 （不通过 setter 方法设置，如果用不到这个控件的情况下，可以节省内存）
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.markLabel];
    [self.contentView addSubview:self.bottomLineImageView];
    
    [self.contentView addSubview:self.sectionBottomLineImageView];
    _sectionBottomLineImageView.hidden = YES;
    
    [self.contentView addSubview:self.arrowImageView];
    
    [self configUI];
}

#pragma mark - UI

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self configUI];
}

- (void)configUI
{
    CGSize size = self.bounds.size;
    CGFloat leftMargin = 12;
    
    // 图标
    CGFloat iconWidth = 0;
    if (_iconImage)
    {
        iconWidth = 20;
    }
    _iconImageView.frame = CGRectMake(leftMargin, (size.height - 20) / 2.0, iconWidth, 20);
    
    // title
    CGFloat titleLefeMargin = 0;
    CGFloat titleWidth = 0;
    if (_iconImage)
    {
        titleLefeMargin = 8;
    }
    if (_titleString)
    {
        titleWidth = 8;
        titleWidth = [NSString dynamicWidthWithString:_titleString font:[UIFont systemFontOfSize:kTitleLabelFontSize]];
    }
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + titleLefeMargin, 0, titleWidth, size.height);
    
    // 箭头
    CGFloat arrowLeftMargin = 8;
    CGFloat arrowRightMargin = 12;
    CGFloat arrowWidth = 7;
    _arrowImageView.frame = CGRectMake(size.width - arrowWidth - arrowRightMargin, 0, arrowWidth, size.height);
    
    // 详细说明
    CGFloat titleLabelMaxX = CGRectGetMaxX(_titleLabel.frame);
    CGFloat markLeftMargin = 0;
    CGFloat markWidth = 0;
    
    if (_titleString) markLeftMargin = 8;
    
    if (_arrowImageViewHidden) markWidth = size.width - titleLabelMaxX - markLeftMargin - leftMargin;
    else markWidth = size.width - titleLabelMaxX - markLeftMargin - arrowLeftMargin - arrowWidth - arrowRightMargin;
    
    _markLabel.frame = CGRectMake(titleLabelMaxX + markLeftMargin, 0, markWidth, size.height);
    
    _bottomLineImageView.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), size.height - 0.5, size.width - CGRectGetMinX(_titleLabel.frame), 0.5);
    _sectionBottomLineImageView.frame = CGRectMake(0, size.height - 0.5, size.width, 0.5);
    
    // 在右侧显示的 UISwitch 控件
    CGFloat switchWidth = 51;
    CGFloat switchHeight = 31;
    if (_switchControl) _switchControl.frame = CGRectMake(CGRectGetWidth(_markLabel.frame) - switchWidth,
                                                          (CGRectGetHeight(_markLabel.frame) - switchHeight) / 2.0,
                                                          switchWidth,
                                                          switchHeight);
}

#pragma mark - Setter getter

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    self.iconImageView.image = iconImage;
    
    [self configUI];
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    self.titleLabel.text = titleString;
    
    [self configUI];
}

- (void)setMarkString:(NSString *)markString
{
    _markString = markString;
    self.markLabel.text = markString;
    
    [self configUI];
}

- (void)setArrowImageViewHidden:(BOOL)arrowImageViewHidden
{
    _arrowImageViewHidden = arrowImageViewHidden;
    self.arrowImageView.hidden = arrowImageViewHidden;
    [self configUI];
}

- (void)setSwitchControlHidden:(BOOL)switchControlHidden
{
    [self.markLabel addSubview:self.switchControl];
    self.markLabel.userInteractionEnabled = YES;
    
    _switchControlHidden = switchControlHidden;
    self.switchControl.hidden = switchControlHidden;
    [self configUI];
}

#pragma mark - Lazy load

- (UIImageView *)iconImageView
{
    if (!_iconImageView)
    {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
        _titleLabel.textColor = RGBColor(51, 51, 51);
    }
    return _titleLabel;
}

- (UILabel *)markLabel
{
    if (!_markLabel)
    {
        _markLabel = [UILabel new];
        _markLabel.tintColor = [UIColor redColor];
        _markLabel.textColor = RGBColor(153, 153, 153);
        _markLabel.font = [UIFont systemFontOfSize:kMarkLabelFontSize];
        _markLabel.textAlignment = NSTextAlignmentRight;
    }
    return _markLabel;
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

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView)
    {
        _arrowImageView = [UIImageView new];
        _arrowImageView.contentMode = UIViewContentModeCenter;
        _arrowImageView.image = [UIImage imageNamed:@"ic_cell_more_arrow"];
    }
    return _arrowImageView;
}

- (UIImageView *)sectionBottomLineImageView
{
    if (!_sectionBottomLineImageView)
    {
        _sectionBottomLineImageView = [UIImageView new];
        _sectionBottomLineImageView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _sectionBottomLineImageView;
}

- (UISwitch *)switchControl
{
    if (!_switchControl)
    {
        _switchControl = [UISwitch new];
    }
    return _switchControl;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

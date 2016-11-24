//
//  DVVSelectTimeView.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/9/1.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "DVVSelectTimeView.h"

CGFloat const DVVSelectTimeViewViewHeaderViewHeight = 40.0;
CGFloat const DVVSelectTimeViewPickerViewHeight = 160.0;
CGFloat const DVVSelectTimeViewShowAnimateDuration = 0.7;
CGFloat const DVVSelectTimeViewRemoveAnimateDuration = 0.3;
CGFloat const DVVSelectTimeViewButtonHeight = 40.0;
CGFloat const DVVSelectTimeViewPickerViewWidth = 240.0;

@interface DVVSelectTimeView () <UIPickerViewDelegate, UIPickerViewDataSource>

/** 时 */
@property (nonatomic, strong) NSMutableArray<NSString *> *hourArray;
/** 分 */
@property (nonatomic, strong) NSMutableArray<NSString *> *minuteArray;

@property (nonatomic, strong) UIPickerView *pickerView;

//@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, assign) BOOL didShow;

@property (nonatomic, strong) UIVisualEffectView *backgroundEffectView;

@end

@implementation DVVSelectTimeView

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadData];
        
        [self addSubview:self.backgroundEffectView];
        [self addSubview:self.containerView];
        
        [self.headerView addSubview:self.cancelButton];
        [self.headerView addSubview:self.doneButton];
        [self.headerView addSubview:self.titleLabel];
        
        [_containerView addSubview:self.pickerView];
        [_containerView addSubview:self.headerView];
        
        _pickerView.frame = CGRectMake(0, DVVSelectTimeViewViewHeaderViewHeight, DVVSelectTimeViewPickerViewWidth, DVVSelectTimeViewPickerViewHeight);
    }
    return self;
}

#pragma mark - Config UI

- (void)configUI
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [_backgroundEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    CGFloat width = DVVSelectTimeViewPickerViewWidth;
    CGFloat height = DVVSelectTimeViewViewHeaderViewHeight + DVVSelectTimeViewPickerViewHeight;
    WS;
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        SWS;
        make.size.mas_equalTo(CGSizeMake(width, height));
        make.centerX.mas_equalTo(strongSelf.mas_centerX);
        make.centerY.mas_equalTo(strongSelf.mas_centerY);
    }];
    
    CGFloat buttonWidth = 14*4;
    _headerView.frame = CGRectMake(0, 0, width, DVVSelectTimeViewViewHeaderViewHeight);
    _cancelButton.frame = CGRectMake(0, 0, buttonWidth, DVVSelectTimeViewViewHeaderViewHeight);
    _doneButton.frame = CGRectMake(width - buttonWidth, 0, buttonWidth, DVVSelectTimeViewViewHeaderViewHeight);
    _titleLabel.frame = CGRectMake(buttonWidth, 0, width - buttonWidth*2, DVVSelectTimeViewViewHeaderViewHeight);
}

#pragma mark - data

- (void)loadData
{
    _hourArray = [NSMutableArray arrayWithCapacity:24];
    // 加载数据
    for (NSUInteger i = 0; i <= 24; i++)
    {
        [_hourArray addObject:FormatString(@"%02zd", i)];
    }
    
    _minuteArray = [NSMutableArray arrayWithCapacity:60];
    for (NSUInteger j = 0; j <= 59; j++)
    {
        [_minuteArray addObject:FormatString(@"%02zd", j)];
    }
    
//    DLog(@"%@ \n %@", _hourArray, _minuteArray);
}

- (void)refresh
{
    [_pickerView selectRow:_firstIdx inComponent:0 animated:YES];
    [_pickerView selectRow:_secondIdx inComponent:2 animated:YES];
    [_pickerView reloadComponent:0];
    [_pickerView reloadComponent:2];
}

#pragma mark - public

- (void)showFromView:(UIView *)superView
{
    // 防止重复加载到一个View上
    for (UIView *view in superView.subviews)
    {
        if ([view isKindOfClass:[self class]])
        {
            return;
        }
    }
    
    [superView addSubview:self];
    [self configUI];
    
    [UIView animateWithDuration:DVVSelectTimeViewShowAnimateDuration animations:^{
        self.backgroundEffectView.alpha = 1;
        self.containerView.alpha = 1;
    } completion:^(BOOL finished) {
        [self refresh];
    }];
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAnimation.values = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1, @1.03, @1.06, @1.09, @1.093, @1.096, @1.099, @1.1, @1.09, @1.08, @1.07, @1.06, @1.05, @1.04, @1.03, @1.02, @1.01, @1.009, @1.006, @1.003, @1];
    keyAnimation.duration = DVVSelectTimeViewShowAnimateDuration;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.containerView.layer addAnimation:keyAnimation forKey:nil];
    self.containerView.transform = CGAffineTransformMakeScale(1, 1);
}

- (void)defaultSelectedWithhour:(NSString *)hour
                         minute:(NSString *)minute
{
    __block NSUInteger tmpFirstIdx = 0, tmpSecondIdx = 0;
    
    if (![hour isEqualToString:@"24"])
    {
        [_hourArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([hour isEqualToString:obj])
            {
                tmpFirstIdx = idx;
                *stop = YES;
            }
        }];
    }
    
    [_minuteArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([minute isEqualToString:obj])
        {
            tmpSecondIdx = idx;
            *stop = YES;
        }
    }];
    
    _firstIdx = tmpFirstIdx;
    _secondIdx = tmpSecondIdx;
}

#pragma mark - action

- (void)doneButtonAction:(UIButton *)sender
{
    if (_didSelectedBlock)
    {
        NSInteger firstIdx = [_pickerView selectedRowInComponent:0];
        NSInteger secondIdx = [_pickerView selectedRowInComponent:2];
        _didSelectedBlock(_hourArray[firstIdx], _minuteArray[secondIdx]);
    }
    [self removeSelf];
    
}

- (void)removeSelf
{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAnimation.values = @[ @1, @0.999, @0.996, @0.993, @0.99, @0.96, @0.93, @0.9, @0.6, @0.3, @0 ];

    keyAnimation.duration = DVVSelectTimeViewRemoveAnimateDuration;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.containerView.layer addAnimation:keyAnimation forKey:nil];
    self.containerView.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:DVVSelectTimeViewRemoveAnimateDuration animations:^{
        self.backgroundEffectView.alpha = 0;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DVVSelectTimeViewRemoveAnimateDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (0 == component)
    {
        return _hourArray.count;
        
    }
    else if (1 == component)
    {
        return 1;
    }
    else
    {
//        DLog(@"%zd", [pickerView selectedRowInComponent:0]);
        if (_hourArray.count - 1 == [pickerView selectedRowInComponent:0]) return 1;
        else return _minuteArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 36;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (!label)
    {
        label = [UILabel new];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = true;
        label.numberOfLines = 0;
    }
    
    if (0 == component) label.text = _hourArray[row];
    else if (1 == component) label.text = @":";
    else label.text = _minuteArray[row];
    
    return label;
}

#pragma mark - UIPickerViewDataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component)
    {
        [pickerView reloadComponent:2];
    }
}

#pragma mark - lazy load

- (UIView *)containerView
{
    if (!_containerView)
    {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor redColor];
        
        _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
        _containerView.layer.shadowOpacity = 0.7;
        _containerView.layer.shadowOffset = CGSizeMake(0, 0);
        _containerView.layer.shadowRadius = 8;
    }
    return _containerView;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [UIPickerView new];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [UIView new];
        _headerView.backgroundColor = RGBColor(245, 245, 245);
    }
    return _headerView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton new];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)doneButton
{
    if (!_doneButton)
    {
        _doneButton = [UIButton new];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"请选择时间";
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIVisualEffectView *)backgroundEffectView
{
    if (!_backgroundEffectView)
    {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _backgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        /*
         TODO: UIVisualEffectView 的 opacity 问题
         打印信息为: is being asked to animate its opacity. This will cause the effect to appear broken until opacity returns to 1.
         */
        _backgroundEffectView.alpha = 0;
    }
    return _backgroundEffectView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

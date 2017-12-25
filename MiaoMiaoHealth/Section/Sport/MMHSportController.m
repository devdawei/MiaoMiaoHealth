//
//  MMHSportController.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/25.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHSportController.h"
#import "MMHSprotProgressView.h"
#import "MMHHealthManager.h"

@interface MMHSportController ()

/** 用这个 UIScrollView 是为了适配横屏下显示不完全问题 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *todayGoalLabel;

@property (weak, nonatomic) IBOutlet UIView *progressContentView;
@property (nonatomic, strong) MMHSprotProgressView *progressView;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;

@property (nonatomic, strong) UILabel *stepCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressContentViewTopConstraint;

@end

@implementation MMHSportController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [MMHAppConst controllerBgColor];
    self.naviTitle = @"运动数据";
    
    [_progressContentView addSubview:self.progressView];
    [_progressContentView addSubview:self.blurEffectView];
    [_blurEffectView.contentView addSubview:self.stepCountLabel];
    
    [self configUI];
    
    // 显示数据
    _todayGoalLabel.text = FormatString(@"今日目标：%zd步", [MMHUserManager sharedManager].stepGoal);
    
    // 注册步数目标改变的通知（在用户中心可以更改步数目标）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveStepGoalChangeNotification:)
                                                 name:kStepGoalChangeNotify
                                               object:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat topConstant = (ScreenHeight - 64 - 44 - 200 - (14.5*2 + 21)*2) / 2.0;
    if (topConstant < 12) topConstant = 12;
    _progressContentViewTopConstraint.constant = topConstant;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 刷新健康数据
    [self refreshHealthData];
}

#pragma mark - Config UI

- (void)configUI
{
    WS;
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        SWS;
        make.width.height.mas_equalTo(strongSelf.progressContentView.mas_height);
        make.centerX.mas_equalTo(strongSelf.progressContentView);
        make.centerY.mas_equalTo(strongSelf.progressContentView);
    }];
    
    CGFloat blurEffectSize = 161;
    [_blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        SWS;
        make.size.mas_equalTo(CGSizeMake(blurEffectSize, blurEffectSize));
        make.centerX.mas_equalTo(strongSelf.progressView);
        make.centerY.mas_equalTo(strongSelf.progressView);
    }];
    [_blurEffectView mmh_makeCornerRadius:blurEffectSize / 2.0];
    
    [_stepCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        SWS;
        make.centerX.mas_equalTo(strongSelf.blurEffectView.mas_centerX);
        make.centerY.mas_equalTo(strongSelf.blurEffectView.mas_centerY);
    }];
    
//    _todayGoalLabel.backgroundColor = [UIColor redColor];
//    _distanceLabel.backgroundColor = [UIColor redColor];
}

#pragma mark - Notification
#pragma mark 接收到步数目标改变的通知
- (void)didReceiveStepGoalChangeNotification:(NSNotification *)notification
{
    _todayGoalLabel.text = FormatString(@"今日目标：%zd步", [MMHUserManager sharedManager].stepGoal);
    [self refreshHealthData];
}

#pragma mark - Refresh data

- (void)refreshHealthData
{
    WS;
    [[MMHHealthManager sharedManager] authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success)
        {
            DLog(@"授权成功！");
            [[MMHHealthManager sharedManager] readStepCount:^(double value, NSError *error) {
                DLog(@"%f", value);
                SWS;
                strongSelf.stepCountLabel.text = FormatString(@"%.0f步", value);
                NSUInteger stepGoal = [MMHUserManager sharedManager].stepGoal;
                if (0 != stepGoal)
                {
                    DLog(@"%f", value / stepGoal);
                    strongSelf.progressView.progress = value / stepGoal;
                }
                else
                {
                    if (0 != value) strongSelf.progressView.progress = 1;
                    else strongSelf.progressView.progress = 0;
                }
            }];
            
            [[MMHHealthManager sharedManager] readDistance:^(double value, NSError *error) {
                DLog(@"%f", value);
                SWS;
                strongSelf.distanceLabel.text = FormatString(@"步行+跑步距离：%.2f公里", value);
            }];
        }
        else
        {
            DLog(@"授权失败！");
        }
    }];
}

#pragma mark - Lazy load

- (MMHSprotProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [MMHSprotProgressView new];
        _progressView.lineWidth = 20;
    }
    return _progressView;
}

- (UIVisualEffectView *)blurEffectView
{
    if (!_blurEffectView)
    {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurEffectView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshHealthData)];
        [_blurEffectView addGestureRecognizer:tapGes];
    }
    return _blurEffectView;
}

- (UILabel *)stepCountLabel
{
    if (!_stepCountLabel)
    {
        _stepCountLabel = [UILabel new];
        _stepCountLabel.textColor = [UIColor whiteColor];
        _stepCountLabel.font = [UIFont systemFontOfSize:32];
        _stepCountLabel.text = @"0步";
    }
    return _stepCountLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

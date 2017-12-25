//
//  MMHUserCenterController.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/25.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHUserCenterController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <DVVImagePickerControllerManager.h>
#import "MMHTableCell.h"
#import "MMHSingleLineInputController.h"
#import "MMHAboutUsController.h"
#import "MMHTabBarController.h"
#import "MMHDrinkWaterController.h"

typedef NS_ENUM(NSUInteger, MMHUserCenterSelectImageType)
{
    /** 头像 */
    MMHUserCenterSelectImageTypePortrait,
    /** 头像背景 */
    MMHUserCenterSelectImageTypeHeaderBgImg
};

/** headerView的高度占宽度的比例 */
static CGFloat const kHeaderRatio = 1.0;
static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface MMHUserCenterController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIImagePickerControllerDelegate, UIViewControllerPreviewingDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIVisualEffectView *headerContentView;
@property (nonatomic, strong) UIImageView *headerBgImageView;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *markArray;

@property (nonatomic, assign) MMHUserCenterSelectImageType selectImageType;

//@property (nonatomic, strong) MMHAboutUsController *aboutUsVC;

@end

@implementation MMHUserCenterController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [MMHAppConst controllerBgColor];
    // 此界面隐藏导航栏
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initSelf];
    
    [self configUI];
    
    // 喝水提醒状态全部开启或关闭的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDrinkWaterAllOnStatusChangeNotification:)
                                                 name:kDrinkWaterAllOnStatusChangeNotify
                                               object:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _headerView.bounds = CGRectMake(0, 0, ScreenWidth, ScreenWidth * kHeaderRatio);
    _footerView.bounds = CGRectMake(0, 0, ScreenWidth, 24);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - Init

- (void)initSelf
{
    [self initData];
    
    [self.headerView addSubview:self.headerContentView];
    [_headerContentView.contentView addSubview:self.headerBgImageView];
    [_headerContentView.contentView addSubview:self.portraitImageView];
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.tableFooterView = self.footerView;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initData
{
    _titleArray = @[ @"步数目标",
                     @"喝水提醒",
                     @"关于我们" ].mutableCopy;
    
    _markArray = @[ FormatString(@"%zd步", [MMHUserManager sharedManager].stepGoal),
                    @"",
                    @"" ].mutableCopy;
}

#pragma mark - Config UI

- (void)configUI
{
    WS;
    
    /**
     *  用这个设置没有把TableView的tableHeaderView撑开，所以就直接设置了_headerView的bounds
     */
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        SWS;
//        make.top.left.mas_equalTo(0);
//        make.width.mas_equalTo(strongSelf.tableView);
//        make.height.mas_equalTo(strongSelf.headerView.mas_width).multipliedBy(0.5);
//    }];
    
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        SWS;
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(strongSelf.headerView);
        make.height.mas_equalTo(strongSelf.headerContentView.mas_width).multipliedBy(kHeaderRatio);
    }];
    
    [self.headerBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    CGFloat portraitSize = 80;
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        SWS;
        make.size.mas_equalTo(CGSizeMake(portraitSize, portraitSize));
        make.centerX.centerY.mas_equalTo(strongSelf.headerContentView);
    }];
    [_portraitImageView mmh_makeCornerRadius:portraitSize / 2.0];
}


#pragma mark - Notification
#pragma mark 接收到喝水提醒状态全部开启或关闭的通知
- (void)didReceiveDrinkWaterAllOnStatusChangeNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark - Action
#pragma mark 头像图片点击事件
- (void)portraitImageViewAction:(UITapGestureRecognizer *)tapGes
{
    _selectImageType = MMHUserCenterSelectImageTypePortrait;
    [DVVImagePickerControllerManager showFromController:self delegate:self canEdit:YES];
}

#pragma mark 头像背景图片点击事件
- (void)headerBgImageViewAction:(UITapGestureRecognizer *)tapGes
{
    _selectImageType = MMHUserCenterSelectImageTypeHeaderBgImg;
    [DVVImagePickerControllerManager showFromController:self delegate:self canEdit:YES];
}

#pragma mark 喝水提醒全部打开或关闭按钮事件
- (void)switchControlValueChangeAction:(UISwitch *)sender
{
    DLog(@"isOn: %zd", sender.isOn);
    
    if (sender.isOn)
    {
        [[MMHTabBarController sharedTabBarController].drinkWaterVC openAllLocalNotifications];
    }
    else
    {
        [[MMHTabBarController sharedTabBarController].drinkWaterVC cancelAllLocalNotifications];
    }
}

- (void)pushToAboutUSController
{
    MMHAboutUsController *aboutUsVC = [MMHAboutUsController new];
    aboutUsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutUsVC animated:YES];
    [self statisticsIntoAboutUsController];
}

- (void)pushToStepGoalController
{
    [self pushToStepGoalControllerWithStepCount:FormatString(@"%zd", [MMHUserManager sharedManager].stepGoal)];
}

- (void)pushToStepGoalControllerWithStepCount:(NSString *)stepCount
{
    MMHSingleLineInputController *singleLineInputVC = [MMHSingleLineInputController new];
    singleLineInputVC.navigationItem.title = @"步数目标";
    singleLineInputVC.keyboardType = UIKeyboardTypeNumberPad; // 没有小数点的数字键盘
    singleLineInputVC.text = stepCount;
    singleLineInputVC.placeholder = @"请输入步数";
    WS;
    [singleLineInputVC setDoneBlock:^(NSString *contentString) {
        DLog(@"%@", contentString);
        SWS;
        if (contentString &&
            contentString.length)
        {
            [MMHUserManager sharedManager].stepGoal = [contentString integerValue];
            // 缓存用户数据
            [[MMHUserManager sharedManager] storage];
            // 重新加载数据
            [strongSelf initData];
            // 刷新表格
            [strongSelf.tableView reloadData];
            // 发送步数目标改变的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kStepGoalChangeNotify object:nil];
        }
    }];
    
    singleLineInputVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:singleLineInputVC animated:YES];
    
    [MobClick event:@"IntoChangeStepGoalController"]; // 统计进入修改步数目标控制器的次数
}

- (void)statisticsIntoAboutUsController
{
    [MobClick event:@"IntoAboutUsController"]; // 统计进入关于我们控制器的次数
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage]; // 编辑过后的图片
    
    if (MMHUserCenterSelectImageTypePortrait == _selectImageType)
    {
        self.portraitImageView.image = image;
        // 缓存用户中心 header 中的头像
        [MMHUserManager sharedManager].userCenterheaderPortraitImage = image;
        [[MMHUserManager sharedManager] storage];
        
    }
    else if (MMHUserCenterSelectImageTypeHeaderBgImg == _selectImageType)
    {
        self.headerBgImageView.image = image;
        // 缓存用户中心 header 中的背景图片
        [MMHUserManager sharedManager].userCenterheaderBgImage = image;
        [[MMHUserManager sharedManager] storage];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    DLog(@"offertY = %f", offsetY);
    if (offsetY < 0)
    {
        WS;
        [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            SWS;
            make.top.mas_equalTo(offsetY);
            make.left.mas_equalTo(offsetY / 2.0);
            make.width.mas_equalTo(strongSelf.headerView).offset(-offsetY);
        }];
    }
    else
    {
        WS;
        [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            SWS;
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(strongSelf.headerView);
        }];
    }
}

#pragma mark - Previewing delegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    if (2 == [previewingContext sourceView].tag)
    {
        MMHAboutUsController *aboutUsVC = [MMHAboutUsController new];
        return aboutUsVC;
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    viewControllerToCommit.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
    [self statisticsIntoAboutUsController];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMHTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell)
    {
        cell = [[MMHTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        [cell.switchControl addTarget:self action:@selector(switchControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    }
    cell.tag = indexPath.row;
    
    cell.titleString = _titleArray[indexPath.row];
    cell.markString = _markArray[indexPath.row];
    
    // 显示或隐藏右侧的 UISwitch 控件
    if (1 == indexPath.row)
    {
        cell.switchControlHidden = NO;
        cell.switchControl.on = [MMHTabBarController sharedTabBarController].drinkWaterVC.isAllLocalNotificationsOn;
    }
    else cell.switchControlHidden = YES;
    
    // 显示或隐藏右侧的箭头
    if (1 == indexPath.row) cell.arrowImageViewHidden = YES;
    else cell.arrowImageViewHidden = NO;

    // 打开或关闭 cell 的点击效果
    if (1 == indexPath.row) cell.selectionStyle = UITableViewCellSelectionStyleNone;
    else cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    // 显示或隐藏 cell 底部的细线
    if (self.titleArray.count - 1 == indexPath.row) cell.bottomLineImageView.hidden = YES;
    else cell.bottomLineImageView.hidden = NO;
    
    // 添加forceTouch
    if (2 == indexPath.row)
    {
        if (IS_IOS9_LATER &&
            UIForceTouchCapabilityAvailable == self.traitCollection.forceTouchCapability)
        {
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MMHTableCell *cell = (MMHTableCell *)([tableView cellForRowAtIndexPath:indexPath]);
    
    if ([cell.titleString isEqualToString:@"步数目标"])
    {
        [self pushToStepGoalControllerWithStepCount:[cell.markString substringWithRange:NSMakeRange(0, cell.markString.length - 1)]]; // 默认显示内容
    }
    else if ([cell.titleString isEqualToString:@"关于我们"])
    {
        [self pushToAboutUSController];
    }
}

#pragma mark - Lazy load

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [UIView new];
    }
    return _headerView;
}

- (UIVisualEffectView *)headerContentView
{
    if (!_headerContentView)
    {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _headerContentView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    return _headerContentView;
}

- (UIImageView *)headerBgImageView
{
    if (!_headerBgImageView)
    {
        _headerBgImageView = [UIImageView new];
        _headerBgImageView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerBgImageViewAction:)];
        [_headerBgImageView addGestureRecognizer:tapGes];
        _headerBgImageView.userInteractionEnabled = YES;
        
        // 读取缓存
        _headerBgImageView.image = [MMHUserManager sharedManager].userCenterheaderBgImage;
    }
    return _headerBgImageView;
}

- (UIImageView *)portraitImageView
{
    if (!_portraitImageView)
    {
        _portraitImageView = [UIImageView new];
        _portraitImageView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(portraitImageViewAction:)];
        [_portraitImageView addGestureRecognizer:tapGes];
        _portraitImageView.userInteractionEnabled = YES;
        
        // 读取缓存
        _portraitImageView.image = [MMHUserManager sharedManager].userCenterheaderPortraitImage;
    }
    return _portraitImageView;
}

- (UIView *)footerView
{
    if (!_footerView)
    {
        _footerView = [UIView new];
    }
    return _footerView;
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

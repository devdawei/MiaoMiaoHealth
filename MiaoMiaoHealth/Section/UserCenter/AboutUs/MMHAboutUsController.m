//
//  MMHAboutUsController.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/31.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHAboutUsController.h"
#import "MMHTableCell.h"
#import <THLabel/THLabel.h>
#import "DVVAppStoreTool.h"

static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface MMHAboutUsController () <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) THLabel *versionLabel;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *briefLabel;

@end

#define VersionLabelFontSize 17
#define BriefLabelFont [UIFont systemFontOfSize:14]
#define BriefString @"非常感谢您使用喵喵健康"

@implementation MMHAboutUsController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [MMHAppConst controllerBgColor];
    self.naviTitle = @"关于我们";
    [self mmh_addBackBarButtonItem];
    
    [self.view addSubview:self.tableView];
    [self.headerView addSubview:self.iconImageView];
    [self.headerView addSubview:self.versionLabel];
    
    [self.footerView addSubview:self.briefLabel];
    
    [self autoLayout];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 205);
    CGFloat iconSize = 80;
    _iconImageView.frame = CGRectMake((ScreenWidth - iconSize) / 2.0, 50, iconSize, iconSize);
    _versionLabel.frame = CGRectMake(0, CGRectGetMaxY(_iconImageView.frame), CGRectGetWidth(self.headerView.frame), VersionLabelFontSize + 8*2);
    self.tableView.tableHeaderView = self.headerView;
    
    CGFloat width = ScreenWidth - 12*2;
    _briefLabel.frame = CGRectMake(12,
                                   20,
                                   width,
                                   [NSString dynamicHeightWithString:BriefString width:width font:BriefLabelFont]);
    self.footerView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_briefLabel.frame) + 36 + 36);
    self.tableView.tableFooterView = self.footerView;
    
    _iconImageView.backgroundColor = [UIColor lightGrayColor];
//    _versionLabel.backgroundColor = [UIColor magentaColor];
//    _briefLabel.backgroundColor = [UIColor orangeColor];
}

#pragma mark - Action

- (void)goScore
{
    [DVVAppStoreTool goAppStoreScore:MMH_APP_ID];
    
    [MobClick event:@"GoGrade"]; // 统计去评分
}

- (void)copyWeiXin
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"idawei987";
    [DVVToast showMessage:@"已复制微信号"];
    
    [MobClick event:@"CopyWeChatAccount"]; // 统计复制微信号
}

- (void)copyMail
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"2549129899@qq.com";
    [DVVToast showMessage:@"已复制邮箱"];
    
    [MobClick event:@"CopyFeedbackMailbox"]; // 统计复制反馈邮箱
}

#pragma mark - UIPreviewActionItem

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *goScore = [UIPreviewAction actionWithTitle:@"给个好评" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self goScore];
    }];
    
    UIPreviewAction *copyWeiXin = [UIPreviewAction actionWithTitle:@"个人微信" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self copyWeiXin];
    }];
    
    UIPreviewAction *copyMail = [UIPreviewAction actionWithTitle:@"反馈邮箱" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self copyMail];
    }];
    
    return @[ goScore, copyWeiXin, copyMail ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMHTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if (0 == indexPath.row)
    {
        cell.titleString = @"给个好评";
        cell.markString = @"去评分";
    }
    else if (1 == indexPath.row)
    {
        cell.titleString = @"个人微信";
        cell.markString = @"idawei987";
    }
    else if (2 == indexPath.row)
    {
        cell.titleString = @"反馈邮箱";
        cell.markString = @"2549129899@qq.com";
        cell.bottomLineImageView.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MMHTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *titleString = cell.titleString;
    
    if ([titleString isEqualToString:@"给个好评"])
    {
        [self goScore];
    }
    else if ([titleString isEqualToString:@"个人微信"])
    {
        [self copyWeiXin];
    }
    else if ([titleString isEqualToString:@"反馈邮箱"])
    {
        [self copyMail];
    }
}

#pragma mark - AutoLayout

- (void)autoLayout
{
    WS;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakSelf.view);
    }];
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

- (UIImageView *)iconImageView
{
    if (!_iconImageView)
    {
        _iconImageView = [UIImageView new];
        _iconImageView.image = [UIImage imageNamed:@"ic_aboutUs_logo"];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 18;
    }
    return _iconImageView;
}

- (THLabel *)versionLabel
{
    if (!_versionLabel)
    {
        _versionLabel = [THLabel new];
        _versionLabel.text = APPVersion;
        _versionLabel.textColor = RGBColor(51, 51, 51);
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = [UIFont boldSystemFontOfSize:VersionLabelFontSize];
        
        _versionLabel.strokeSize = 1;
        _versionLabel.strokeColor = [UIColor whiteColor];
    }
    return _versionLabel;
}

- (UIView *)footerView
{
    if (!_footerView)
    {
        _footerView = [UIView new];
    }
    return _footerView;
}

- (UILabel *)briefLabel
{
    if (!_briefLabel)
    {
        _briefLabel = [UILabel new];
        _briefLabel.font = BriefLabelFont;
        _briefLabel.numberOfLines = 0;
        _briefLabel.text = BriefString;
        _briefLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _briefLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _briefLabel;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [MMHAppConst controllerBgColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MMHTableCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _tableView;
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

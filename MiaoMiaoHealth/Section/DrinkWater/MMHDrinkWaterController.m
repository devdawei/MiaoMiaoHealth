//
//  MMHDrinkWaterController.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHDrinkWaterController.h"
#import "MMHTabBarController.h"
#import "MMHDrinkWaterTableCell.h"
#import "MMHDrinkWaterDMData.h"
#import "MMHDrinkWaterNotifyManager.h"
#import "DVVSelectTimeView.h"

static NSString * const kTurnOn = @"1";
static NSString * const kTurnOff = @"0";

static NSString * const kStorageFileName = @"mmh_drinkWater";
static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface MMHDrinkWaterController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) NSMutableArray<MMHDrinkWaterDMData *> *dataArray;

@end

@implementation MMHDrinkWaterController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [MMHAppConst controllerBgColor];
    self.naviTitle = @"喝水提醒";
    
    [self initSelf];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#ifdef DEBUG
    NSArray<UILocalNotification *> *notifyArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    DLog(@"通知的个数: %zd", notifyArray.count);
    
    if ([DVVArchiver fileExistsWithType:DVVArchiverTypePreferences name:kStorageFileName])
    {
        DLog(@"有文件！");
    }
    else
    {
        DLog(@"没有文件！");
    }
    
    NSMutableArray *tmpDataArray = [DVVArchiver unarchiveWithType:DVVArchiverTypePreferences name:kStorageFileName];
    if (!tmpDataArray || !tmpDataArray.count)
    {
        DLog(@"没有数据！");
    }
    else
    {
        DLog(@"有数据！");
    }
#endif
}

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        if ([DVVArchiver fileExistsWithType:DVVArchiverTypePreferences name:kStorageFileName])
        {
            DLog(@"有文件！");
        }
        else
        {
            DLog(@"没有文件！");
            /*
             如果我们的应用程序给系统发送的本地通知是周期性的，那么即使把程序删了重装，之前的本地通知在重装时依然存在（没有从系统中移除）。
             */
            // 清除所有旧的通知
            [MMHDrinkWaterNotifyManager cancelAllLocalNotifications];
        }
        
        /*
         在 init 的时候初始化数据，因为当此 controller 没有打开的时候，用户可能在个人中心开启或关闭所有的喝水提醒
         */
        [self initData];
    }
    return self;
}

- (void)initSelf
{
    self.headerView.bounds = CGRectMake(0, 0, ScreenWidth, 50);
    self.headerLabel.frame = CGRectMake(12, 0, ScreenWidth - 12, CGRectGetHeight(self.headerView.bounds));
    [self.headerView addSubview:self.headerLabel];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MMHDrinkWaterTableCell class]) bundle:nil] forCellReuseIdentifier:kCellIdentifier];
}

- (void)initData
{
    NSMutableArray *tmpDataArray = [DVVArchiver unarchiveWithType:DVVArchiverTypePreferences name:kStorageFileName];
    if (!tmpDataArray || !tmpDataArray.count)
    {
        NSUInteger flage = 7;
        self.dataArray = [NSMutableArray array];
        for (NSUInteger i = 0; i < 8; i++)
        {
            if (24 == flage) flage = 0;
            
            MMHDrinkWaterDMData *dmData = [MMHDrinkWaterDMData new];
            dmData.time = FormatString(@"%02zd:00", flage);
            dmData.isTurnOn = [kTurnOn integerValue];
            
            [self.dataArray addObject:dmData];
            
            flage += 2;
            
            // 添加到通知列表中
            [MMHDrinkWaterNotifyManager addLocalNotification:dmData];
        }
        
        // 存储数据
        [self storageData];
    }
    else
    {
        _dataArray = tmpDataArray;
    }
}

#pragma mark - Storage

- (void)storageData
{
    [DVVArchiver archiverWithType:DVVArchiverTypePreferences object:_dataArray name:kStorageFileName];
}

#pragma mark - Action

- (void)switchValueChangeAction:(MMHDrinkWaterTableCell *)cell isTurnOn:(BOOL)isTurnOn
{
    // 在修改之前检查下所有的开关状态是否是全部开启
    BOOL allOnInBeforeChange = [self isAllLocalNotificationsOn];
    
    MMHDrinkWaterDMData *dmData = _dataArray[cell.tag];
    dmData.isTurnOn = isTurnOn;
    
    // 存储数据
    [self storageData];
    
    if (isTurnOn) [MMHDrinkWaterNotifyManager addLocalNotification:cell.dmData]; // 添加到通知列表
    else [MMHDrinkWaterNotifyManager cancelLocalNotification:cell.dmData]; // 从通知列表移除
    
    // 检查所有的喝水提醒状态是否全部开启
    __block BOOL allOn = YES;
    [self.dataArray enumerateObjectsUsingBlock:^(MMHDrinkWaterDMData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (NO == obj.isTurnOn) allOn = NO;
    }];
    
    // 根据状态发送通知
    if (allOnInBeforeChange || allOn)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDrinkWaterAllOnStatusChangeNotify
                                                            object:nil];
    }
}

#pragma mark - Public
#pragma mark 用来判断是否所有的喝水提醒都打开了
- (BOOL)isAllLocalNotificationsOn
{
    __block BOOL flage = YES;
    [self.dataArray enumerateObjectsUsingBlock:^(MMHDrinkWaterDMData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(NO == obj.isTurnOn)
        {
            flage = NO;
            *stop = YES;
        }
    }];
    return flage;
}

#pragma mark 取消所有的喝水提醒
- (void)cancelAllLocalNotifications
{
    [MMHDrinkWaterNotifyManager cancelAllLocalNotifications];
    
    [self.dataArray enumerateObjectsUsingBlock:^(MMHDrinkWaterDMData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isTurnOn)
        {
            obj.isTurnOn = NO;
        }
    }];
    // 存储数据
    [self storageData];
    [self.tableView reloadData];
}

#pragma mark 打开所有的喝水提醒
- (void)openAllLocalNotifications
{
    [self.dataArray enumerateObjectsUsingBlock:^(MMHDrinkWaterDMData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isTurnOn = YES;
        [MMHDrinkWaterNotifyManager addLocalNotification:obj];
    }];
    // 存储数据
    [self storageData];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMHDrinkWaterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell.switchValueChangeBlock)
    {
        WS;
        [cell setSwitchValueChangeBlock:^(MMHDrinkWaterTableCell *cell, BOOL isTurnOn) {
            SWS;
            [strongSelf switchValueChangeAction:cell isTurnOn:isTurnOn];
        }];
    }
    
    cell.dmData = _dataArray[indexPath.row];
    
    if (self.dataArray.count - 1 == indexPath.row) cell.bottomLineImageView.hidden = YES;
    else cell.bottomLineImageView.hidden = NO;
    
    cell.tag = indexPath.row;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MMHDrinkWaterTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *hour = [cell.titleLabel.text substringWithRange:NSMakeRange(0, 2)];
    NSString *minute = [cell.titleLabel.text substringWithRange:NSMakeRange(3, 2)];
    DLog(@"%@, %@", hour, minute);
    DVVSelectTimeView *view = [DVVSelectTimeView new];
    [view defaultSelectedWithhour:hour minute:minute];
    WS;
    WeakObj(cell, weakCell);
    [view setDidSelectedBlock:^(NSString *hour, NSString *minute) {
        DLog(@"%@, %@", hour, minute);
        SWS;
        StrongObj(weakCell, strongCell);
        
        // 在数据更改之前先取消之前的通知
        [MMHDrinkWaterNotifyManager cancelLocalNotification:strongCell.dmData];
        
        NSString *timeString = FormatString(@"%@:%@", hour, minute);
        
        // 刷新 Cell 中显示的时间
        strongCell.titleLabel.text = timeString;
        
        DLog(@"%@", strongSelf.dataArray[cell.tag].time);
        // 刷新 Cell 中的数据模型存储的时间 （因为 Cell中的数据模型是引用 dataArray 里的数据模型，所以Cell 中的数据模型存储的时间更改后，即更改了数据列表中存储的时间）
        strongCell.dmData.time = timeString;
        DLog(@"%@", strongSelf.dataArray[cell.tag].time);
        
        // 数据列表中时间更改后，马上缓存到本地
        [strongSelf storageData];
        
        // 添加到通知列表中
        MMHDrinkWaterDMData *dmData = [MMHDrinkWaterDMData new];
        dmData.time = timeString;
        dmData.isTurnOn = [kTurnOn integerValue];
        [MMHDrinkWaterNotifyManager addLocalNotification:dmData];
    }];
    [view showFromView:self.view];
}

#pragma mark - Lazy load

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [UIView new];
        _headerView.backgroundColor = RGBColor(245, 245, 245);
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView)
    {
        _footerView = [UIView new];
    }
    return _footerView;
}

- (UILabel *)headerLabel
{
    if (!_headerLabel)
    {
        _headerLabel = [UILabel new];
        _headerLabel.textColor = [UIColor redColor];
        _headerLabel.font = [UIFont systemFontOfSize:17];
        _headerLabel.text = @"按时喝水，保持健康";
    }
    return _headerLabel;
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

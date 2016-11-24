//
//  MMHTabBarController.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHTabBarController.h"
#import "MMHSportController.h"
#import "MMHDrinkWaterController.h"
#import "MMHUserCenterController.h"

typedef NS_OPTIONS(NSInteger, MMHTabBarItemType) {
    /** 运动 */
    MMHTabBarItemTypeSport,
    /** 喝水 */
    MMHTabBarItemTypeDrinkWater,
    /** 用户中心 */
    MMHTabBarItemTypeUserCenter
};

@interface MMHTabBarController ()

@end

@implementation MMHTabBarController

+ (instancetype)sharedTabBarController
{
    static MMHTabBarController *tabBarController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBarController = [MMHTabBarController new];
    });
    return tabBarController;
}

- (void)naviControllerPopToRootController
{
    for(UIViewController *vc in self.viewControllers)
    {
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            [(UINavigationController *)vc popToRootViewControllerAnimated:NO];
        }
    }
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initSelf];
        
        // 选中按钮的颜色
        self.tabBar.tintColor = [UIColor colorWithHexString:@"333333"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 隐藏TabBar顶部分割线
    [self findHairlineImageViewUnder:self.tabBar].hidden = YES;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if([view isKindOfClass:UIImageView.class] &&
       view.bounds.size.height <= 1.0)
    {
        return(UIImageView *)view;
    }
    
    for(UIView*subview in view.subviews)
    {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if(imageView)
        {
            return imageView;
        }
    }
    return nil;
}

- (void)initSelf
{
    _canRotate = YES;
    
    _sportVC = [MMHSportController new];
    _sportNaviVC = [[UINavigationController alloc] initWithRootViewController:_sportVC];
    [self configTabBarItemWithType:MMHTabBarItemTypeSport naviVC:_sportNaviVC];

    _drinkWaterVC = [MMHDrinkWaterController new];
    _drinkWaterNaviVC = [[UINavigationController alloc] initWithRootViewController:_drinkWaterVC];
    [self configTabBarItemWithType:MMHTabBarItemTypeDrinkWater naviVC:_drinkWaterNaviVC];
    
    _userCenterVC = [MMHUserCenterController new];
    _userCenterNaviVC = [[UINavigationController alloc] initWithRootViewController:_userCenterVC];
    [self configTabBarItemWithType:MMHTabBarItemTypeUserCenter naviVC:_userCenterNaviVC];
    
    self.viewControllers = @[ _sportNaviVC, _drinkWaterNaviVC, _userCenterNaviVC ];
}

- (void)configTabBarItemWithType:(MMHTabBarItemType)tabBarItemType
                          naviVC:(UINavigationController *)naviVC
{
    switch (tabBarItemType)
    {
        case MMHTabBarItemTypeSport:
        {
            naviVC.tabBarItem.tag = MMHTabBarItemTypeSport; // 设置tag值
            naviVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"运动"
                                                              image:[UIImage imageNamed:@"ic_tabBar_home_normal"]
                                                      selectedImage:[UIImage imageNamed:@"ic_tabBar_home_selected"]];
        }
            break;
        case MMHTabBarItemTypeDrinkWater:
        {
            naviVC.tabBarItem.tag = MMHTabBarItemTypeDrinkWater; // 设置tag值
            naviVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"喝水"
                                                              image:[UIImage imageNamed:@"ic_tabBar_classify_normal"]
                                                      selectedImage:[UIImage imageNamed:@"ic_tabBar_classify_selected"]];
        }
            break;
        case MMHTabBarItemTypeUserCenter:
        {
            naviVC.tabBarItem.tag = MMHTabBarItemTypeUserCenter; // 设置tag值
            naviVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                              image:[UIImage imageNamed:@"ic_tabBar_userCenter_normal"]
                                                      selectedImage:[UIImage imageNamed:@"ic_tabBar_userCenter_selected"]];
        }
            break;
    }
    
    [naviVC.tabBarItem setTitleTextAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:11],
                                                 NSForegroundColorAttributeName:RGBColor(64, 64, 64) }
                                     forState:UIControlStateNormal];
    
    [naviVC.tabBarItem setTitleTextAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:11],
                                                 NSForegroundColorAttributeName:[MMHAppConst naviBgColor] }
                                     forState:UIControlStateSelected];
}

#pragma mark - Autorotate

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (_canRotate)
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    
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

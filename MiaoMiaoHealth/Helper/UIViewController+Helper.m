//
//  UIViewController+Helper.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/24.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "UIViewController+Helper.h"
#import <objc/runtime.h>

static char kNaviLeftButton, kNaviRightButton, kNaviTitleButton;

@implementation UIViewController (Helper)

@dynamic naviLeftButton, naviLeftTitle, naviRightButton, naviRightTitle, naviTitleButton, naviTitle;

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 交换ViewDidLoad的实现
        Method originViewDidLoadImp = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method swizzViewDidLoadImp  = class_getInstanceMethod(self, @selector(mmh_viewDidLoad));
        method_exchangeImplementations(originViewDidLoadImp, swizzViewDidLoadImp);
        
        // 交换preferredStatusBarStyle的实现
        Method originPreferredStatusBarStyleImp = class_getInstanceMethod(self, @selector(preferredStatusBarStyle));
        Method swizzPreferredStatusBarStyleImp  = class_getInstanceMethod(self, @selector(mmh_preferredStatusBarStyle));
        method_exchangeImplementations(originPreferredStatusBarStyleImp, swizzPreferredStatusBarStyleImp);
    });
}

#pragma mark - Life cycle

- (void)mmh_viewDidLoad
{
    [self mmh_viewDidLoad]; // // 调用原Imp
    // 统一添加返回按钮
    [self mmh_addBackBarButtonItemMethod];
}

#pragma mark - BackBarButtonItem

- (void)mmh_addBackBarButtonItemMethod
{
    if (!self.navigationController) return;
    if (self.navigationController.viewControllers.count < 2) return;
    if (self.navigationItem.leftBarButtonItem) return;
    [self mmh_addBackBarButtonItem];
}

- (void)mmh_addBackBarButtonItem
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton.imageView setContentMode:UIViewContentModeCenter];
    [backButton setImage:[UIImage imageNamed:@"ic_navi_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"ic_navi_back"] forState:UIControlStateSelected];
    [backButton setImage:[UIImage imageNamed:@"ic_navi_back"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(mmh_backBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)mmh_backBarButtonItemAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - StatusBarStyle

-(UIStatusBarStyle)mmh_preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - NaviLeft

- (void)setNaviLeftButton:(UIButton *)naviLeftButton
{
    objc_setAssociatedObject(self, &kNaviLeftButton, naviLeftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)naviLeftButton
{
    UIButton *button = (UIButton *)objc_getAssociatedObject(self, &kNaviLeftButton);
    if (!button)
    {
        button = self.naviLeftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitleColor:[MMHAppConst naviFgColor] forState:UIControlStateNormal];
        button.titleLabel.font = [MMHAppConst naviItemFont];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
    }
    return button;
}

- (void)setNaviLeftTitle:(NSString *)naviLeftTitle
{
    [self.naviLeftButton setTitle:naviLeftTitle forState:UIControlStateNormal];
    self.naviLeftButton.bounds = CGRectMake(0, 0, [NSString dynamicWidthWithString:naviLeftTitle font:[MMHAppConst naviItemFont]], 44);
}

- (NSString *)naviLeftTitle
{
    return self.naviLeftButton.titleLabel.text;
}

#pragma mark - NaviRight

- (void)setNaviRightButton:(UIButton *)naviRightButton
{
    objc_setAssociatedObject(self, &kNaviRightButton, naviRightButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)naviRightButton
{
    UIButton *button = (UIButton *)objc_getAssociatedObject(self, &kNaviRightButton);
    if (!button)
    {
        button = self.naviRightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitleColor:[MMHAppConst naviFgColor] forState:UIControlStateNormal];
        button.titleLabel.font = [MMHAppConst naviItemFont];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = item;
    }
    return button;
}

- (void)setNaviRightTitle:(NSString *)naviRightTitle
{
    [self.naviRightButton setTitle:naviRightTitle forState:UIControlStateNormal];
    self.naviRightButton.bounds = CGRectMake(0, 0, [NSString dynamicWidthWithString:naviRightTitle font:[MMHAppConst naviItemFont]], 44);
}

- (NSString *)naviRightTitle
{
    return self.naviRightButton.titleLabel.text;
}

#pragma mark - NaviTitle

- (void)setNaviTitleButton:(UIButton *)naviTitleButton
{
    objc_setAssociatedObject(self, &kNaviTitleButton, naviTitleButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)naviTitleButton
{
    UIButton *button = (UIButton *)objc_getAssociatedObject(self, &kNaviTitleButton);
    if (!button)
    {
        button = self.naviTitleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitleColor:[MMHAppConst naviFgColor] forState:UIControlStateNormal];
        button.titleLabel.font = [MMHAppConst naviTitleFont];
        self.navigationItem.titleView = button;
    }
    return button;
}

- (void)setNaviTitle:(NSString *)naviTitle
{
    [self.naviTitleButton setTitle:naviTitle forState:UIControlStateNormal];
    self.naviTitleButton.bounds = CGRectMake(0, 0, [NSString dynamicWidthWithString:naviTitle font:[MMHAppConst naviTitleFont]], 44);
}

- (NSString *)naviTitle
{
    return self.naviTitleButton.titleLabel.text;
}

@end

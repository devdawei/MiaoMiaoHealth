//
//  UINavigationBar+Helper.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/25.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "UINavigationBar+Helper.h"

@implementation UINavigationBar (Helper)

+ (void)load
{
    UINavigationBar *bar = [UINavigationBar appearance];
    

//    // 透明效果
//    [bar setTranslucent:YES];
    
    
//    // 设置默认返回按钮的图片
//    [bar setBackIndicatorImage:[UIImage imageNamed:@"ic_navi_back"]];
//    [bar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"ic_navi_back"]];
    
//    // 背景图片
//    [bar setBackgroundImage:[UIImage imageNamed:@"img_navi_bgImage"] forBarMetrics:UIBarMetricsDefault];
    
    
    // 背景色
    [bar setBarTintColor:[MMHAppConst naviBgColor]];
    [bar setBackgroundColor:[MMHAppConst naviBgColor]];
    
    // 控件颜色
    [bar setTintColor:[MMHAppConst naviFgColor]];
    
    
    // 标题字体颜色
    [bar setTitleTextAttributes:@{ NSForegroundColorAttributeName:[MMHAppConst naviFgColor],
                                   NSFontAttributeName:[MMHAppConst naviTitleFont] }];
    
    // Item字体颜色
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{ NSForegroundColorAttributeName:[MMHAppConst naviFgColor],
                                    NSFontAttributeName:[MMHAppConst naviTitleFont] } forState:UIControlStateNormal];
}

@end

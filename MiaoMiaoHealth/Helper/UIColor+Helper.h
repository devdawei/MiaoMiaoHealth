//
//  UIColor+helper.h
//  MiaoMiaoRadio
//
//  Created by 大威 on 16/5/20.
//  Copyright © 2016年 iosdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)

+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

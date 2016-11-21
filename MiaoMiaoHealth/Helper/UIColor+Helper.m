//
//  UIColor+helper.m
//  MiaoMiaoRadio
//
//  Created by 大威 on 16/5/20.
//  Copyright © 2016年 iosdawei. All rights reserved.
//

#import "UIColor+Helper.h"

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation UIColor (Helper)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [UIColor colorWithHexString:color alpha:1.f];
}

@end

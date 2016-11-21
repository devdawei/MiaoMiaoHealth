//
//  UIView+Helper.m
//  DingDangB2B
//
//  Created by 大威 on 16/7/12.
//  Copyright © 2016年 药交汇. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (void)mmh_makeCornerRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

+ (UIImageView *)mmh_findHairlineImageView:(UIView *)view
{
    if([view isKindOfClass:UIImageView.class] &&
       view.bounds.size.height <= 1.0)
    {
        return(UIImageView *)view;
    }
    
    for(UIView *subview in view.subviews)
    {
        UIImageView *imageView = [self mmh_findHairlineImageView:subview];
        if(imageView)
        {
            return imageView;
        }
    }
    return nil;
}

@end

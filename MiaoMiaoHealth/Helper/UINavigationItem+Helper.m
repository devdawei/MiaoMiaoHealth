//
//  UINavigationItem+Helper.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/25.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "UINavigationItem+Helper.h"
#import <objc/runtime.h>

@implementation UINavigationItem (Helper)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method originalBackBarButtonItemImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method swizzBackBarButtonItemImp = class_getInstanceMethod(self, @selector(mmh_backBarButtonItem));
        method_exchangeImplementations(originalBackBarButtonItemImp, swizzBackBarButtonItemImp);
    });
}

static char kBackBarButtonItem;

- (UIBarButtonItem *)mmh_backBarButtonItem
{
    UIBarButtonItem *item = [self mmh_backBarButtonItem];
    
    if (item) return item;
    
    item = objc_getAssociatedObject(self, &kBackBarButtonItem);
    if (!item)
    {
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor redColor];
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
        objc_setAssociatedObject(self, &kBackBarButtonItem, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

@end

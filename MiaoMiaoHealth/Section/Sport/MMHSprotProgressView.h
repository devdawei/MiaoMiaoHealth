//
//  MMHSprotProgressView.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/25.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMHSprotProgressView : UIView

@property (nonatomic, strong) CAShapeLayer *progressShapeLayer;
@property (nonatomic, assign) CGFloat endAngle;

@property (nonatomic, assign) CGFloat progress;

/** 圆环的线宽度 */
@property (nonatomic, assign) CGFloat lineWidth;

@end

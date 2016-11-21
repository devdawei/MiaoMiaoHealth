//
//  MMHSprotProgressView.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/25.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHSprotProgressView.h"

@implementation MMHSprotProgressView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 环的颜色
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
        _progressShapeLayer = [CAShapeLayer layer];
        _progressShapeLayer.fillColor = [[UIColor clearColor] CGColor];
        _progressShapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
        _progressShapeLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        _progressShapeLayer.lineJoin = kCALineJoinRound;
        _progressShapeLayer.lineCap = kCALineCapRound;
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(-90 * M_PI/180.0);
        [self setTransform:transform];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    _progressShapeLayer.lineWidth = lineWidth;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    _endAngle = progress * 2;
    DLog(@"%f", _endAngle);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // 圆环的外边距
    CGFloat margin = 0;
    // 半径
    CGFloat radius = (rect.size.width - _lineWidth) / 2.f - margin;
    // 设置中心点
    CGFloat viewRadius = rect.size.width / 2.f;
    CGPoint center = CGPointMake(viewRadius, viewRadius);
    // 绘制路径
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:radius
                                                     startAngle:M_PI * 0
                                                       endAngle:M_PI * _endAngle
                                                      clockwise:YES];
    // 线条拐角
    aPath.lineCapStyle = kCGLineCapRound;
    // 终点处理
    aPath.lineJoinStyle = kCGLineCapRound;
    _progressShapeLayer.path = aPath.CGPath;
    [self.layer setMask:_progressShapeLayer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

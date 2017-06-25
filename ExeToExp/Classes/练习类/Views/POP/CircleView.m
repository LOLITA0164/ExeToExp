//
//  CircleView.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "CircleView.h"
#import <pop/POP.h>

@interface CircleView()
@property(nonatomic)CAShapeLayer *circleLayer;
@end

@implementation CircleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(frame.size.width==frame.size.height, @"CircleView必须宽高相等！");
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

-(CAShapeLayer *)circleLayer{
    if (_circleLayer==nil) {
        CGFloat lineWidth = 4.f;
        CGFloat radius = CGRectGetWidth(self.bounds)/2.0 - lineWidth/2.0;
        CGRect rect = CGRectMake(lineWidth/2.0, lineWidth/2.0, radius*2, radius*2);
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
        _circleLayer.strokeColor = self.tintColor.CGColor;
        _circleLayer.fillColor = nil;
        _circleLayer.lineWidth = lineWidth;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.lineJoin = kCALineJoinRound;
    }
    return _circleLayer;
}


-(void)setStrokeColor:(UIColor *)strokeColor{
    self.circleLayer.strokeColor = strokeColor.CGColor;
    _strokeColor = strokeColor;
}

-(void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated{
    if (animated) {
        //设置动画
        POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
        strokeAnimation.toValue = @(strokeEnd);
        strokeAnimation.springBounciness = 10.f;
        strokeAnimation.springSpeed = 20;
        strokeAnimation.removedOnCompletion = NO;
        [self.circleLayer pop_addAnimation:strokeAnimation forKey:@"strokeAnimation"];
    }
    else{
        self.circleLayer.strokeEnd = strokeEnd;
    }
}



@end

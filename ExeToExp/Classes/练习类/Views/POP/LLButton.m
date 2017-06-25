//
//  LLButton.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "LLButton.h"
#import <pop/POP.h>

@implementation LLButton


+ (instancetype)button
{
    return [self buttonWithType:UIButtonTypeCustom];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(scaleToSmall)
      forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(scaleAnimation)
      forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(scaleToDefault)
      forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}

-(void)scaleToSmall{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue            = [NSValue valueWithCGSize:CGSizeMake(0.9, 0.9)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity             = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue              = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness    = 20.f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}






























@end

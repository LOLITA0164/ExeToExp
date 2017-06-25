//
//  CircleView.h
//  ExeToExp
//
//  Created by LOLITA on 17/4/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property(nonatomic)UIColor *strokeColor;

-(void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated;

@end

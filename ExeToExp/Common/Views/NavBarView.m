//
//  NavBarView.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/25.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "NavBarView.h"
@implementation NavBarView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, NavBar_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleView];
        
    }
    return self;
}


/**
 重写setter方法设置titleLabel

 @param title 标题
 */
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

/**
 标题Label

 @return nil
 */
-(UILabel *)titleLabel{
    if (_titleLabel==nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.titleView.bounds];
        _titleLabel.font = [UIFont boldSystemFontOfSize:sizeBig];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}


/**
 标题视图

 @return nil
 */
-(UIView *)titleView{
    if (_titleView==nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth-NavBar_HEIGHT*2.0, 44)];
        _titleView.center = CGPointMake(self.center.x, _titleView.center.y);
        [_titleView addSubview:self.titleLabel];
    }
    return _titleView;
}


/**
 重写setter方法

 @param letfView nil
 */
-(void)setLetfView:(UIView *)letfView{
    [self addSubview:letfView];
}


@end

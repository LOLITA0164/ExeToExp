//
//  NavBarView.h
//  ExeToExp
//
//  Created by LOLITA on 17/3/25.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavBarView : UIView

/**
 标题
 */
@property(strong,nonatomic)NSString *title;


/**
 标题View
 */
@property(strong,nonatomic)UIView *titleView;

/**
 左边视图
 */
@property(strong,nonatomic)UIView *letfView;

/**
 标题Label
 */
@property(strong,nonatomic)UILabel *titleLabel;

@end

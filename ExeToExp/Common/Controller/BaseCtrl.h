//
//  BaseCtrl.h
//  ExeToExp
//
//  Created by LOLITA on 17/3/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBarView.h"
#import "HUDView.h"

@interface BaseCtrl : UIViewController

/**
 列表视图
 */
@property(strong,nonatomic)UITableView *table;

/**
 数据
 */
@property(strong,nonatomic)NSArray *data;

/**
 navBar
 */
@property(strong,nonatomic)NavBarView *navBar;

/**
 是否需要返回按钮
 */
@property(assign,nonatomic)BOOL needGoBackBtn;

/**
 是否需要详情按钮
 */
@property(assign,nonatomic)BOOL needDetailBtn;

/**
 模块code
 */
@property(copy,nonatomic)NSString *moduleCode;

/**
 提示视图
 */
@property(strong,nonatomic)HUDView *hudView;

@end

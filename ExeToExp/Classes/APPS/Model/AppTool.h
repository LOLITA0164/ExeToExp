//
//  AppTool.h
//  ExeToExp
//
//  Created by LOLITA on 17/3/25.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Module : NSObject

/**
 模块名称
 */
@property(copy,nonatomic)NSString *MODULENAME;

/**
 模块code
 */
@property(copy,nonatomic)NSString *MODULECODE;

/**
 模块是否显示
 */
@property(copy,nonatomic)NSString *MODULESHOW;

/**
 模块子节点数组
 */
@property(strong,nonatomic)NSArray *MODULENODES;

/**
 扩展字典
 */
@property(strong,nonatomic)NSDictionary *MODULEEXT;

@end

@interface RESULT : NSObject

/**
 工具类
 */
@property(strong,nonatomic)Module *TOOLS;

/**
 技巧类
 */
@property(strong,nonatomic)Module *SKILLS;

/**
 练习
 */
@property(strong,nonatomic)Module *EXERCISE;

/**
 心得体会
 */
@property(strong,nonatomic)Module *EXPERIENCE;

@end



@interface AppTool : NSObject

/**
 状态，success failure
 */
@property(copy,nonatomic)NSString *STATU;

/**
 结果信息
 */
@property(strong,nonatomic)RESULT *RESULT;



+(instancetype)sharedInstance;



@end

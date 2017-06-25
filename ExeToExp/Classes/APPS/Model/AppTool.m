//
//  AppTool.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/25.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "AppTool.h"

@implementation Module
@end

@implementation RESULT
@end


@implementation AppTool

+(instancetype)sharedInstance{
    static AppTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppTool alloc] initWithAppInfo];
    });
    return instance;
}

-(instancetype)initWithAppInfo{
    [Module mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"MODULENODES":@"Module"};
    }];
    AppTool *tmpTool = [AppTool mj_objectWithFile:[[NSBundle mainBundle] pathForResource:@"App" ofType:@"plist"]];
    return [tmpTool.STATU isEqualToString:@"success"]?tmpTool:nil;
}


@end

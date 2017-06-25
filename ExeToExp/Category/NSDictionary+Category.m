//
//  NSDictionary+Category.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (Category)

-(instancetype)objectForKeyNotNull:(id)key{
    id object = [self objectForKey:key];
    
    if (object == [NSNull null]) {
        return nil;
    }
    return object;
}


@end

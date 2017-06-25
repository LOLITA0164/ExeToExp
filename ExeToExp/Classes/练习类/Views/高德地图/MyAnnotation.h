//
//  MyAnnotation.h
//  ExeToExp
//
//  Created by LOLITA on 17/3/30.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "PointInfo.h"


/**
 存储注标注释信息
 */
@interface MyAnnotation : NSObject<MAAnnotation>

@property(nonatomic,strong)PointInfo *pi;
@property (nonatomic,/* readonly*/ assign) CLLocationCoordinate2D coordinate;

-(id)initWithCoord:(CLLocationCoordinate2D)coord withInfo:(PointInfo *)pi;

@end

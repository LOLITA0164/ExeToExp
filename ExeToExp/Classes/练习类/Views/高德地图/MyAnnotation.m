//
//  MyAnnotation.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/30.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation


-(id)initWithCoord:(CLLocationCoordinate2D)coord withInfo:(PointInfo *)pi{
    
    if(self = [super init] )
    {
        self.coordinate = coord;
        self.pi = pi;
    }
    return self;
    
}


@end

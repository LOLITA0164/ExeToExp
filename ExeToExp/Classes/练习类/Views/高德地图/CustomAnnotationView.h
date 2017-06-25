//
//  CustomAnnotationView.h
//  Poverty-relief
//
//  Created by LOLITA on 17/3/16.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"
#import "MyAnnotation.h"

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) CustomCalloutView *calloutView;

@end





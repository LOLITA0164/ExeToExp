//
//  CustomAnnotationView.m
//  Poverty-relief
//
//  Created by LOLITA on 17/3/16.
//  Copyright © 2017年 strong. All rights reserved.
//

#import "CustomAnnotationView.h"
#define kCalloutWidth       150.0
#define kCalloutHeight      120.0

@implementation CustomAnnotationView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        
        PointInfo *tmpPi = ((MyAnnotation*)self.annotation).pi;
        
        if (self.calloutView == nil)
        {
            
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }

        self.calloutView.title = tmpPi.title;
        self.calloutView.imageName = tmpPi.imageName;
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}












@end



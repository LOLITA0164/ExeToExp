//
//  MAMapView+AdjustVisulaRegin.m
//  SignInTool
//
//  Created by LOLITA on 17/3/9.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "MAMapView+AdjustVisulaRegin.h"
#import <MAMapKit/MAMapKit.h>

@implementation MAMapView (AdjustVisulaRegin)

-(void)adjustMapViewVisualRegin:(NSArray *)coordinates{
    
    if(coordinates==nil || [coordinates count] == 0)
        return;
    
    MACoordinateSpan _span;

    CLLocationCoordinate2D _center;
    
    double maxLat = -91;
    double minLat =  91;
    double maxLon = -181;
    double minLon =  181;
    
    for(int idx=0;idx<[coordinates count] ;idx++)
    {
        NSArray* array = [[coordinates objectAtIndex:idx] componentsSeparatedByString:@"Ω"];
        
        if([array count] < 2)
            continue;
        
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = [[array objectAtIndex:0] floatValue];
        coordinate.latitude = [[array objectAtIndex:1] floatValue];
        
        if(coordinate.latitude > maxLat)
            maxLat = coordinate.latitude;
        if(coordinate.latitude < minLat)
            minLat = coordinate.latitude;
        if(coordinate.longitude > maxLon)
            maxLon = coordinate.longitude;
        if(coordinate.longitude < minLon)
            minLon = coordinate.longitude;
    }
    
    _span.latitudeDelta = (maxLat + 45) - (minLat + 45);
    _span.longitudeDelta = (maxLon + 90) - (minLon + 90);
    
    // the center point is the average of the max and mins
    _center.latitude = minLat + _span.latitudeDelta / 2;
    _center.longitude = minLon + _span.longitudeDelta / 2;
    
    if (!(_center.latitude > 0.0f && _center.latitude < 90.0f && _center.longitude > 0.0f && _center.longitude < 180.0f))
    {
        _center.latitude = 90.0f;
        _center.longitude = 0.0f;
    }
    
    MACoordinateRegion region;
    region.center = _center;
    region.span = _span;
    
//    DLog(@"adjustMapViewVisualRegin %@, %@", region.center, region.span);
    
    if([coordinates count] == 1)
    {
        region.span.latitudeDelta = 0.003;
        region.span.longitudeDelta = 0.003;
    }
    
    [self setRegion:region animated:YES];
    
}

@end

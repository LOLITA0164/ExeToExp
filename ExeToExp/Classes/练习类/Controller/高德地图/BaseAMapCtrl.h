//
//  BaseAMapCtrl.h
//  ExeToExp
//
//  Created by LOLITA on 17/3/28.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "BaseCtrl.h"
#import "MAMapView+AdjustVisulaRegin.h"//地图的调整
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface BaseAMapCtrl : BaseCtrl<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>

/**
 高德地图
 */
@property (strong, nonatomic)MAMapView *maMapView;

/**
 定位
 */
@property(strong,nonatomic)AMapLocationManager *locationManager;

/**
 周边检索
 */
@property(strong,nonatomic)AMapSearchAPI *search;

/**
 位置信息
 */
@property(strong,nonatomic)UILabel *locationLabel;

/**
 当前位置坐标
 */
@property(assign,nonatomic)CLLocationCoordinate2D coodinate;

/**
 CLLocationCoordinate2D
 */
@property(assign,nonatomic)CLLocationCoordinate2D *coordinateArray;

/**
 我的位置
 */
@property(copy,nonatomic)void(^MyLocationCoordinate)(CLLocationCoordinate2D locationCoord);

/**
 添加点
 
 @param coordinate nil
 */
-(void)addPointAnnotationWithLocation:(CLLocationCoordinate2D)coordinate animated:(BOOL)animate;

/**
 计算两点之间距离

 @param start <#start description#>
 @param end <#end description#>
 @return <#return value description#>
 */
- (double)calculateDistanceWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end;
@end

//
//  DrawUpCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/30.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "DrawUpCtrl.h"

@interface DrawUpCtrl ()

@end

@implementation DrawUpCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

/**
 初始化UI
 */
-(void)initUI{
    
    //添加地图
    self.maMapView.showsUserLocation = NO;
    self.maMapView.userTrackingMode = MAUserTrackingModeNone;
    [self.view addSubview:self.maMapView];
    
    if ([self.moduleCode isEqualToString:@"drawUpPoint"]) {
        //绘制点标记
        [self drawUpPoint];
        self.needDetailBtn = YES;
    }
    else if ([self.moduleCode isEqualToString:@"drawUpPolyline"]){
        //绘制折线
        [self drawUpPolyline];
    }
    else if ([self.moduleCode isEqualToString:@"drawUpCircle"]){
        //绘制圆形
        [self drawUpCircle];
    }
    
}




/**
 绘制点标记
 */
-(void)drawUpPoint{
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    [self.maMapView addAnnotation:pointAnnotation];
    
    PointInfo *pi = [[PointInfo alloc] init];
    pi.title = @"自定义";
    pi.imageName = @"icon";
    MyAnnotation *myAnnotation = [[MyAnnotation alloc] initWithCoord:CLLocationCoordinate2DMake(39.999631, 116.381018) withInfo:pi];
    [self.maMapView addAnnotation:myAnnotation];
    
    
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]&&[self.moduleCode isEqualToString:@"drawUpPoint"])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        UIImage *img = [UIImage imageNamed:@"loaction"];
        annotationView.image = img;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -img.size.height/2.0);
        return annotationView;
    }
    if([annotation isKindOfClass:[MyAnnotation class]]&&[self.moduleCode isEqualToString:@"drawUpPoint"]){
        static NSString* identifierstring = @"MyAnnotationView";
        CustomAnnotationView* annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifierstring];
        if(!annotationView)
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifierstring];
        else
            annotationView.annotation = annotation;
        
        annotationView.image=[UIImage imageNamed:@"loaction"];
        annotationView.canShowCallout = NO;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, (annotationView.image.size.height/2.0)*-1);
        return annotationView;
        
    }
    return nil;
}










/**
 绘制折线
 */
-(void)drawUpPolyline{
    CLLocationCoordinate2D PolylineCoords[4];
    
    PolylineCoords[0].latitude = 39.832136;
    PolylineCoords[0].longitude = 116.34095;
    
    PolylineCoords[1].latitude = 39.832136;
    PolylineCoords[1].longitude = 116.42095;
    
    PolylineCoords[2].latitude = 39.902136;
    PolylineCoords[2].longitude = 116.42095;
    
    PolylineCoords[3].latitude = 39.902136;
    PolylineCoords[3].longitude = 116.44095;
    
    //构建折线对象
    MAPolyline *Polyline = [MAPolyline polylineWithCoordinates:PolylineCoords count:4];
    //添加在地图上
    [self.maMapView addOverlay:Polyline];
}

/**
 绘制圆形
 */
-(void)drawUpCircle{
    //构造圆
    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.952136, 116.50095) radius:4000];//单位米
    //添加到地图上
    [self.maMapView addOverlay:circle];
}





-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
         MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline*)overlay];
        polylineRenderer.lineWidth = 4.0f;
        polylineRenderer.strokeColor = defaultSelectedColor;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType = kMALineCapRound;
        return polylineRenderer;
    }
    else if ([overlay isKindOfClass:[MACircle class]]){
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:(MACircle*)overlay];
        circleRenderer.lineWidth = 2.f;
        circleRenderer.strokeColor = defaultUnSelectedColor;
        circleRenderer.fillColor = defaultSelectedColor;
        return circleRenderer;
    }
    return nil;
}









 




/**
 详细按钮
 */
-(void)detailBtn{
    
    WebCtrl *ctrl = [[WebCtrl alloc] init];
    
    if ([self.moduleCode isEqualToString:@"drawUpPoint"]) {
        ctrl.dataUrlString = kDrawUpPointURL;
    }
//    else if ([self.moduleCode isEqualToString:@"updatingLocation"]){
//        ctrl.dataUrlString = kSeriallocationDetailURL;
//    }
//    else if ([self.moduleCode isEqualToString:@"backgroundUpdatingLocation"]){
//        ctrl.dataUrlString = kBackgroundlocationDetailURL;
//    }
    [self.navigationController pushViewController:ctrl animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

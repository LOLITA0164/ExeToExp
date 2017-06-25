//
//  BaseAMapCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/28.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "BaseAMapCtrl.h"

@interface BaseAMapCtrl ()

@end

@implementation BaseAMapCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.backgroundColor = [defaultSelectedColor colorWithAlphaComponent:0.8];
    self.navBar.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    
}



/**
 地图懒加载

 @return nil
 */
-(MAMapView *)maMapView{
    if (!_maMapView) {
        _maMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NavBar_HEIGHT, kScreenWidth, kScreenHeight-NavBar_HEIGHT)];
        _maMapView.rotateEnabled = NO;//地图旋转
        //如果您需要进入地图就显示定位小蓝点，则需要下面两行代码,不需要在使用定位即可获取到用户定位坐标
        //-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
        _maMapView.showsUserLocation = YES;
        [_maMapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
        _maMapView.mapType = MAMapTypeStandard;
        _maMapView.backgroundColor = [UIColor clearColor];
        _maMapView.delegate = self;
        _maMapView.showsCompass = NO;//是否显示罗盘
        _maMapView.showsScale = NO;//是否显示比例尺
        _maMapView.showsIndoorMap = YES;    //YES：显示室内地图；NO：不显示；
    }
    return _maMapView;
}


///当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标，示例代码如下：
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation){
        //取出当前位置的坐标
        DLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.coodinate = userLocation.coordinate;
        if (self.MyLocationCoordinate) {//回到我的位置
            self.MyLocationCoordinate(userLocation.coordinate);
        }
    }
}



/**
 地图定位

 @return nil
 */
-(AMapLocationManager *)locationManager{
    if (_locationManager==nil) {
        _locationManager = [[AMapLocationManager alloc] init];
    }
    return _locationManager;
}


/**
 搜索API
 
 @return nil
 */
-(AMapSearchAPI *)search{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}


/**
 定位信息Label

 @return nil
 */
-(UILabel *)locationLabel{
    if (_locationLabel==nil) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-10*2, 50)];
        _locationLabel.center = CGPointMake(self.view.centerX, kScreenHeight-25-10);
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.textColor = [UIColor whiteColor];
        _locationLabel.font = [UIFont systemFontOfSize:sizeSmall];
        _locationLabel.backgroundColor = defaultSelectedColor;
        _locationLabel.numberOfLines = 0;
    }
    return _locationLabel;
}




#pragma mark - 距离测算
- (double)calculateDistanceWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end {
    
    double meter = 0;
    
    double startLongitude = start.longitude;
    double startLatitude = start.latitude;
    double endLongitude = end.longitude;
    double endLatitude = end.latitude;
    
    double radLatitude1 = startLatitude * M_PI / 180.0;
    double radLatitude2 = endLatitude * M_PI / 180.0;
    double a = fabs(radLatitude1 - radLatitude2);
    double b = fabs(startLongitude * M_PI / 180.0 - endLongitude * M_PI / 180.0);
    
    double s = 22 * asin(sqrt(pow(sin(a/2),2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(b/2),2)));
    s = s * 6378137;
    
    meter = round(s * 10000) / 10000;
    return meter;
}


#pragma mark - 添加点到地图上
-(void)addPointAnnotationWithLocation:(CLLocationCoordinate2D)coordinate animated:(BOOL)animate{
    //我的位置注释
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = coordinate;
    //移除掉所有的点
    [self.maMapView removeAnnotations:self.maMapView.annotations];
    //添加到地图上
    [self.maMapView addAnnotation:pointAnnotation];
    //设置显示的区域
    MACoordinateSpan span = MACoordinateSpanMake(0.0025, 0.0025);
    MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
    [self.maMapView setRegion:region animated:animate];
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        UIImage *img = [UIImage imageNamed:@"loaction"];
        annotationView.image = img;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -img.size.height/2.0);
        return annotationView;
    }
    return nil;
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
        circleRenderer.lineWidth = 4.f;
        circleRenderer.strokeColor = [UIColor grayColor];
        circleRenderer.fillColor = [UIColor greenColor];
        return circleRenderer;
    }
    return nil;
    return nil;
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

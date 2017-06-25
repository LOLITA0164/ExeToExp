//
//  LocationCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/28.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "LocationCtrl.h"

@interface LocationCtrl ()

/**
 地理围栏
 */
@property(strong,nonatomic)AMapGeoFenceManager *geoFenceManager;


@end

@implementation LocationCtrl

-(void)viewWillDisappear:(BOOL)animated{
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    [self.geoFenceManager removeAllGeoFenceRegions];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

/**
 初始化UI
 */
-(void)initUI{
    
    //添加地图
    [self.view addSubview:self.maMapView];
    
    [self.view addSubview:self.locationLabel];
    
    if ([self.moduleCode isEqualToString:@"onceLocation"]) {
        //一次定位
        [self onceLocation];
        self.needDetailBtn = YES;
    }
    else if ([self.moduleCode isEqualToString:@"updatingLocation"]){
        //持续定位
        [self updatingLocation];
        self.needDetailBtn = YES;
    }
    //iOS定位SDK提供后台持续定位的能力，可持久记录位置信息，适用于记轨迹录。
    //将info.plist的字段改成NSLocationAlwaysUsageDescription字段。
    //TARGETS->Capabilities->Background Modes->Location updates
    else if ([self.moduleCode isEqualToString:@"backgroundUpdatingLocation"]){
        //后台持续定位
        [self backgroundUpdatingLocation];
        self.needDetailBtn = YES;
    }
    //地理围栏
    else if ([self.moduleCode isEqualToString:@"geoFence_Location"]){
        [self geoFence_Location];
        self.needDetailBtn = NO;
    }
    //位置检测
    else if ([self.moduleCode isEqualToString:@"checkCurrentLocation"]){
        [self checkCurrentLocation];
        self.needDetailBtn = NO;
    }
}




/**
 一次定位
 */
-(void)onceLocation{
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;//百米
    self.locationManager.locationTimeout = 2.0;//超时时间
    self.locationManager.reGeocodeTimeout = 2.0;//逆定理超时时间
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed)
                return ;
        }
        DLog(@"location:%@", location);
        [self setMapRegionWithCoordinate:location.coordinate];//设置区域
        if (regeocode){
            DLog(@"reGeocode:%@", regeocode);
            self.locationLabel.text = [NSString stringWithFormat:@"country:%@,province:%@,city:%@,district:%@,street:%@,number:%@,citycode:%@,adcode:%@,POIName:%@,AOIName:%@",regeocode.country,regeocode.province,regeocode.city,regeocode.district,regeocode.street,regeocode.number,regeocode.citycode,regeocode.adcode,regeocode.POIName,regeocode.AOIName];
        }
            
    }];
    
}





/**
 持续定位
 */
-(void)updatingLocation{
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10;
    //持续定位是否返回逆地理信息，默认NO。
    self.locationManager.locatingWithReGeocode = YES;
    [self.locationManager startUpdatingLocation];//开启持续定位
}




/**
 后台持续定位
 */
-(void)backgroundUpdatingLocation{
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10;
    //持续定位是否返回逆地理信息，默认NO。
    self.locationManager.locatingWithReGeocode = YES;
    //iOS 9（不包含iOS 9） 之前设置允许后台定位参数，保持不会被系统挂起
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //iOS 9（包含iOS 9）之后新特性：将允许出现这种场景，同一app中多个locationmanager：一些只能在前台定位，另一些可在后台定位，并可随时禁止其后台定位。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    }
    [self.locationManager startUpdatingLocation];//开启持续定位
}




#pragma mark - 持续定位的代理回调
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    [self setMapRegionWithCoordinate:location.coordinate];//设置区域
    if (reGeocode) {
        self.locationLabel.text = [NSString stringWithFormat:@"country:%@,province:%@,city:%@,district:%@,street:%@,number:%@,citycode:%@,adcode:%@,POIName:%@,AOIName:%@",reGeocode.country,reGeocode.province,reGeocode.city,reGeocode.district,reGeocode.street,reGeocode.number,reGeocode.citycode,reGeocode.adcode,reGeocode.POIName,reGeocode.AOIName];
    }
}
#pragma mark - 定位失败的回调
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    DLog(@"定位失败：%@",error.localizedDescription);
    [UIView addMJNotifierWithText:@"定位失败,请重试" dismissAutomatically:YES];
}



#pragma mark - 设置地图显示精度   私有方法
-(void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate{
    //设置显示的区域
    MACoordinateSpan span = MACoordinateSpanMake(0.05, 0.05);
    MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
    [self.maMapView setRegion:region animated:YES];
}










/**
 地理围栏，地理围栏是一个（或多个）圆形的地理边界作为虚拟围栏，当设备进入、离开该区域时，可以接收到消息通知。
 */
-(void)geoFence_Location{
    //26.04209663
    //119.21534125
    [self.geoFenceManager addAroundPOIRegionForMonitoringWithLocationPoint:CLLocationCoordinate2DMake(26.04209663, 119.21534125) aroundRadius:200 keyword:@"大厦" POIType:@"" size:25 customID:@"circleRegion200"];
}
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        DLog(@"创建失败 %@",error);
        self.locationLabel.text = @"创建失败";
    } else {
        DLog(@"创建成功");
        self.locationLabel.text = @"创建成功";
    }
}
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        DLog(@"status changed error %@",error);
    }else{
        DLog(@"status changed success %@",[region description]);
    }
}
//接收地理围栏回调
- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region{
    DLog(@"进入围栏:%@", region);
    self.locationLabel.text = [NSString stringWithFormat:@"%@-%@%@",self.locationLabel.text,@"进入围栏",region];
}
- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region{
    DLog(@"走出围栏:%@", region);
    self.locationLabel.text = [NSString stringWithFormat:@"%@-%@%@",self.locationLabel.text,@"走出围栏",region];
}








/**
 位置检测
 */
-(void)checkCurrentLocation{
    
    WS(ws);
    self.MyLocationCoordinate = ^(CLLocationCoordinate2D locationCoord){
        //返回是否在大陆或以外地区，返回YES为大陆地区，NO为非大陆。
        BOOL flag= AMapLocationDataAvailableForCoordinate(locationCoord);
        ws.locationLabel.text = [NSString stringWithFormat:@"%@",flag?@"在大陆地区":@"非大陆地区"];
    };
    
    
}






/**
 详细按钮
 */
-(void)detailBtn{
    
    WebCtrl *ctrl = [[WebCtrl alloc] init];
    
    if ([self.moduleCode isEqualToString:@"onceLocation"]) {
        ctrl.dataUrlString = kOnceLocationDetailURL;
    }
    else if ([self.moduleCode isEqualToString:@"updatingLocation"]){
        ctrl.dataUrlString = kSeriallocationDetailURL;
    }
    else if ([self.moduleCode isEqualToString:@"backgroundUpdatingLocation"]){
        ctrl.dataUrlString = kBackgroundlocationDetailURL;
    }
    [self.navigationController pushViewController:ctrl animated:YES];
}




/**
 地理围栏

 @return nil
 */
-(AMapGeoFenceManager *)geoFenceManager{
    if (_geoFenceManager==nil) {
        _geoFenceManager = [[AMapGeoFenceManager alloc] init];
        _geoFenceManager.delegate = self;
        _geoFenceManager.activeAction = AMapGeoFenceActiveActionInside|AMapGeoFenceActiveActionOutside|AMapGeoFenceActiveActionStayed;
        _geoFenceManager.allowsBackgroundLocationUpdates = YES;//允许后台定位
    }
    return _geoFenceManager;
}



-(void)dealloc{
    DLog(@"LocationCtrl dealloc!");
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

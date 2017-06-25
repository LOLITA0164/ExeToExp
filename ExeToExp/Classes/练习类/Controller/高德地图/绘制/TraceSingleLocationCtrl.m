//
//  TraceSingleLocationCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/31.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "TraceSingleLocationCtrl.h"

@interface TraceSingleLocationCtrl ()

/**
 保存轨迹坐标,CLLocation
 */
@property(strong,nonatomic)NSMutableArray *traceArray;

/**
 CLLocationCoordinate2D
 */
@property(assign,nonatomic)CLLocationCoordinate2D *coordinateArray;

/**
 定时器
 */
@property(strong,nonatomic)NSTimer *timer;

@end

@implementation TraceSingleLocationCtrl


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}


/**
 获取数据
 */
-(void)initData{
    NSArray *tmp = UserDefaultGetInfoForKey(kTrace3);
    if (tmp&&tmp.count) {
        self.traceArray = [tmp mutableCopy];
    }
    
    NSInteger pointCount = [self.traceArray count];
    self.coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < pointCount; ++i) {
        NSArray *locationArray = [self.traceArray objectAtIndex:i];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[locationArray firstObject] floatValue], [[locationArray lastObject] floatValue]);
        self.coordinateArray[i] = location;
    }
}


/**
 初始化UI
 */
-(void)initUI{
    
    self.maMapView.showsCompass = YES;//是否显示罗盘
    self.maMapView.showsScale = YES;//是否显示比例尺
    self.maMapView.pausesLocationUpdatesAutomatically = NO;
    self.maMapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    self.maMapView.showsUserLocation = NO;
    [self.maMapView setUserTrackingMode:MAUserTrackingModeNone animated:YES]; //地图跟着位置移动
    [self.view addSubview:self.maMapView];
    
    self.needDetailBtn = YES;
    
    if (self.traceArray.count) {
        //构建折线对象
        MAPolyline *Polyline = [MAPolyline polylineWithCoordinates:self.coordinateArray count:self.traceArray.count];
        //添加在地图上
        [self.maMapView addOverlay:Polyline];
    }
    
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.locationTimeout = 5.0;//超时时间
    
    [self onceLocation];
    //开启计时器
    [self.timer setFireDate:[NSDate date]];
    
}


/**
 一次定位
 */
-(void)onceLocation{
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            [UIView addMJNotifierWithText:@"定位失败,请重试" dismissAutomatically:YES];
            if (error.code == AMapLocationErrorLocateFailed)
                return ;
        }
       
        [self addPointAnnotationWithLocation:location.coordinate animated:YES];
        NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        if (self.traceArray.count!=0) {
            //取出最后一个位置信息
            NSArray *locationArray = self.traceArray.lastObject;
            CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([[locationArray firstObject] floatValue], [[locationArray lastObject] floatValue]);
            //当前位置信息
            CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
            //移动距离
            double meters = [self calculateDistanceWithStart:startCoordinate end:endCoordinate];
            if (meters>=20) {//超过20米
                [self.traceArray addObject:@[latitude,longitude]];
                UserDefaultSaveInfoForKey(self.traceArray, kTrace3);
                //开始绘制轨迹
                CLLocationCoordinate2D pointsToUse[2];
                pointsToUse[0] = startCoordinate;
                pointsToUse[1] = endCoordinate;
                //构建折线对象
                MAPolyline *Polyline = [MAPolyline polylineWithCoordinates:pointsToUse count:2];
                //添加在地图上
                [self.maMapView addOverlay:Polyline];
            }
        }
        else{
            [self.traceArray addObject:@[latitude,longitude]];
            UserDefaultSaveInfoForKey(self.traceArray, kTrace3);
        }
        
    }];
    
}



/**
 清除当前轨迹记录
 */
-(void)detailBtn{
    UserDefaultRemoveObjectForKey(kTrace3);
    [self.maMapView removeOverlays:self.maMapView.overlays];
    self.locationManager.delegate = nil;
    [self.timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}



/**
 初始化轨迹数组
 
 @return 轨迹数组
 */
-(NSMutableArray *)traceArray{
    if (_traceArray==nil) {
        _traceArray = [NSMutableArray array];
    }
    return _traceArray;
}


-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onceLocation) userInfo:nil repeats:YES];
    }
    return _timer;
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

//
//  TraceSerialLocationCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/31.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "TraceSerialLocationCtrl.h"

@interface TraceSerialLocationCtrl ()

/**
 保存轨迹坐标,CLLocation
 */
@property(strong,nonatomic)NSMutableArray *traceArray;

/**
 CLLocationCoordinate2D
 */
@property(assign,nonatomic)CLLocationCoordinate2D *coordinateArray;

/**
 保存每一次的定位坐标信息
 */
@property(strong,nonatomic)NSMutableArray *tmpTraceArray;

/**
 定时器
 */
@property(strong,nonatomic)NSTimer *timer;

@end

@implementation TraceSerialLocationCtrl


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}


/**
 获取数据
 */
-(void)initData{
    NSArray *tmp = UserDefaultGetInfoForKey(kTrace2);
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
    
    
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 15;//15米定位一次
    [self.locationManager startUpdatingLocation];//开启持续定位
    
    //开启计时器
    [self.timer setFireDate:[NSDate date]];
    
}


#pragma mark - 持续定位的代理回调
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    //添加到暂存数组中去
    NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    [self.tmpTraceArray addObject:@[latitude,longitude]];
    [self addPointAnnotationWithLocation:location.coordinate animated:YES];//设置区域
    
}
#pragma mark - 定位失败的回调
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    DLog(@"定位失败：%@",error.localizedDescription);
    [UIView addMJNotifierWithText:@"定位失败,请重试" dismissAutomatically:YES];
}



/**
 清除当前轨迹记录
 */
-(void)detailBtn{
    UserDefaultRemoveObjectForKey(kTrace2);
    [self.maMapView removeOverlays:self.maMapView.overlays];
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];//这里应该在手动结束运动的时候再取消
    [self.timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(getCurrentLocation) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(void)getCurrentLocation{
    NSArray *tmpArray = self.tmpTraceArray.lastObject;
    if (tmpArray.count==0) {
        return;
    }
    //当前位置信息
    CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake([[tmpArray firstObject] floatValue], [[tmpArray lastObject] floatValue]);
    if (self.traceArray.count!=0) {
        //取出最后一个位置信息
        NSArray *locationArray = self.traceArray.lastObject;
        CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([[locationArray firstObject] floatValue], [[locationArray lastObject] floatValue]);
        //移动距离
        double meters = [self calculateDistanceWithStart:startCoordinate end:endCoordinate];
        if (meters>=20) {//超过20米
            //缩放地图
            [self addPointAnnotationWithLocation:endCoordinate animated:YES];//设置区域
            [self.traceArray addObject:tmpArray];//将有效点添加到数组中并保存起来
            UserDefaultSaveInfoForKey(self.traceArray, kTrace2);
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
        [self.traceArray addObject:tmpArray];
        UserDefaultSaveInfoForKey(self.traceArray, kTrace2);
    }
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

/**
 暂存定位点数组
 
 @return nil
 */
-(NSMutableArray *)tmpTraceArray{
    if (_tmpTraceArray==nil) {
        _tmpTraceArray = [NSMutableArray array];
    }
    return _tmpTraceArray;
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

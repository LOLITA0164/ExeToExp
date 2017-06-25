//
//  TraceCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/31.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "TraceUserLocationCtrl.h"

@interface TraceUserLocationCtrl ()

/**
 保存轨迹坐标,有效绘制的点
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



@implementation TraceUserLocationCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}


/**
 获取数据
 */
-(void)initData{
    NSArray *tmp = UserDefaultGetInfoForKey(kTrace1);
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
    [self.view addSubview:self.maMapView];
    
    
    self.needDetailBtn = YES;
    
    
    if (self.traceArray.count) {
        //构建折线对象
        MAPolyline *Polyline = [MAPolyline polylineWithCoordinates:self.coordinateArray count:self.traceArray.count];
        //添加在地图上
        [self.maMapView addOverlay:Polyline];
        
        //开启计时器
        [self.timer setFireDate:[NSDate date]];
    }

}


///当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标，示例代码如下：
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation){
        //取出当前位置的坐标
        DLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [self setMapRegionWithCoordinate:userLocation.coordinate];//设置区域
        //添加到暂存数组中去
        NSString *latitude = [NSString stringWithFormat:@"%f",userLocation.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
        [self.tmpTraceArray addObject:@[latitude,longitude]];
    }
}



/**
 清除当前轨迹记录
 */
-(void)detailBtn{
    UserDefaultRemoveObjectForKey(kTrace1);
    [self.maMapView removeOverlays:self.maMapView.overlays];
    [self.timer invalidate];
}


-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(getCurrentLocation) userInfo:nil repeats:YES];
    }
    return _timer;
}

/**
 获取最新的点
 */
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
            [self setMapRegionWithCoordinate:endCoordinate];//设置区域
            [self.traceArray addObject:tmpArray];//将有效点添加到数组中并保存起来
            UserDefaultSaveInfoForKey(self.traceArray, kTrace1);
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
        UserDefaultSaveInfoForKey(self.traceArray, kTrace1);
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


#pragma mark - 设置地图显示精度   私有方法
-(void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate{
    //设置显示的区域
    MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
    MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
    [self.maMapView setRegion:region animated:YES];
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

//
//  AdminDivisionsCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/6.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "AdminDivisionsCtrl.h"

@interface AdminDivisionsCtrl ()

/**
 CLLocationCoordinate2D
 */
@property(assign,nonatomic)CLLocationCoordinate2D *coordinateArray;

@end

@implementation AdminDivisionsCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

/**
 初始化UI
 */
-(void)initUI{
    
    self.maMapView.showsUserLocation = NO;
    [self.view addSubview:self.maMapView];
    [self.view addSubview:self.locationLabel];
    
    //获取行政区划
    [self adminDiv];
    
}


/**
 行政区划
 */
-(void)adminDiv{
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = @"丰台区";
    dist.requireExtension = YES;
    //发起行政区划查询
    [self.search AMapDistrictSearch:dist];
    //onDistrictSearchDone 回调结果
}

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response{
    if (response == nil){
        [UIView addMJNotifierWithText:@"未查询到相关数据" dismissAutomatically:YES];
        return;
    }
    //解析response获取行政区划
    self.locationLabel.text = [NSString stringWithFormat:@"%ld-",response.count];
    
    //区域
    for (AMapDistrict *dis in response.districts) {
        self.locationLabel.text = [NSString stringWithFormat:@"%@%@%@",self.locationLabel.text,dis.name,dis.citycode];
        //调整地图
        [self.maMapView setCenterCoordinate:CLLocationCoordinate2DMake(dis.center.latitude, dis.center.longitude) animated:YES];
        for (NSString *polyline in dis.polylines) {
            DLog(@"%@++++",polyline);
            NSArray *points = [polyline componentsSeparatedByString:@";"];
            NSMutableArray *tmp = [NSMutableArray array];
            for (NSString *pointString in points) {
                [tmp addObject:[pointString componentsSeparatedByString:@","]];
            }
            self.coordinateArray = (CLLocationCoordinate2D *)malloc(tmp.count * sizeof(CLLocationCoordinate2D));
            for (int i = 0; i < tmp.count; ++i) {
                NSArray *locationArray = [tmp objectAtIndex:i];
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[locationArray lastObject] floatValue], [[locationArray firstObject] floatValue]);
                self.coordinateArray[i] = location;
            }
            //构建折线对象
            MAPolyline *Polyline = [MAPolyline polylineWithCoordinates:self.coordinateArray count:tmp.count];
            //添加在地图上
            [self.maMapView addOverlay:Polyline];

        }
    }
    
   
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    DLog(@"Error: %@", error);
    [UIView addMJNotifierWithText:error.localizedDescription dismissAutomatically:YES];
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

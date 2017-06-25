//
//  GoecodeCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/5.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "GoecodeCtrl.h"

@interface GoecodeCtrl ()


@end

@implementation GoecodeCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

/**
 初始化UI
 */
-(void)initUI{
    
    [self.view bringSubviewToFront:self.navBar];
    
    self.locationLabel.frame = CGRectMake(0, self.navBar.bottom, kScreenWidth, kScreenHeight-self.navBar.bottom);
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.textColor = [UIColor darkTextColor];
    self.locationLabel.font = [UIFont systemFontOfSize:sizeBig];
    [self.view addSubview:self.locationLabel];
    self.locationLabel.text = @"条件city:北京,address:朝阳区阜荣街\n\n地理编码结果:\n";
    
    
    //从已知的地址描述到对应的经纬度坐标的转换过程
    if ([self.moduleCode isEqualToString:@"geocode"]) {
        [self geocode];
    }
    
    //从已知的经纬度坐标到对应的地址描述（如行政区划、街区、楼层、房间等）的转换。常用于根据定位的坐标来获取该地点的位置详细信息，与定位功能是黄金搭档。
    else if ([self.moduleCode isEqualToString:@"regeocode"]) {
        [self regeocode];
    }
    
}



/**
 地理编码
 */
-(void)geocode{
    
    AMapGeocodeSearchRequest *geo = [AMapGeocodeSearchRequest new];
    geo.city      = @"北京";
    geo.address   = @"朝阳区阜荣街";
    //发起地理编码查询
    [self.search AMapGeocodeSearch:geo];
    
}
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (response.geocodes.count == 0){
        return;
    }
    //解析response获取地理信息
    for (AMapGeocode *geocode  in response.geocodes) {
        self.locationLabel.text = [NSString stringWithFormat:@"%@\n%@\n(%f,%f)\n匹配等级:%@",self.locationLabel.text.length?self.locationLabel.text:@"",geocode.formattedAddress,geocode.location.latitude,geocode.location.longitude,geocode.level];
    }
}










/**
 地理反编码
 */
-(void)regeocode{
    
    self.locationLabel.font = [UIFont systemFontOfSize:sizeSmall];
    
    AMapReGeocodeSearchRequest *regeo = [AMapReGeocodeSearchRequest new];
    regeo.location         = [AMapGeoPoint locationWithLatitude:26.040874 longitude:119.279417];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != nil){
        //
        self.locationLabel.text = response.regeocode.formattedAddress;
        //解析response获取地址描述
        for (AMapRoad *road in response.regeocode.roads) {//道路信息
            self.locationLabel.text = [NSString stringWithFormat:@"%@\n%@",self.locationLabel.text,road.name];
        }
        for (AMapPOI *poi in response.regeocode.pois) {
            self.locationLabel.text = [NSString stringWithFormat:@"%@\n%@",self.locationLabel.text,poi.name];
        }
        for (AMapAOI *aoi in response.regeocode.aois) {
            self.locationLabel.text = [NSString stringWithFormat:@"%@\n%@",self.locationLabel.text,aoi.name];
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

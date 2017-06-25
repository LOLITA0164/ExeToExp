//
//  WeatherCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/6.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "WeatherCtrl.h"

@interface WeatherCtrl ()

@end

@implementation WeatherCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

/**
 初始化UI
 */
-(void)initUI{
    
    self.locationLabel.frame = CGRectMake(0, NavBar_HEIGHT, kScreenWidth, kScreenHeight-NavBar_HEIGHT);
    self.locationLabel.backgroundColor = [defaultSelectedColor colorWithAlphaComponent:0.5];
    [self.view addSubview:self.locationLabel];
}


/**
 初始化数据
 */
-(void)initData{
    
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city = @"福州";
    request.type = AMapWeatherTypeLive; //AMapWeatherTypeLive为实时天气；AMapWeatherTypeForecase为预报天气
    //发起天气查询
    [self.search AMapWeatherSearch:request];
    
}

- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response{
    //解析response获取天气信息
    for (AMapLocalWeatherLive *live in response.lives) {
        DLog(@"城市：%@\n天气：%@\n温度：%@\n风向：%@\n风力：%@\n湿度：%@\n预报时间：%@\n",live.city,live.weather,live.temperature,live.windDirection,live.windPower,live.humidity,live.reportTime);
        self.locationLabel.text = [NSString stringWithFormat:@"城市：%@\n天气：%@\n温度：%@\n风向：%@\n风力：%@\n湿度：%@\n预报时间：%@\n",live.city,live.weather,live.temperature,live.windDirection,live.windPower,live.humidity,live.reportTime];
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

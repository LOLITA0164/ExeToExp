//
//  BusCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/6.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "BusCtrl.h"

@interface BusCtrl ()

@end

@implementation BusCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}


/**
 初始化数据
 */
-(void)initData{
    
    //公交站点查询
    if ([self.moduleCode isEqualToString:@"busStop"]) {
        [self busStop];
    }
    
    //公交路线
    else if ([self.moduleCode isEqualToString:@"busLine"]) {
        [self busLine];
    }
}

/**
 初始化UI
 */
-(void)initUI{
    
    self.maMapView.frame = CGRectMake(0, NavBar_HEIGHT, kScreenWidth, (kScreenHeight-NavBar_HEIGHT)/2.0);
    [self.view addSubview:self.maMapView];
    
    self.table.frame = CGRectMake(0, self.maMapView.bottom, kScreenWidth, kScreenHeight-self.maMapView.bottom);
    [self.view addSubview:self.table];
    
}



/**
 公交站点查询
 */
-(void)busStop{
    
    AMapBusStopSearchRequest *stop = [[AMapBusStopSearchRequest alloc] init];
    stop.keywords = @"橘园洲";
    stop.city = @"福州";
    //直接通过公交站点查询的途径路线是不详细的
    //发起公交站点查询
    [self.search AMapBusStopSearch:stop];
    
}
/* 公交站点回调*/
- (void)onBusStopSearchDone:(AMapBusStopSearchRequest *)request response:(AMapBusStopSearchResponse *)response{
    if (response.busstops.count == 0){
        [UIView addMJNotifierWithText:@"没找到该站点" dismissAutomatically:YES];
        return;
    }
    //解析response获取公交站点信息
    self.data = response.busstops;
    CGFloat latitude = ((AMapBusStop*)self.data.lastObject).location.latitude;
    CGFloat longitude = ((AMapBusStop*)self.data.lastObject).location.longitude;
    [self addPointAnnotationWithLocation:CLLocationCoordinate2DMake(latitude, longitude) animated:YES];
    if (self.table) {
        [self.table reloadData];
    }
}





/**
 公交路线
 */
-(void)busLine{
    
    AMapBusLineNameSearchRequest *line = [[AMapBusLineNameSearchRequest alloc] init];
    line.keywords           = @"163路";
    line.city               = @"福州";
    line.requireExtension   = YES;
    [self.search AMapBusLineNameSearch:line];
}
/* 公交路线回调*/
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response{
    if (response.buslines.count == 0){
        [UIView addMJNotifierWithText:@"没找到该站点" dismissAutomatically:YES];
        return;
    }
    //解析response获取公交线路信息
    self.data = [response.buslines copy];
    [self.table reloadData];
    
}








-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"LOLITA";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [defaultSelectedColor colorWithAlphaComponent:0.5];
        cell.selectedBackgroundView = view;
        cell.textLabel.textColor = defaultUnSelectedColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (self.data.count) {
        id busType = self.data.firstObject;
        if ([busType isKindOfClass:[AMapBusStop class]]) {//公交站点
            AMapBusStop *bs = self.data[indexPath.row];
            cell.textLabel.text = bs.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",bs.buslines.count];
            
        }
        else if ([busType isKindOfClass:[AMapBusLine class]]){//公交路线
            AMapBusLine *bl = self.data[indexPath.row];
            cell.textLabel.text = bl.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",bl.busStops.count];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id busType = self.data.firstObject;
    if ([busType isKindOfClass:[AMapBusStop class]]) {//公交站点
        AMapBusStop *bs = self.data[indexPath.row];
        //添加点并移动地图
        [self addPointAnnotationWithLocation:CLLocationCoordinate2DMake(bs.location.latitude, bs.location.longitude) animated:YES];
        
        self.data = bs.buslines;
        [self.table reloadData];
    }
    else if ([busType isKindOfClass:[AMapBusLine class]]){//公交路线
        AMapBusLine *bl = self.data[indexPath.row];
        NSString *polyline = bl.polyline;
        //添加线
        DLog(@"%@++++",polyline);
        if (polyline.length==0) {
            return;
        }
        NSArray *points = [polyline componentsSeparatedByString:@";"];
        
        NSMutableArray *tmp = [NSMutableArray array];
        for (NSString *pointString in points) {
            NSArray *tmpPoints = [pointString componentsSeparatedByString:@","];
            [tmp addObject:tmpPoints];
        }
        self.coordinateArray = (CLLocationCoordinate2D *)malloc(tmp.count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < tmp.count; ++i) {
            NSArray *locationArray = [tmp objectAtIndex:i];
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[locationArray lastObject] floatValue], [[locationArray firstObject] floatValue]);
            self.coordinateArray[i] = location;
        }
        
        
        //构建折线对象
        MAPolyline *Polyline = [MAPolyline polylineWithCoordinates:self.coordinateArray count:tmp.count];
        //先清除掉之前的
        [self.maMapView removeOverlays:self.maMapView.overlays];
        //添加在地图上
        [self.maMapView addOverlay:Polyline];
        
        
        //调整地图可是范围
        NSMutableArray *tmp2 = [NSMutableArray array];
        if (tmp.count) {
            for (NSArray *point in tmp) {
                NSString *coordinateString = [NSString stringWithFormat:@"%@Ω%@", [point firstObject], [point lastObject]];
                [tmp2 addObject:coordinateString];
            }
            [self.maMapView adjustMapViewVisualRegin:[tmp2 copy]];
        }
        
        
        
        if (bl.busStops.count) {
            //绘制站点
            for (AMapBusStop *stop in bl.busStops) {
                //构造圆
                MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(stop.location.latitude, stop.location.longitude) radius:50];//单位米
                //添加到地图上
                [self.maMapView addOverlay:circle];
            }
        }
        
        
        
    }
    
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

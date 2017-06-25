//
//  POISearchCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/5.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "POISearchCtrl.h"

@interface POISearchCtrl ()

@end

@implementation POISearchCtrl
-(void)viewDidDisappear:(BOOL)animated{
    [self.hudView hideProgressHUD];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

/**
 初始化UI
 */
-(void)initUI{

    self.table.frame = CGRectMake(0, NavBar_HEIGHT, kScreenWidth, kScreenHeight-NavBar_HEIGHT);
    [self.view addSubview:self.table];
    
    [self.hudView showProgressHUDWithString:@"搜索中"];
    
    //根据关键字检索适用于在某个城市搜索某个名称相关的POI
    if ([self.moduleCode isEqualToString:@"POIKeyword"]) {
        [self POIKeyword];
    }
    
    //适用于搜索某个位置附近的POI，可设置POI的类别，具体查询所在位置的餐饮类、住宅类POI，例如：查找天安门附近的厕所等等场景。
    else if ([self.moduleCode isEqualToString:@"POIAround"]) {
        [self POIAround];
    }
    
    //适用于在搜索某个不规则区域的POI，例如：查找中关村范围内的停车场。
    else if ([self.moduleCode isEqualToString:@"POIPolygon"]) {
        [self POIPolygon];
    }
    
    //可根据规划的路径，查询该路径沿途的加油站、ATM、汽修店、厕所。
    else if ([self.moduleCode isEqualToString:@"POIRoute"]) {
        [self POIRoute];
    }
    
}


/**
 关键字搜索
 */
-(void)POIKeyword{
    
    self.needDetailBtn = YES;
    //配置搜索条件
    AMapPOIKeywordsSearchRequest *request = [AMapPOIKeywordsSearchRequest new];
    request.keywords                      = @"大学";
    request.city                          = @"北京";
    request.types                         = @"";
    request.requireExtension              = YES;
    /* 按照距离排序. */
    request.sortrule                      = 0;
    request.offset                        = 50;//页数
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit                     = YES;
    request.requireSubPOIs                = YES;
    //发起关键字搜索
    [self.search AMapPOIKeywordsSearch:request];
    //onPOISearchDone代理方法中
    
}

/**
 周边检索
 */
-(void)POIAround{
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];//北京
    request.keywords            = @"KFC";
    request.radius              = 10000;
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.offset              = 50;//页数
    request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:request];
    //onPOISearchDone
}


/**
 多边形检索
 */
-(void)POIPolygon{
    
    NSArray *points = [NSArray arrayWithObjects:
                       [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476],
                       [AMapGeoPoint locationWithLatitude:39.890459 longitude:116.581476],
                       nil];//两个点表示矩形的左下－右上
    AMapGeoPolygon *polygon = [AMapGeoPolygon polygonWithPoints:points];
    AMapPOIPolygonSearchRequest *request = [[AMapPOIPolygonSearchRequest alloc] init];
    request.polygon                      = polygon;
    request.keywords                     = @"华为";
    request.requireExtension             = YES;
    [self.search AMapPOIPolygonSearch:request];
    //onPOISearchDone
}


#pragma POI代理
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0){
        return;
    }
    self.data = [response.pois copy];
    [self.table reloadData];
    [self.hudView hideProgressHUD];
}



//UI部分
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"LOLITA";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [defaultSelectedColor colorWithAlphaComponent:0.5];
        cell.selectedBackgroundView = view;
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    if (self.data.count) {
        if ([self.moduleCode isEqualToString:@"POIRoute"]) {//沿途搜索
            AMapRoutePOI *poi = self.data[indexPath.row];
            cell.textLabel.text = poi.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld米",poi.distance];
        }else{
            AMapPOI *poi = self.data[indexPath.row];
            cell.textLabel.text = poi.name;
            cell.detailTextLabel.text = poi.district;
            if ([self.moduleCode isEqualToString:@"POIAround"]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f",poi.extensionInfo.rating];
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (![self.moduleCode isEqualToString:@"POIAround"]) {
        return;
    }
    AMapPOI *poi = self.data[indexPath.row];
    //ID检索
    AMapPOIIDSearchRequest *request = [[AMapPOIIDSearchRequest alloc] init];
    request.uid                     = poi.uid;
    request.requireExtension        = YES;
    [self.search AMapPOIIDSearch:request];
}


















/**
 沿途搜索
 */
-(void)POIRoute{
    AMapRoutePOISearchRequest *request = [[AMapRoutePOISearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude:26.049479 longitude:119.246598];
    request.destination = [AMapGeoPoint locationWithLatitude:26.113888 longitude:119.320713];
    request.strategy = AMapDrivingStrategyFastest;//驾车策略
    request.searchType = AMapRoutePOISearchTypeGasStation;//搜索类型
    //检索
    [self.search AMapRoutePOISearch:request];
}
/* 沿途搜索回调. */
- (void)onRoutePOISearchDone:(AMapRoutePOISearchRequest *)request response:(AMapRoutePOISearchResponse *)response{
    [self.hudView hideProgressHUD];
    if (response.pois.count == 0){
        return;
    }
    //解析response获取POI信息
    self.data = [response.pois copy];
    [self.table reloadData];
    
}




















/**
 详细按钮
 */
-(void)detailBtn{
    
    WebCtrl *ctrl = [[WebCtrl alloc] init];
    
    ctrl.dataUrlString = kPOISearch;

    [self.navigationController pushViewController:ctrl animated:YES];
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

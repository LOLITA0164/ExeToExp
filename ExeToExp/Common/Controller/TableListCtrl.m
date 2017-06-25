//
//  TableListCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/26.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "TableListCtrl.h"
#import "POPMenuCell.h"

@interface TableListCtrl ()

@end

@implementation TableListCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}


/**
 初始化视图
 */
-(void)initUI{
    
    [self.view addSubview:self.table];
    
}

#pragma mark - table代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"LOLITA";
    POPMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[POPMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [defaultSelectedColor colorWithAlphaComponent:0.5];
        cell.selectedBackgroundView = view;
        cell.textLabel.textColor = defaultUnSelectedColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Module *module = self.data[indexPath.row];
    cell.textLabel.text = module.MODULENAME;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Module *module = self.data[indexPath.row];
    DLog(@"code:%@",module.MODULECODE);
    if (module.MODULENODES.count) {
        TableListCtrl *ctrl = [[TableListCtrl alloc] init];
        [self pushViewCtrl:ctrl withModule:module];
    }
    else{
        
        /************************实用工具************************/
        
        //二维码
        if ([module.MODULECODE containsString:@"QRCode"]) {
            QRCodeCtrl *ctrl = [[QRCodeCtrl alloc] init];
            ctrl.moduleCode = module.MODULECODE;
            [self pushViewCtrl:ctrl withModule:module];
        }
        //音频
        else if ([module.MODULECODE containsString:@"audio"]){
            AudioCtrl *ctrl = [[AudioCtrl alloc] init];
            ctrl.moduleCode = module.MODULECODE;
            [self pushViewCtrl:ctrl withModule:module];
        }
        else if ([module.MODULECODE containsString:@"speechRecognition"]){
            SpeechRecognitionCtrl *ctrl = [[SpeechRecognitionCtrl alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        //AFNetworking二次封装
        else if ([module.MODULECODE containsString:@"NetTools"]){
            WebCtrl *ctrl = [[WebCtrl alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        
        
        
        
        
        /**********************技巧收藏**********************/
        else if ([module.MODULECODE containsString:@"schemes"]){
            WebCtrl *ctrl = [[WebCtrl alloc] init];
            ctrl.dataUrlString = kURLSchemes;
            [self pushViewCtrl:ctrl withModule:module];
        }
        
        else if ([module.MODULECODE containsString:@"&"]){
            TimeSetCtrl *ctrl = [[TimeSetCtrl alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        
        
        
        
        
        
        
        /************************练习************************/
        //高德地图--定位
        else if ([module.MODULECODE containsString:@"Location"]){
            LocationCtrl *ctrl = [[LocationCtrl alloc] init];
            ctrl.moduleCode = module.MODULECODE;
            [self pushViewCtrl:ctrl withModule:module];
        }
        //高德地图--绘制标记点、折线
        else if ([module.MODULECODE containsString:@"drawUp"]){
            DrawUpCtrl *ctrl = [[DrawUpCtrl alloc] init];
            ctrl.moduleCode = module.MODULECODE;
            [self pushViewCtrl:ctrl withModule:module];
        }
        //高德地图--绘制运动轨迹
        else if ([module.MODULECODE containsString:@"TraceUser"]){
            TraceUserLocationCtrl *ctrl = [[TraceUserLocationCtrl alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        //高德地图--绘制运动轨迹
        else if ([module.MODULECODE containsString:@"TraceSerial"]){
            TraceSerialLocationCtrl *ctrl = [[TraceSerialLocationCtrl alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        //高德地图--绘制运动轨迹
        else if ([module.MODULECODE containsString:@"TraceSingle"]){
            TraceSingleLocationCtrl *ctrl = [[TraceSingleLocationCtrl alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        //高德地图--POI搜索
        else if ([module.MODULECODE containsString:@"POI"]){
            POISearchCtrl *ctrl = [[POISearchCtrl alloc] init];
            ctrl.moduleCode = module.MODULECODE;
            [self pushViewCtrl:ctrl withModule:module];
        }
        //高德地图--地理编码和反编码
        else if ([module.MODULECODE containsString:@"geocode"]){
            GoecodeCtrl *ctrl = [[GoecodeCtrl alloc] init];
            ctrl.moduleCode = module.MODULECODE;
            [self pushViewCtrl:ctrl withModule:module];
        }
        //高德地图--行政区划
        else if ([module.MODULECODE containsString:@"adminDiv"]){
            AdminDivisionsCtrl *ctrl = [[AdminDivisionsCtrl alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        //高德地图--天气
        else if ([module.MODULECODE containsString:@"weather"]){
            WeatherCtrl *ctrl = [[WeatherCtrl alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        //高德地图--公交查询
        else if ([module.MODULECODE containsString:@"bus"]){
            BusCtrl *ctrl = [[BusCtrl alloc] init];
            ctrl.moduleCode = module.MODULECODE;
            [self pushViewCtrl:ctrl withModule:module];
        }
        
        
        
        //应用跳转
        else if ([module.MODULECODE containsString:@"skip"]){
            SkipToApp *ctrl = [[SkipToApp alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        
        
        
        //WKWebView
        else if ([module.MODULECODE containsString:@"use"]){
            WKWebCtrl *ctrl = [[WKWebCtrl alloc] init];
            ctrl.dataUrlString = @"https://www.tmall.com/";
            [self pushViewCtrl:ctrl withModule:module];
        }
        else if ([module.MODULECODE containsString:@"js"]){
            WK_JS_Ctrl *ctrl = [[WK_JS_Ctrl alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        
        
        //POP
        else if ([module.MODULECODE containsString:@"pop"]){
            POPCtrl *ctrl = [[POPCtrl alloc] init];
            ctrl.moduleCode = module.MODULECODE;
            [self pushViewCtrl:ctrl withModule:module];
        }
        //POP
        else if ([module.MODULECODE containsString:@"More Example"]){
            POPingCtrl *ctrl = [[POPingCtrl alloc] init];
            [self pushViewCtrl:ctrl withModule:module];
        }
        
        
        
        
        
        /************************体会************************/
        
        
        
        
        
    }
    
}



/**
 push
 
 @param ctrl ctrl
 @param module module
 */
-(void)pushViewCtrl:(BaseCtrl*)ctrl withModule:(Module*)module{
    ctrl.data = module.MODULENODES;
    ctrl.navBar.title = module.MODULENAME;
    ctrl.needGoBackBtn = YES;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}











/**
 释放
 */
-(void)dealloc{
    DLog(@"TableListCtrl dealloc !!");
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

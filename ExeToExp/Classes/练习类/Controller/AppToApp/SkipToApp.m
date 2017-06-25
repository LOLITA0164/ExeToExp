//
//  SkipToApp.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/30.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "SkipToApp.h"

@interface SkipToApp ()

@end

@implementation SkipToApp

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

/**
 初始化数据
 */
-(void)initData{
    self.data = @[@"签到记录查询",@"签到"];
}

/**
 初始化UI
 */
-(void)initUI{
    self.needDetailBtn = YES;
    [self.view addSubview:self.table];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *moduleCode = self.data[indexPath.row];
    if ([moduleCode isEqualToString:@"签到记录查询"]) {
        NSURL *url = [NSURL URLWithString:@"istrong.signIn://net.strongsoft.fxysignin/signinfindall?username=18649851495&password=49851495&orgId=jg2017001"];
        //如果已经安装了这个应用，就跳转
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        else{
            DLog(@"没有安装改应用");
        }
    }
    else if ([moduleCode isEqualToString:@"签到"]) {
        NSURL *url = [NSURL URLWithString:@"istrong.signIn://net.strongsoft.fxysignin/signin?username=18006930769&password=06930769&orgId=jg2017001"];
        //如果已经安装了这个应用，就跳转
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        else{
            DLog(@"没有安装改应用");
        }
    }
}


/**
 重写详情按钮
 */
-(void)detailBtn{
    WebCtrl *ctrl = [[WebCtrl alloc] init];
    ctrl.dataUrlString = kAppSkipToAPP;
    [self.navigationController pushViewController:ctrl animated:YES];
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

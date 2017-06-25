//
//  BaseCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "BaseCtrl.h"

@interface BaseCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UIImageView *backgroundView;

@end

@implementation BaseCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.backgroundView = [[UIImageView alloc] initWithFrame:kScreenBounds];
    self.backgroundView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:self.backgroundView];
    
    self.navBar.backgroundColor = [defaultSelectedColor colorWithAlphaComponent:0.8];
    self.navBar.titleLabel.textColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.navBar];
    [self.view addSubview:self.navBar];
    
}


#pragma mark - table初始化
-(UITableView *)table{
    if (_table==nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBar_HEIGHT, kScreenWidth, kScreenHeight-NavBar_HEIGHT) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.tableFooterView = [[UIView alloc] init];
        _table.backgroundColor = [UIColor clearColor];
    }
    return _table;
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"LOLITA";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [defaultSelectedColor colorWithAlphaComponent:0.5];
        cell.selectedBackgroundView = view;
        cell.textLabel.textColor = defaultUnSelectedColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (self.data.count) {
        cell.textLabel.text = self.data[indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/**
 navBar
 
 @return nil
 */
-(NavBarView *)navBar{
    if (_navBar==nil) {
        _navBar = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavBar_HEIGHT)];
    }
    return _navBar;
}

/**
 返回按钮

 @param needGoBackBtn nil
 */
-(void)setNeedGoBackBtn:(BOOL)needGoBackBtn{
    if (needGoBackBtn) {
        UIButton *goBackBtn = [UIButton buttonImageWithTitle:@"返回"
                                                      target:self
                                                    selector:@selector(goBackBtnAction)
                                                       frame:CGRectMake(10, 25, 80, 34)
                                                       image:[UIImage imageNamed:@"goback"]
                                                     bgImage:nil
                                                imagePressed:nil
                                                   textColor:[UIColor whiteColor]
                                                    textFont:[UIFont systemFontOfSize:sizeBig]
                                             edgeInsetsStyle:ImageLeft
                                             imageTitleSpace:0];
        goBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.navBar.letfView = goBackBtn;
    }
}

/**
 返回事件
 */
-(void)goBackBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}



/**
 详情按钮

 @param needDetailBtn nil
 */
-(void)setNeedDetailBtn:(BOOL)needDetailBtn{
    if (needDetailBtn) {
        UIButton *detailBtn = [UIButton buttonImageWithTitle:nil
                                                      target:self
                                                    selector:@selector(detailBtn)
                                                       frame:CGRectMake(self.navBar.width-44, 25, 80, 34)
                                                       image:[UIImage imageNamed:@"detail"]
                                                     bgImage:nil
                                                imagePressed:nil
                                                   textColor:[UIColor whiteColor]
                                                    textFont:[UIFont systemFontOfSize:sizeBig]
                                             edgeInsetsStyle:ImageLeft
                                             imageTitleSpace:0];
        detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.navBar addSubview:detailBtn];
    }
}
-(void)detailBtn{
    
}





-(HUDView *)hudView{
    if (_hudView==nil) {
        _hudView = [[HUDView alloc] init];
    }
    return _hudView;
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

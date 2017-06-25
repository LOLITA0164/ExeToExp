//
//  POPingCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/22.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "POPingCtrl.h"

static NSString* const kCellId = @"cellId";

@interface POPingCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView *tb;
@property(nonatomic)NSArray *items;

@end

@implementation POPingCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}


-(void)initUI
{
    self.items = @[@[@"Bution Aniamtion",[ButtonCtrl class]],
                   @[@"Circle Aniamtion",[CircleCtrl class]],
                   @[@"Bution Aniamtion",[ButtonCtrl class]],
                   @[@"Bution Aniamtion",[ButtonCtrl class]],
                   @[@"Bution Aniamtion",[ButtonCtrl class]]
                   ];
    
    
    self.tb                 = [UITableView new];
    self.tb.frame           = CGRectMake(0, NavBar_HEIGHT, kScreenWidth, kScreenHeight-NavBar_HEIGHT);
    self.tb.rowHeight       = 50;
    self.tb.delegate        = self;
    self.tb.dataSource      = self;
    self.tb.tableFooterView = [[UIView alloc] init];
    self.tb.backgroundColor = [UIColor clearColor];
    [self.tb registerClass:[POPMenuCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.tb];
    
    
    NSMutableAttributedString *attrbutedString = [[NSMutableAttributedString alloc] initWithString:@"popping"];
    [attrbutedString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(1, 1)];
    self.navBar.titleLabel.attributedText      = attrbutedString;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POPMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    cell.textLabel.text = [self.items[indexPath.row] firstObject];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *ctrl = [[self.items[indexPath.row] lastObject] new];
    ctrl.title             = [self.items[indexPath.row] firstObject];
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

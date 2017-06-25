//
//  TimeSetCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/1.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "TimeSetCtrl.h"

@interface TimeSetCtrl ()

@property(strong,nonatomic)UILabel *tipLabel;

@end

@implementation TimeSetCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tipLabel];
    
    NSString *startString;
    NSString *endString;
    
    [NSString adjustSearchTimeToEightFromCurrentTime:&startString endTime:&endString withTimePoint:5];
    
    self.tipLabel.text = [NSString stringWithFormat:@"%@\n%@",startString,endString];
    
}


-(UILabel *)tipLabel{
    if (_tipLabel==nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _tipLabel.textColor = [UIColor darkTextColor];
        _tipLabel.font = [UIFont systemFontOfSize:20];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.center = self.view.center;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
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

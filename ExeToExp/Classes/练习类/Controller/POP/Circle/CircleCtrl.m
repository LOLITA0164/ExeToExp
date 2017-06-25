//
//  CircleCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "CircleCtrl.h"

@interface CircleCtrl ()
@property(nonatomic) CircleView *circleView;
@property(nonatomic) UISlider *slider;
@end

@implementation CircleCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}


-(void)initUI{
    
    self.navBar.title = self.title;
    self.needGoBackBtn = YES;
    
    [self.view addSubview:self.circleView];
    [self.circleView setStrokeEnd:self.slider.value animated:YES];
    [self.view addSubview:self.slider];
    
}


-(CircleView *)circleView
{
    if (_circleView==nil) {
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _circleView.strokeColor = RandColor;
        _circleView.center = self.view.center;
    }
    return _circleView;
}

-(UISlider *)slider
{
    if (_slider==nil) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.8, 5)];
        _slider.value = 0.44;
        _slider.tintColor = RandColor;
        _slider.center = CGPointMake(self.view.centerX, self.circleView.bottom+100);
        [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (void)sliderChanged:(UISlider *)slider
{
    [self.circleView setStrokeEnd:slider.value animated:YES];
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

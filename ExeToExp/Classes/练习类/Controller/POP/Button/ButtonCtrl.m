//
//  ButtonCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "ButtonCtrl.h"

@interface ButtonCtrl ()

@property(strong,nonatomic)LLButton *btn;
@property (nonatomic) UILabel *errorLabel;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ButtonCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}


-(void)initUI{
    
    self.navBar.title = self.title;
    self.needGoBackBtn = YES;
    
    [self.view addSubview:self.btn];
    [self.view insertSubview:self.errorLabel belowSubview:self.btn];
    [self.btn addSubview:self.activityIndicatorView];
    
    
}


-(LLButton *)btn{
    if (_btn==nil) {
        _btn = [LLButton button];
        _btn.frame = CGRectMake(0, 0, 80, 40);
        _btn.center = self.view.center;
        _btn.backgroundColor = defaultSelectedColor;
        _btn.layer.cornerRadius = 5;
        _btn.layer.masksToBounds = YES;
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setTitle:@"登 录" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

-(UILabel *)errorLabel{
    if (_errorLabel==nil) {
        _errorLabel = [UILabel new];
        _errorLabel.frame = CGRectMake(0, 0, kScreenWidth, 30);
        _errorLabel.center = self.btn.center;
        _errorLabel.layer.opacity = 0.0;
        _errorLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18];
        _errorLabel.textColor = [UIColor redColor];
        _errorLabel.text = @"Just a serious login error.";
        _errorLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _errorLabel;
}


-(UIActivityIndicatorView *)activityIndicatorView{
    if (_activityIndicatorView==nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.frame = CGRectMake(0, 0, self.btn.width, self.btn.height);
    }
    return _activityIndicatorView;
}







- (void)touchUpInside:(LLButton *)button
{
    [self hideLabel];
    [self.activityIndicatorView startAnimating];
    if (self.activityIndicatorView.isAnimating) {
        [button setTitle:@"" forState:UIControlStateNormal];
    }
    button.userInteractionEnabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        button.userInteractionEnabled = YES;
        [self.activityIndicatorView stopAnimating];
        [button setTitle:@"Log in" forState:UIControlStateNormal];
        [self shakeButton];
        [self showLabel];
    });
}






/**
 摇晃btn
 */
- (void)shakeButton
{
    POPSpringAnimation *shakeBtnAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    shakeBtnAni.velocity            = @800;
    shakeBtnAni.springBounciness    = 20;
    [shakeBtnAni setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.btn.userInteractionEnabled = YES;
    }];
    [self.btn.layer pop_addAnimation:shakeBtnAni forKey:@"shakeBtnAni"];
}


/**
 显示Label
 */
- (void)showLabel
{
    //设置Size
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.fromValue          = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    layerScaleAnimation.toValue            = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    //设置Alpha
    POPBasicAnimation *layerOpacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    layerOpacityAnimation.fromValue          = @(0);
    layerOpacityAnimation.toValue            = @(1);
    layerOpacityAnimation.duration           = 1.0;
    [self.errorLabel.layer pop_addAnimation:layerOpacityAnimation forKey:@"layerOpacityAnimation"];
    //移动y轴
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue             = @(self.btn.bottom+self.btn.height/2.0);
    layerPositionAnimation.springBounciness    = 20;
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}


/**
 隐藏Label
 */
- (void)hideLabel
{
    //设置Size
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    //移动y轴
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.btn.y);
    [layerScaleAnimation setCompletionBlock:^(POPAnimation *Animation, BOOL finished) {
        //设置Alpha
        self.errorLabel.layer.opacity = 0.0;
    }];
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
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

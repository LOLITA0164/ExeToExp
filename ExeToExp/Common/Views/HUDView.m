//
//  HUDView.m
//  SignInTool
//
//  Created by LOLITA on 17/3/13.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "HUDView.h"

@implementation HUDView


- (void)showProgressHUDWithString:(NSString *)tipString{
    if (!_progressHUD) {
        _progressHUD = [UIButton buttonWithType:UIButtonTypeCustom];
        [_progressHUD setBackgroundColor:[UIColor clearColor]];
        
        _HUDContainer = [[UIView alloc] init];
        _HUDContainer.frame = CGRectMake((kScreenWidth - 120) / 2, (kScreenHeight- 90) / 2, 120, 90);
        _HUDContainer.layer.cornerRadius = 8;
        _HUDContainer.clipsToBounds = YES;
        _HUDContainer.backgroundColor = [UIColor darkGrayColor];
        _HUDContainer.alpha = 0.7;
        
        _HUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
        
        _HUDLabel = [[UILabel alloc] init];
        _HUDLabel.frame = CGRectMake(0,40, 120, 50);
        _HUDLabel.textAlignment = NSTextAlignmentCenter;
        _HUDLabel.font = [UIFont systemFontOfSize:15];
        _HUDLabel.textColor = [UIColor whiteColor];
        
        [_HUDContainer addSubview:_HUDLabel];
        [_HUDContainer addSubview:_HUDIndicatorView];
        [_progressHUD addSubview:_HUDContainer];
    }
    _HUDLabel.text = tipString;
    [_HUDIndicatorView startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHUD];

}

- (void)hideProgressHUD {
    if (_progressHUD) {
        [_HUDIndicatorView stopAnimating];
        [_progressHUD removeFromSuperview];
    }
}




-(void)showTip:(NSString *)tipString delay:(CGFloat)delay{
    if (!_progressHUD2) {
        _progressHUD2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_progressHUD2 setBackgroundColor:[UIColor clearColor]];
        
        _HUDContainer2 = [[UIView alloc] init];
        _HUDContainer2.frame = CGRectMake((kScreenWidth - 120) / 2, (kScreenHeight- 40) / 2, 120, 40);
        _HUDContainer2.layer.cornerRadius = 8;
        _HUDContainer2.clipsToBounds = YES;
        _HUDContainer2.backgroundColor = [UIColor darkGrayColor];
        _HUDContainer2.alpha = 0.7;
        
        _HUDLabel2 = [[UILabel alloc] init];
        _HUDLabel2.frame = _HUDContainer2.bounds;
        _HUDLabel2.textAlignment = NSTextAlignmentCenter;
        _HUDLabel2.font = [UIFont systemFontOfSize:15];
        _HUDLabel2.textColor = [UIColor whiteColor];
        
        [_HUDContainer2 addSubview:_HUDLabel2];
        [_progressHUD2 addSubview:_HUDContainer2];
    }
    _HUDLabel2.text = tipString;
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHUD2];
    if (delay&&delay>0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideTip];
        });
    }
}
- (void)hideTip{
    if (_progressHUD2) {
        [_progressHUD2 removeFromSuperview];
    }
}


-(void)showIndicatorView{
    if (!_progressHUD2) {
        _progressHUD2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_progressHUD2 setBackgroundColor:[UIColor clearColor]];
        
        _HUDContainer2 = [[UIView alloc] init];
        _HUDContainer2.frame = CGRectMake((kScreenWidth - 40) / 2.0, (kScreenHeight- 40) / 2.0, 40, 40);
        _HUDContainer2.layer.cornerRadius = 8;
        _HUDContainer2.clipsToBounds = YES;
        _HUDContainer2.backgroundColor = [UIColor clearColor];
        _HUDContainer2.alpha = 0.7;
        
        _HUDIndicatorView2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _HUDIndicatorView2.frame = CGRectMake((_HUDContainer2.width-30)/2.0, (_HUDContainer2.height-30)/2.0, 30, 30);
        
        [_HUDContainer2 addSubview:_HUDIndicatorView2];
        [_HUDIndicatorView2 startAnimating];
        [_progressHUD2 addSubview:_HUDContainer2];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHUD2];
}

-(void)hideIndicatorView{
    [_HUDIndicatorView2 stopAnimating];
    [self hideTip];
}


@end

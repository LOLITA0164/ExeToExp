//
//  HUDView.h
//  SignInTool
//
//  Created by LOLITA on 17/3/13.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HUDView : UIView
{
    UIButton *_progressHUD;
    UIView *_HUDContainer;
    UIActivityIndicatorView *_HUDIndicatorView;
    UILabel *_HUDLabel;
    
    UIButton *_progressHUD2;
    UIView *_HUDContainer2;
    UIActivityIndicatorView *_HUDIndicatorView2;
    UILabel *_HUDLabel2;
}



/**
 HUD

 @param tipString 提示文字
 */
- (void)showProgressHUDWithString:(NSString *)tipString;


/**
 消失
 */
- (void)hideProgressHUD;


/**
 结果

 @param tipString nil
 */
-(void)showTip:(NSString*)tipString delay:(CGFloat)delay;



/**
 显示指示器
 */
-(void)showIndicatorView;


/**
 隐藏指示器
 */
- (void)hideIndicatorView;





@end

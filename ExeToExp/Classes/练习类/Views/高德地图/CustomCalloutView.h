//
//  CustomCalloutView.h
//  ExeToExp
//
//  Created by LOLITA on 17/3/30.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCalloutView : UIView

@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *imageName; //图片

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

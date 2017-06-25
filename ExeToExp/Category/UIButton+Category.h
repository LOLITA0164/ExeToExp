//
//  UIButton+Category.h
//  ExeToExp
//
//  Created by LOLITA on 17/3/25.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>

// 获取RGB颜色
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//随机颜色
#define RandColor ColorWithRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

typedef NS_ENUM(NSUInteger, ButtonStyle) {
    ImageTop, // image在上，label在下
    ImageLeft, // image在左，label在右
    ImageBottom, // image在下，label在上
    ImageRight // image在右，label在左
};


@interface UIButton (Category)


/**
 *  普通的
 */
+(UIButton*)buttonNormalWithTitle:(NSString*)title
                           target:(id)target
                         selector:(SEL)selector
                            frame:(CGRect)frame
                          bgImage:(UIImage*)bgImage
                     imagePressed:(UIImage*)imagePressed
                        textColor:(UIColor*)aColor
                         textFont:(UIFont*)textFont;

/**
 *  图片,文字.如果image为nil，效果和普通样式一样
 */
+(UIButton*)buttonImageWithTitle:(NSString*)title
                          target:(id)target
                        selector:(SEL)selector
                           frame:(CGRect)frame
                           image:(UIImage*)image
                         bgImage:(UIImage*)bgImage
                    imagePressed:(UIImage*)imagePressed
                       textColor:(UIColor*)aColor
                        textFont:(UIFont*)text
                 edgeInsetsStyle:(ButtonStyle)style
                 imageTitleSpace:(CGFloat)space;

@end

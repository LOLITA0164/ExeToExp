//
//  UIButton+Category.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/25.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)

/**
 *  普通Button
 */
+(UIButton *)buttonNormalWithTitle:(NSString *)title
                            target:(id)target
                          selector:(SEL)selector
                             frame:(CGRect)frame
                           bgImage:(UIImage *)bgImage
                      imagePressed:(UIImage *)imagePressed
                         textColor:(UIColor *)aColor
                          textFont:(UIFont *)textFont{
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    /**
     *  作用对象，方法
     */
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    /**
     *  设置标题、颜色、字体大小
     */
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:aColor forState:UIControlStateNormal];
    [button.titleLabel setFont:textFont];
    /**
     *  设置背景颜色
     */
    button.backgroundColor = [UIColor clearColor];
    /**
     *  设置背景图片
     */
    if(bgImage)
    {
        UIImage *newImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
    }
    /**
     *  设置选中时的背景图片
     */
    if(imagePressed)
    {
        UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:imagePressed.size.width/2 topCapHeight:imagePressed.size.height/2];
        [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    }
    /**
     *  文字居中
     */
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    return button;
}


/**
 *  图片文字
 */
+(UIButton *)buttonImageWithTitle:(NSString *)title
                           target:(id)target
                         selector:(SEL)selector
                            frame:(CGRect)frame
                            image:(UIImage *)image
                          bgImage:(UIImage *)bgImage
                     imagePressed:(UIImage *)imagePressed
                        textColor:(UIColor *)aColor
                         textFont:(UIFont *)textFont
                  edgeInsetsStyle:(ButtonStyle)style
                  imageTitleSpace:(CGFloat)space{
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    /**
     *  作用对象，方法
     */
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    /**
     *  设置标题颜色、字体大小
     */
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:aColor forState:UIControlStateNormal];
    [button.titleLabel setFont:textFont];
    /**
     *  设置图片、标题以及两者位置
     */
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = button.imageView.frame.size.height;
        CGFloat imageHeight = button.imageView.frame.size.height;
        CGFloat titleLabelWidth = 0.0;
        CGFloat titleLabelHeight = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
            titleLabelWidth = button.titleLabel.intrinsicContentSize.width;
            titleLabelHeight = button.titleLabel.intrinsicContentSize.height;
        }else{
            titleLabelWidth = button.titleLabel.frame.size.width;
            titleLabelWidth = button.titleLabel.frame.size.height;
        }
        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets titleLabelEdgeInsets = UIEdgeInsetsZero;
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch (style) {
            case ImageTop:
            {
                imageEdgeInsets = UIEdgeInsetsMake(-titleLabelHeight-space/2.0, 0, 0, -titleLabelWidth);
                titleLabelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
            }
                break;
            case ImageLeft:
            {
                imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
                titleLabelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
            }
                break;
            case ImageBottom:
            {
                imageEdgeInsets = UIEdgeInsetsMake(0, 0, -titleLabelHeight-space/2.0, -titleLabelWidth);
                titleLabelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
            }
                break;
            case ImageRight:
            {
                imageEdgeInsets = UIEdgeInsetsMake(0, titleLabelWidth+space/2.0, 0, -titleLabelWidth-space/2.0);
                titleLabelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
            }
                break;
            default:
                break;
        }
        // 4. 赋值
        button.titleEdgeInsets = titleLabelEdgeInsets;
        button.imageEdgeInsets = imageEdgeInsets;
    }
    /**
     *  设置背景颜色
     */
    button.backgroundColor = [UIColor clearColor];
    /**
     *  设置背景图片
     */
    if(bgImage)
    {
        UIImage *newImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
    }
    /**
     *  设置选中时的背景图片
     */
    if(imagePressed)
    {
        UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:imagePressed.size.width/2 topCapHeight:imagePressed.size.height/2];
        [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    }
    /**
     *  居中
     */
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return button;
}


@end

//
//  UIImage+QR.h
//  multiPurposeDemo
//
//  Created by LOLITA on 17/2/13.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QR)


/**
 生成二维码

 @param data 数据
 @param codeSize 大小
 @return 二维码图片
 */
+(UIImage*)imageOfQRFromData:(NSData *)data codeSize:(CGFloat)codeSize;

/**
 插入图片

 @param data 数据
 @param insertImage 插入的图片
 @param codeSize 大小
 @return 二维码图片
 */
+(UIImage*)imageOfQRFromData:(NSData *)data insertImage:(UIImage *)insertImage codeSize:(CGFloat)codeSize;

/**
 插入图片带圆角

 @param data 数据
 @param insertImage 插入图片
 @param roundRadius 圆角大小
 @param codeSize 大小
 @return 二维码图片
 */
+(UIImage*)imageOfQRFromData:(NSData *)data insertImage:(UIImage *)insertImage roundRadius: (CGFloat)roundRadius codeSize:(CGFloat)codeSize;

/**
 改变颜色

 @param data 数据
 @param red red
 @param green green
 @param blue blue
 @param codeSize 大小
 @return 二维码图片
 */
+(UIImage *)imageOfQRFromData:(NSData *)data red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue codeSize:(CGFloat)codeSize;

/**
 改变颜色,带图

 @param data 数据
 @param red red
 @param green green
 @param blue blue
 @param insertImage 插入图片
 @param codeSize 大小
 @return 二维码图片
 */
+(UIImage *)imageOfQRFromData:(NSData *)data red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue insertImage: (UIImage *)insertImage codeSize: (CGFloat)codeSize;

/**
 改变颜色,带圆角图

 @param data 数据
 @param red red
 @param green green
 @param blue blue
 @param insertImage 插入图片
 @param roundRadius 圆角
 @param codeSize 大小
 @return 二维码图片
 */
+(UIImage*)imageOfQRFromData:(NSData *)data red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue insertImage:(UIImage *)insertImage roundRadius: (CGFloat)roundRadius codeSize:(CGFloat)codeSize;

@end

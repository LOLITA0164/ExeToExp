//
//  QRScanner.h
//  multiPurposeDemo
//
//  Created by LOLITA on 17/2/15.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
/**
 *  屏幕 高 宽 边界
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height-64
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds

#define TOP (SCREEN_HEIGHT-220)/2
#define LEFT (SCREEN_WIDTH-220)/2

#define kScanRect CGRectMake(LEFT, TOP, 220, 220)

@protocol QRScannerDelegate;

@interface QRScanner : UIView<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
}

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, assign) id<QRScannerDelegate>delegate;

/**
 开启扫描
 */
-(void)startScan;


/**
 停止扫描
 */
-(void)stopScan;


/**
 关闭手电筒
 */
-(void)turnOffTorch;


/**
 开启手电筒
 */
-(void)turnOnTorch;


/**
 自动控制手电筒的开关
 */
-(void)turnOffOrTurnOnTorch;

@end



@protocol QRScannerDelegate <NSObject>

-(void)QRScannerOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection;

@end





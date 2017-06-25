//
//  QRScanner.m
//  multiPurposeDemo
//
//  Created by LOLITA on 17/2/15.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "QRScanner.h"

@implementation QRScanner


-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self configScanner];
    return self;
}


-(void)startScan{
    // 开启会话
    [self.session startRunning];
    [timer setFireDate:[NSDate date]];
}

-(void)stopScan{
    // 停止会话
    [self.session stopRunning];
    [timer setFireDate:[NSDate distantFuture]];
}

-(void)configScanner{
    
    // 1. 实例化拍摄设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2. 设置输入设备
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 3. 设置元数据输出
    // 3.1 实例化拍摄元数据输出
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.3 设置输出数据代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 3.4 设置扫描区域
    CGFloat top = TOP/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = 220/SCREEN_WIDTH;
    CGFloat height = 220/SCREEN_HEIGHT;
    ///top 与 left 互换  width 与 height 互换
    [output setRectOfInterest:CGRectMake(top,left, height, width)];
    // 4. 添加拍摄会话
    // 4.1 实例化拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 4.2 添加会话输入
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    // 4.3 添加会话输出
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    // 4.3 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,
                                     AVMetadataObjectTypeEAN13Code,
                                     AVMetadataObjectTypeEAN8Code,
                                     AVMetadataObjectTypeCode128Code]];
    
    self.session = session;
    
    // 5. 视频预览图层,扫描画面
    // 5.1 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = self.layer.bounds;
    // 5.2 将图层插入当前视图
    [self.layer insertSublayer:preview atIndex:100];
    
    self.previewLayer = preview;
    
    // 6. 配置扫描view
    [self configView];
    
    //
    [self configTipLabel];
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    [self stopScan];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(QRScannerOutput:didOutputMetadataObjects:fromConnection:)]) {
        [self.delegate QRScannerOutput:captureOutput didOutputMetadataObjects:metadataObjects fromConnection:connection];
    }
    
}




-(void)configView{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"Scanner.bundle/pick_bg"];
    [self addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    
    self.line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 220, 2)];
    self.line.image = [UIImage imageNamed:@"Scanner.bundle/line.png"];
    [self addSubview:self.line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self setCropRect:kScanRect];//扫描区域
}
-(void)animation1{
    if (upOrdown == NO) {
        num++;
        self.line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (2*num == 200) {
            upOrdown = YES;
        }
    }
    else {
        num--;
        self.line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}
- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.bounds);
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    [cropLayer setNeedsDisplay];
    [self.layer addSublayer:cropLayer];
}


-(void)configTipLabel{
    if (!self.tipLabel) {
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.frame = CGRectMake(0, TOP+220, SCREEN_WIDTH, 50);
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.font = [UIFont systemFontOfSize:16];
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.text = @"将二维码／条形码放入框内，即可自动扫描";
        [self addSubview:self.tipLabel];
    }
}


//开启手电筒
-(void)turnOnTorch{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
}

//关闭手电筒
-(void)turnOffTorch{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

//自动
-(void)turnOffOrTurnOnTorch{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (device.torchMode == AVCaptureTorchModeOff) {
            [device setTorchMode: AVCaptureTorchModeOn];
        }
        else{
            [device setTorchMode: AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
    
}



@end

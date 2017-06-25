//
//  QRCodeCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/26.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "QRCodeCtrl.h"

@interface QRCodeCtrl ()

@property(strong,nonatomic)UIImageView *QRImageView;
@property(strong,nonatomic)QRScanner *QRScanner;

@end

@implementation QRCodeCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}


/**
 初始化视图
 */
-(void)initUI{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    if ([self.moduleCode isEqualToString:@"QRCode_production"]) {
        [self QRCode_production];
    }
    else if ([self.moduleCode isEqualToString:@"QRCode_scanner"]){
        [self QRCode_scanner];
    }
    
}










/**
 生成二维码
 */
-(void)QRCode_production{
    NSString *urlString = @"www.baidu.com";
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    UIImage *QRImage = [UIImage imageOfQRFromData:data red:245 green:90 blue:93 insertImage:[UIImage imageNamed:@"icon"] roundRadius:10 codeSize:200];
    self.QRImageView.image = QRImage;
    [self.view addSubview:self.QRImageView];
}

/**
 QR图片视图

 @return nil
 */
-(UIImageView *)QRImageView{
    if (_QRImageView==nil) {
        _QRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _QRImageView.center = self.view.center;
    }
    return _QRImageView;
}















/**
 扫描二维码
 */
-(void)QRCode_scanner{
    [self.view addSubview:self.QRScanner];
    [self.QRScanner startScan];
    
    //创建一个右边按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-20, 25, 30, 30)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"Scanner.bundle/torchoff"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:rightBtn];
}

-(void)clickRightButton:(UIButton*)btn{
    [self.QRScanner turnOffOrTurnOnTorch];
    if (btn.tag==0) {
        [btn setBackgroundImage:[UIImage imageNamed:@"Scanner.bundle/torchon"] forState:UIControlStateNormal];
        btn.tag=1;
    }
    else{
        [btn setBackgroundImage:[UIImage imageNamed:@"Scanner.bundle/torchoff"] forState:UIControlStateNormal];
        btn.tag=0;
    }
}

#pragma mark - 扫描代理
-(void)QRScannerOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    DLog(@"%@", metadataObjects);
    // 设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:obj.stringValue preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.QRScanner startScan];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        DLog(@"无扫描信息");
        return;
    }
    
}



/**
 扫描器

 @return nil
 */
-(QRScanner *)QRScanner{
    if (_QRScanner==nil) {
        _QRScanner = [[QRScanner alloc] init];
        _QRScanner.delegate = self;
    }
    return _QRScanner;
}






















-(void)dealloc{
    DLog(@"QRCodeCtrl dealloc !!");
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

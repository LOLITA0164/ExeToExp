//
//  SpeechRecognitionViewController.m
//  multiPurposeDemo
//
//  Created by LOLITA on 17/1/17.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "SpeechRecognitionCtrl.h"
#import "AudioManager.h"
#import <Speech/Speech.h>//语音识别

@interface SpeechRecognitionCtrl ()<SFSpeechRecognizerDelegate>

@property(strong,nonatomic)UITextView *contentView;
@property(strong,nonatomic)UIButton *tapBtn;
@property(strong,nonatomic)UIView *speekView;
@property(strong,nonatomic)AudioManager *AManager;
@property(strong,nonatomic)UIImageView *volumeImageView;//音量

@end

@implementation SpeechRecognitionCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    [self initView];
}




-(void)initView{
    
    //内容
    if (!_contentView) {
        _contentView = [[UITextView alloc] initWithFrame:CGRectMake(10, NavBar_HEIGHT+10, kScreenWidth-10*2, kScreenHeight/3.0)];
        _contentView.textColor = RandColor;
        _contentView.font = [UIFont systemFontOfSize:sizeNormal];
        _contentView.textAlignment = NSTextAlignmentCenter;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentView];
    }
    
    //按钮
    if (!_tapBtn) {
        _tapBtn = [UIButton buttonNormalWithTitle:@"按住说话" target:nil selector:nil frame:CGRectMake(0, 0, kScreenWidth/4.0, kScreenWidth/4.0) bgImage:nil imagePressed:nil textColor:RandColor textFont:[UIFont systemFontOfSize:sizeNormal]];
        _tapBtn.center = CGPointMake(self.view.center.x, (kScreenHeight-_contentView.frame.origin.y-_contentView.frame.size.height-49)/2.0+_contentView.frame.origin.y+_contentView.frame.size.height);
        _tapBtn.layer.borderWidth = 1;
        _tapBtn.layer.borderColor = _tapBtn.titleLabel.textColor.CGColor;
        _tapBtn.layer.cornerRadius = _tapBtn.frame.size.height/2.0;
        _tapBtn.layer.masksToBounds = YES;
        [_tapBtn addTarget:self action:@selector(TouchDown) forControlEvents:UIControlEventTouchDown];//按下去
        [_tapBtn addTarget:self action:@selector(TouchUpInside) forControlEvents:UIControlEventTouchUpInside];//控件内部抬起
        [_tapBtn addTarget:self action:@selector(TouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];//控件外部抬起
        [_tapBtn addTarget:self action:@selector(TouchDragExit) forControlEvents:UIControlEventTouchDragExit];//从内部触摸移动到外部
        [_tapBtn addTarget:self action:@selector(TouchDragEnter) forControlEvents:UIControlEventTouchDragEnter];//从外部移动到内部
        
        [self.view addSubview:_tapBtn];
    }
    
    
    self.AManager = [AudioManager sharedInstance];
    WS(ws);
    self.AManager.audioPowerChange = ^(CGFloat power){
        CGFloat newPower = power-100;
        NSInteger volumeLevel = ceil(newPower/10);
        ws.volumeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Audio.bundle/v%ld",(long)volumeLevel]];
    };
    self.AManager.audioRecorderDidFinishRecording = ^(AVAudioRecorder *recorder,BOOL successfullyFlag){
        if (!successfullyFlag) {
            return ;
        }
        //解析语音
        [ws.AManager speechRecognitionWithUrl:[ws.AManager recordAudioFile]];
        
    };
    
    self.AManager.audioSpeechRecognition = ^(SFSpeechRecognitionResult * result, NSError * error){
        if ([error.localizedDescription isEqualToString:@"Retry"]) {//重试
            ws.contentView.text = [NSString stringWithFormat:@"%@\n%@",ws.contentView.text,@"重试"];
        }
        else if (!error){
            ws.contentView.text = [NSString stringWithFormat:@"%@\n%@",ws.contentView.text,result.bestTranscription.formattedString];
        }
        else{
            DLog(@"解析出错:%@",error);
        }
    };
    
}


-(void)TouchDown{
    [_tapBtn setTitle:@"松开确定" forState:UIControlStateNormal];
    [_tapBtn setTitleColor:RandColor forState:UIControlStateNormal];
    _tapBtn.layer.borderColor = _tapBtn.titleLabel.textColor.CGColor;
    
    //显示图例
    [self showSpeekView];
    
    //开始录音
    [self.AManager startRecord];
    
}
-(void)TouchUpInside{
    [_tapBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [_tapBtn setTitleColor:RandColor forState:UIControlStateNormal];
    _tapBtn.layer.borderColor = _tapBtn.titleLabel.textColor.CGColor;
    
    //隐藏SpeekView
    [self hideSpeekView];
    
    //停止录制
    [self.AManager stopRecord];
    
}
-(void)TouchUpOutside{
    [_tapBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [_tapBtn setTitleColor:RandColor forState:UIControlStateNormal];
    _tapBtn.layer.borderColor = _tapBtn.titleLabel.textColor.CGColor;
    
    //隐藏SpeekView
    [self hideSpeekView];
    
    //停止录制
    [self.AManager pauseRecord];
    
}
-(void)TouchDragExit{
    [_tapBtn setTitle:@"松手取消" forState:UIControlStateNormal];
}
-(void)TouchDragEnter{
    [_tapBtn setTitle:@"松开确定" forState:UIControlStateNormal];
}




-(void)showSpeekView{
    
    //背景视图
    if (!_speekView) {
        _speekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, kScreenWidth/2.0)];
        _speekView.center = self.view.center;
        _speekView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
        _speekView.layer.cornerRadius = 10;
        _speekView.layer.masksToBounds = YES;
        [self.view addSubview:_speekView];
    }
    if (_speekView.hidden) {
        [_speekView setHidden:NO];
    }
    
    //麦克风和声量
    CGFloat speekViewHeight = _speekView.frame.size.height;
    CGFloat speekViewWidth = _speekView.frame.size.width;
    UIImageView *microphoneImageView;
    if (!microphoneImageView) {
        microphoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, speekViewWidth/3.0, speekViewHeight/2.0)];
        microphoneImageView.center = CGPointMake(speekViewWidth/3.0, speekViewHeight/2.0);
        microphoneImageView.image = [UIImage imageNamed:@"Audio.bundle/recorder"];
        [_speekView addSubview:microphoneImageView];
    }
    if (!_volumeImageView) {
        _volumeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, speekViewWidth/3.0, speekViewHeight/2.0)];
        _volumeImageView.center = CGPointMake(speekViewWidth*2/3.0, speekViewHeight/2.0);
        _volumeImageView.image = [UIImage imageNamed:@"Audio.bundle/v0"];
        [_speekView addSubview:_volumeImageView];
    }
    

}

-(void)hideSpeekView{
    if (!_speekView.hidden) {
        [_speekView setHidden:YES];
    }
}




/**
 语音识别

 @param url 音频地址
 */
-(void)speechRecognitionWithUrl:(NSURL*)url{
    //1.创建本地化标识符
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //2.创建一个语音识别对象
    SFSpeechRecognizer *sf = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    sf.delegate = self;
    //3.将语音资源传递给request对象
    SFSpeechURLRecognitionRequest *res = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
    //4.发送语音请求
    __weak __typeof(self) weakself=self;
    __block BOOL isFirst = YES;
    [sf recognitionTaskWithRequest:res resultHandler:^(SFSpeechRecognitionResult * result, NSError * error) {
        if (error!=nil){
            DLog(@"解析出错:%@",error.localizedDescription);
        }
        else{
            NSString *resultString = result.bestTranscription.formattedString;
            if (isFirst) {
                isFirst = NO;
                DLog(@"解析结果为:%@",resultString);
                weakself.contentView.text = [NSString stringWithFormat:@"%@\n%@",weakself.contentView.text,resultString];
            }
        }
    }];

}



-(void)dealloc{
    DLog(@"SpeechRecognitionCtrl dealloc!");
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

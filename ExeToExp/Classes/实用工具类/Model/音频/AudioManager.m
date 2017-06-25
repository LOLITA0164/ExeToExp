//
//  AudioManager.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/28.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "AudioManager.h"

@implementation AudioManager

+(instancetype)sharedInstance{
    static AudioManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AudioManager alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    [self setupRecorder];
    return self;
}

-(void)setupRecorder{
    //设置音频会话
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //录音设置
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
        }
    }
    
    //语音播放
    if (!_audioPlayer) {
        NSURL *url = [self getSavePath];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
        }
    }

    
}

/**
 获取录音保存路径

 @return nil
 */
-(NSURL*)getSavePath{
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 录音设置

 @return nil
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //录音格式
    [dic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //采样率，8000是电话采样率
    [dic setObject:@(8000) forKey:AVSampleRateKey];
    //通道，这里是单声道
    [dic setObject:@(1) forKey:AVNumberOfChannelsKey];
    //采样点位数，分为8、16、24、32
    [dic setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dic;
}


/**
 开始录制
 */
-(void)startRecord{
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
    }
}

/**
 暂停录制
 */
-(void)pauseRecord{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
}

/**
 恢复录制
 */
-(void)resumeRecord{
    [self startRecord];
}

/**
 停止录制
 */
-(void)stopRecord{
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
}



/**
 返回音频文件地址
 
 @return 音频文件地址
 */
-(NSURL *)recordAudioFile{
    return [self getSavePath];
}





/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(powerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}
/**
 *  录音声波状态设置
 */
-(void)powerChange{
    [self.audioRecorder updateMeters];//更新测量值
    float power = [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress = power+160.0;
    NSLog(@"%f",progress);
    if (self.audioPowerChange) {
        self.audioPowerChange(progress);
    }
}



/**
 播放音频文件
 */
-(void)playAudio{
    if (![_audioPlayer isPlaying]) {
        //解决音量小的问题
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
        [_audioPlayer play];
    }
}



#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (self.audioRecorderDidFinishRecording) {
        self.audioRecorderDidFinishRecording(recorder,flag);
    }
    NSLog(@"录制完成!");
}



/**
 获取语音时长
 
 @param audioUrl 语音的文件地址
 @return 时长
 */
-(float)durationWithAudio:(NSURL *)audioUrl{
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
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
    [sf recognitionTaskWithRequest:res resultHandler:^(SFSpeechRecognitionResult * result, NSError * error) {
        if (self.audioSpeechRecognition) {
            self.audioSpeechRecognition(result,error);
        }
    }];
    
}





@end

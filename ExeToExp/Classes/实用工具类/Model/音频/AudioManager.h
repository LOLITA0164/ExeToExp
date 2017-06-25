//
//  AudioManager.h
//  ExeToExp
//
//  Created by LOLITA on 17/3/28.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>//语音识别
#define kRecordAudioFile @"myRecord.caf"
//需要添加AudioToolbox框架
@interface AudioManager : NSObject<AVAudioRecorderDelegate,SFSpeechRecognizerDelegate>
/**
 录音机
 */
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;

/**
 音频播放器
 */
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

/**
 录音声波监控
 */
@property (nonatomic,strong) NSTimer *timer;


@property (nonatomic,copy) void (^audioRecorderDidFinishRecording)(AVAudioRecorder *recorder,BOOL successfullyFlag);

@property (nonatomic,copy) void (^audioPowerChange)(CGFloat power);

@property (nonatomic,copy) void (^audioSpeechRecognition)(SFSpeechRecognitionResult * result, NSError * error);


+(instancetype)sharedInstance;


/**
 开始录制
 */
-(void)startRecord;

/**
 暂停录制
 */
-(void)pauseRecord;

/**
 恢复录制
 */
-(void)resumeRecord;

/**
 停止录制
 */
-(void)stopRecord;

/**
 录制文件路径
 
 @return 录制文件路径
 */
-(NSURL*)recordAudioFile;

/**
 播放语音
 */
-(void)playAudio;


/**
 获取语音时长
 
 @param audioUrl 语音地址
 @return 语音时长
 */
-(float)durationWithAudio:(NSURL *)audioUrl;

/**
 语音识别
 
 @param url 语音地址
 */
-(void)speechRecognitionWithUrl:(NSURL*)url;


@end

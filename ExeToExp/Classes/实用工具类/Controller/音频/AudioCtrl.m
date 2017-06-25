//
//  AudioCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/26.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "AudioCtrl.h"

@interface AudioCtrl ()

@property (strong, nonatomic) UIButton *record;//开始录音
@property (strong, nonatomic) UIButton *stop;//停止录音
@property (strong, nonatomic) UIButton *play;//播放录音
@property (strong, nonatomic) UIProgressView *audioPower;//音频波动
@property (strong,nonatomic) AudioManager *ARManager;


@end

@implementation AudioCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ChooseWay];
}


/**
 选择对应方法
 */
-(void)ChooseWay{
    
    if ([self.moduleCode isEqualToString:@"audio_system"]) {
        [self audio_system];
    }
    else if ([self.moduleCode isEqualToString:@"audio_yinxiao"]){
        UIButton *playBtn = [UIButton buttonNormalWithTitle:@"click" target:self selector:@selector(playSound) frame:CGRectMake(0, 0, kScreenWidth, kScreenWidth) bgImage:nil imagePressed:nil textColor:RandColor textFont:[UIFont systemFontOfSize:sizeNormal]];
        [self.view addSubview:playBtn];
        playBtn.center = self.view.center;
    }
    else if ([self.moduleCode isEqualToString:@"audio_record"]){
        [self audio_record];
    }
    
}





#pragma mark - 系统音效
/**
 系统音效
 */
-(void)audio_system{
    [SystemSound accessSystemSoundsList];
    self.data = [SystemSound systemSounds];
    [self.view addSubview:self.table];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"soundCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [defaultSelectedColor colorWithAlphaComponent:0.1];
        cell.selectedBackgroundView = view;
    }
    SoundInfomation *si = self.data[indexPath.row];
    cell.textLabel.text = si.soundName?si.soundName:@"-";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",(unsigned int)si.soundID];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [SystemSound playWithSound:self.data[indexPath.row]];
}












#pragma mark - 播放自定义音效
/**
 播放自定义音效
 */
-(void)playSound{
    [self playAudioWithName:@"ok.wav"];
}
/**
 播放音效
 
 @param soundName 音效名称
 */
-(void)playAudioWithName:(NSString*)soundName{
    
    NSURL* system_sound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundName ofType:nil]];
    
    //1.获取系统声音ID
    SystemSoundID system_sound_id = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)system_sound_url,&system_sound_id);
    //需要播放完成之后执行某些操作，可以调用下面方法注册一个播放完成回调函数
/*    AudioServicesAddSystemSoundCompletion(system_sound_id,
                                          NULL, // uses the main run loop
                                          NULL, // uses kCFRunLoopDefaultMode
                                          soundCompleteCallback, // the name of our custom callback function
                                          NULL // for user data, but we don't need to do that in this case, so we just pass NULL
                                          );
*/
    //2.播放音频
//    AudioServicesPlaySystemSound(system_sound_id);//播放音效
    AudioServicesPlayAlertSound(system_sound_id);//播放并震动
    
}
/*
 void soundCompleteCallback(SystemSoundID soundID,void * userData){
 DLog(@"播放完成");
 //do what you want to do
 AudioServicesDisposeSystemSoundID(soundID);
 }
 */






#pragma mark - 录音
-(void)audio_record{
    [self.view addSubview:self.audioPower];
    
    self.ARManager = [AudioManager sharedInstance];
    WS(ws);
    //录制的分贝
    self.ARManager.audioPowerChange = ^(CGFloat power){
        CGFloat progress = (1/160.0)*power;
        [ws.audioPower setProgress:progress animated:YES];
    };
    //定制录制
    self.ARManager.audioRecorderDidFinishRecording = ^(AVAudioRecorder *recorder,BOOL successfullyFlag){
        if (successfullyFlag) {
            [ws.ARManager playAudio];
        }
    };
    
    [self.view addSubview:self.play];
    [self.view addSubview:self.stop];
    [self.view addSubview:self.record];
    
}
-(UIProgressView *)audioPower{
    if (_audioPower==nil) {
        _audioPower = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _audioPower.frame = CGRectMake(0, 0, kScreenWidth-20*2, 2);
        _audioPower.center = self.view.center;
        _audioPower.trackTintColor = [UIColor whiteColor];
        _audioPower.progressTintColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    }
    return _audioPower;
}
-(UIButton *)record{
    if (_record==nil) {
        _record = [UIButton buttonNormalWithTitle:@"开始"
                                               target:self
                                             selector:@selector(recordClick:)
                                                frame:CGRectMake(0, 0, kScreenWidth/8.0, kScreenWidth/8.0)
                                              bgImage:nil
                                         imagePressed:nil
                                            textColor:RandColor
                                             textFont:[UIFont systemFontOfSize:sizeNormal]];
        _record.center = CGPointMake(kScreenWidth*1/3.0, kScreenHeight*0.8);
    }
    return _record;
}
-(UIButton *)stop{
    if (_stop==nil) {
        _stop = [UIButton buttonNormalWithTitle:@"停止"
                                             target:self
                                           selector:@selector(stopClick:)
                                              frame:CGRectMake(0, 0, kScreenWidth/8.0, kScreenWidth/8.0)
                                            bgImage:nil
                                       imagePressed:nil
                                          textColor:RandColor
                                           textFont:[UIFont systemFontOfSize:sizeNormal]];
        _stop.center = CGPointMake(kScreenWidth*2/3.0, kScreenHeight*0.8);;
    }
    return _stop;
}
-(UIButton *)play{
    if (_play==nil) {
        _play = [UIButton buttonNormalWithTitle:@"播放"
                                             target:self
                                           selector:@selector(playClick:)
                                              frame:CGRectMake(0, 0, kScreenWidth/8.0, kScreenWidth/8.0)
                                            bgImage:nil
                                       imagePressed:nil
                                          textColor:RandColor
                                           textFont:[UIFont systemFontOfSize:sizeNormal]];
        _play.center = CGPointMake(self.view.center.x, kScreenHeight*0.3);
    }
    return _play;
}
- (void)recordClick:(UIButton *)sender {
    [self.ARManager startRecord];
}
- (void)stopClick:(UIButton *)sender {
    [self.ARManager stopRecord];
}
- (void)playClick:(UIButton *)sender {
    [self.ARManager playAudio];
}



-(void)dealloc{
    DLog(@"AudioCtrl dealloc!");
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

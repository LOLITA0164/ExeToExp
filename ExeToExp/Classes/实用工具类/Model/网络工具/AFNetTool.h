//
//  AFNetTool.h
//  multiPurposeDemo
//
//  Created by LOLITA on 17/3/2.
//  Copyright © 2017年 LOLITA. All rights reserved.
//


#define kCheckUpdateUrlFormatString @"http://itunes.apple.com/lookup?bundleId=%@"



typedef enum : NSUInteger {
    GET,
    POST,
} HttpRequestType;




#import <Foundation/Foundation.h>
#import "AFNetworking.h"


/************请求、下载、网络判断************/
@interface AFNetTool : NSObject

@property(nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)NSURLSessionDataTask *task;


/**
 无多媒体的请求

 @param URLString 地址字符串
 @param parameters 参数,可为空
 @param type 请求类型GET/POST
 @param succeedCallBack 成功回调
 @param failureCallBack 失败回调
 */
-(void)requestURLString:(NSString*)URLString parameters:(id)parameters httpRequestType:(HttpRequestType)type succeed:(void(^)(id responseObject))succeedCallBack failure:(void(^)(NSError *error))failureCallBack;




/**
 多媒体的请求

 @param URLString 地址字符串
 @param parameters 参数
 @param imgs 图片数组
 @param videos 视频数组
 @param fileName 服务器中的文件夹名字
 @param uploadPro 上传进度
 @param succeedCallBack 成功回调
 @param failureCallBack 失败回调
 */
-(void)requestURLString:(NSString*)URLString parameters:(id)parameters images:(NSArray*)imgs videos:(NSArray*)videos fileName:(NSString*)fileName uploadProgress:(void (^)(NSProgress * uploadPro))uploadPro succeed:(void(^)(id responseObject))succeedCallBack failure:(void(^)(NSError *error))failureCallBack;



/**
 取消当前的请求
 */
-(void)cancelCurrentRequest;





/**
 获取网络连接状态

 @param statusCallBack 结果回调
 */
-(void)currentNetStatus:(void(^)(BOOL isConnect,AFNetworkReachabilityStatus currentStatus))statusCallBack;



/**
 检查当前是否有网络

 @return YES／NO
 */
+(BOOL)checkNetWork;





/**
 检测是否需要更新，回调为nil，则自动处理

 @param callBack 结果回调
 */
-(void)checkSystemIfNeedUpdate:(void(^)(BOOL isNeed,NSString *updateURLString,NSString *descriptionString,NSDictionary *resDict))callBack;






/**
 下载文件

 @param URLString 文件地址
 @param uploadPro 下载进度
 @param completionHandler 完成回调
 */
-(void)downFileURLString:(NSString*)URLString uploadProgress:(void (^)(NSProgress * uploadPro))uploadPro completionHandler:(void (^)(NSURL *filePath,NSError *error))completionHandler;

/**
 暂停下载
 */
-(void)suspendDownloadTask;

/**
 继续下载
 */
-(void)restartDownloadTask;

/**
 取消下载
 */
-(void)cancelDownloadTask;



@end

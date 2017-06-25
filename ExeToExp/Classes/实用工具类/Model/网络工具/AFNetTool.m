//
//  AFNetTool.m
//  multiPurposeDemo
//
//  Created by LOLITA on 17/3/2.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "AFNetTool.h"

@implementation AFNetTool
{
    // 下载句柄
    NSURLSessionDownloadTask *downloadTask;
}

#pragma mark - 不带多媒体的请求
-(void)requestURLString:(NSString *)URLString parameters:(id)parameters httpRequestType:(HttpRequestType)type succeed:(void (^)(id))succeedCallBack failure:(void (^)(NSError *))failureCallBack{
    
    //判断网络
    if (![self checkNetWorkPrivate]) {
        NSLog(@"没有网络");
    }
    
    //如果没有地址则return
    if (!URLString||[URLString isEqualToString:@""]) {
        return;
    }
    //地址进行UTF8转换，因为地址中可能包含中文
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //创建网络请求管理对象
    _manager = [AFHTTPSessionManager manager];
    //声明请求的数据类型是json类型
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //请求超时时间
    _manager.requestSerializer.timeoutInterval = 20;
    //同一时间接受的请求数量
    _manager.operationQueue.maxConcurrentOperationCount = 10;
    //声明返回的结果类型为json类型
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果接受类型不一致时，替换为text／html等类型
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json",@"text/javascript", nil];
    switch (type) {
        case GET:
        {
            _task = [_manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (succeedCallBack) {
                    succeedCallBack(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureCallBack) {
                    failureCallBack(error);
                }
            }];
        }
            break;
        case POST:
        {
            _task = [_manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (succeedCallBack) {
                    succeedCallBack(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureCallBack) {
                    failureCallBack(error);
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
    
}



#pragma mark - 带多媒体的请求
-(void)requestURLString:(NSString *)URLString parameters:(id)parameters images:(NSArray *)imgs videos:(NSArray *)videos fileName:(NSString *)fileName uploadProgress:(void (^)(NSProgress *))uploadPro succeed:(void (^)(id))succeedCallBack failure:(void (^)(NSError *))failureCallBack{
    
    //判断网络
    /******/
    if (![self checkNetWorkPrivate]) {
        NSLog(@"没有网络");
    }
    
    //如果没有地址则return
    if (!URLString||[URLString isEqualToString:@""]) {
        return;
    }
    //地址进行UTF8转换，因为地址中可能包含中文
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //创建网络请求管理对象
    _manager = [AFHTTPSessionManager manager];
    //声明请求的数据类型是json类型
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //请求超时时间
    _manager.requestSerializer.timeoutInterval = 20;
    //同一时间接受的请求数量
    _manager.operationQueue.maxConcurrentOperationCount = 10;
    //声明返回的结果类型为json类型
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //如果接受类型不一致时，替换为text／html等类型
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json",@"text/javascript", nil];
    
    _task = [_manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //处理图片
        if (imgs&&imgs.count) {
            for (UIImage *image in imgs) {
                NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
                NSString *dateString = [format stringFromDate:[NSDate date]];
                NSString *imgName = [NSString stringWithFormat:@"%@.jpg",dateString];
                //将数据拼接起来
                [formData appendPartWithFileData:imgData name:fileName fileName:imgName mimeType:@"image/jpeg"];
            }
        }
        //处理视频
        if (videos&&videos.count) {
            for (NSData *data in videos) {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
                NSString *dateString = [format stringFromDate:[NSDate date]];
                NSString *videoName = [NSString stringWithFormat:@"%@.MOV",dateString];
                //将数据拼接起来
                [formData appendPartWithFileData:data name:fileName fileName:videoName mimeType:@"media"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgress) {
            uploadPro(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (succeedCallBack) {
            succeedCallBack(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureCallBack) {
            failureCallBack(error);
        }
    }];
    
}


#pragma mark - 取消当前的请求
-(void)cancelCurrentRequest{
    [_task cancel];
}


#pragma mark - 判断网络状态
-(void)currentNetStatus:(void (^)(BOOL, AFNetworkReachabilityStatus))statusCallBack{
    __block BOOL isConnect = YES;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开始监控
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                isConnect = NO;
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            {
                isConnect = NO;
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                isConnect = YES;
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                isConnect = YES;
            }
                break;
                
            default:
                break;
        }
        statusCallBack(isConnect,status);
    }];
}


#pragma makr - 私有方法
-(BOOL)checkNetWorkPrivate{
    return [AFNetTool checkNetWork];
}



#pragma mark - 检查当前是否有网络
+(BOOL)checkNetWork{
    //不能掉用实例方法
//    [self checkNetWorkPrivate];
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? YES : NO;
    return isNetworkEnable;
}



#pragma mark - //类方法调用不了其他的实例方法
-(void)checkSystemIfNeedUpdate:(void (^)(BOOL, NSString *, NSString *, NSDictionary *))callBack{
    //获取本地应用信息
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdetifierString = [infoDict objectForKey:@"CFBundleIdentifier"];
    bundleIdetifierString = [bundleIdetifierString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* urlString = [NSString stringWithFormat:kCheckUpdateUrlFormatString, bundleIdetifierString];
    //临时替换
    urlString = [NSString stringWithFormat:kCheckUpdateUrlFormatString, @"com.istrong.xlqfxt"];

    
    [self requestURLString:urlString parameters:nil httpRequestType:GET succeed:^(id responseObject) {

        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        
        NSArray *resArray = [responseObject objectForKey:@"results"];
        
        if (resArray.count) {
            
            NSDictionary *resDict = [resArray firstObject];
            NSString* releaseNoteString = [resDict objectForKey:@"releaseNotes"];
            //appStore上版本
            NSString* newVersionString = [resDict objectForKey:@"version"];
            
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            //本地版本
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            //更新地址
            NSString *applicationUrlString = [resDict objectForKey:@"trackViewUrl"];
            if([newVersionString compare:currentVersion options:NSNumericSearch] == NSOrderedDescending)
            {
                //可以将查询结果回调或者直接处理
                if (callBack) {//如果有需要block
                    callBack(YES,applicationUrlString,releaseNoteString,resDict);
                }
                else{
                    //NSObject的子类上使用delegate在ARC模式下是访问不到的，因为show完之后就被释放掉了
                    //这里使用另一种思路
                    UIViewController *viewC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"新版本号%@", newVersionString] message:[NSString stringWithFormat:@"%@", releaseNoteString] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *sureAcion = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        
                        UIApplication *application = [UIApplication sharedApplication];
                        [application openURL:[NSURL URLWithString:applicationUrlString]];
                        
                    } ];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:cancelAction];
                    [alertController addAction:sureAcion];
                    [viewC presentViewController:alertController animated:YES completion:nil];
                }
            }
            else{
                //不需要更新
                if (callBack) {
                    callBack(NO,nil,nil,nil);
                }
            }
        }
        else{
            if (callBack) {
                callBack(NO,nil,@"AppStore未找到该应用信息",nil);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}



#pragma mark - 下载文件
-(void)downFileURLString:(NSString *)URLString uploadProgress:(void (^)(NSProgress *))uploadPro completionHandler:(void (^)(NSURL *, NSError *))completionHandler{
    
    //判断网络
    if (![self checkNetWorkPrivate]) {
        NSLog(@"没有网络");
        return;
    }
    
    //如果没有地址则return
    if (!URLString||[URLString isEqualToString:@""]) {
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //下载Task操作
    downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (uploadPro) {
            NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            uploadPro(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //返回文件的位置的路径URL
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(filePath,error);
        }
    }];
    [downloadTask resume];
    
}
#pragma mark - 暂停下载
-(void)suspendDownloadTask{
    [downloadTask suspend];
}
#pragma mark - 继续下载
-(void)restartDownloadTask{
    [downloadTask resume];
}
#pragma mark - 取消下载
-(void)cancelDownloadTask{
    [downloadTask cancel];
}





@end

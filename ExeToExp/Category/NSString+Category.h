//
//  NSString+Category.h
//  ExeToExp
//
//  Created by LOLITA on 17/4/1.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>//md5加密

@interface NSString (Category)

/**
 *  获取农历时间
 */
+(NSString*)getChineseCalendarWithDate:(NSDate*)date;

/**
 *  获取日期格式为:2016-09-09 20:44:23 需要传入符号,默认为年月日
 */
+(NSString*)getFormateTimeStringFromNSDateAll:(NSDate*)theDate withSignString:(NSString*)signString;

/**
 *  获取日期格式为:2016-9-9 20:44:23 需要传入符号,默认为年月日
 */
+(NSString*)getFormateTimeStringFromNSDateAll2:(NSDate*)theDate withSignString:(NSString*)signString;

/**
 *  获取日期格式为:2016-09-09 需要传入符号,默认为年月日
 */
+(NSString*)getFormateDateStringFormNSDate:(NSDate*)theDate withSignString:(NSString*)signString;

/**
 *  获取日期格式为:2016-9-9 需要传入符号,默认为年月日
 */
+(NSString*)getFormateDateStringFormNSDate2:(NSDate*)theDate withSignString:(NSString*)signString;

/**
 *  获取时间格式为:10:45:39
 */
+(NSString*)getFormateTimeStringFromNSDate:(NSDate *)theDate;

/**
 *  获取时间格式为:10:45
 */
+(NSString *)getFormateTimeStringFromNSDate2:(NSDate *)theDate;
/**
 *  md5加密
 */
+(NSString *)md5HexDigest:(NSString *)input;

/**
 base64加密
 
 @param text nil
 @return nil
 */
+(NSString *)base64StringFromText:(NSString *)text;


/**
 获取调整时间

 @param beginTimeStr 开始时间
 @param endTimeStr 结束时间
 @param point 分隔时间点
 */
+(void)adjustSearchTimeToEightFromCurrentTime:(NSString**)beginTimeStr endTime:(NSString**)endTimeStr withTimePoint:(NSInteger)point;




@end

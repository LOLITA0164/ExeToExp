//
//  NSString+Category.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/1.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "NSString+Category.h"


@implementation NSString (Category)


/**
 *  获取农历时间
 */
+(NSString *)getChineseCalendarWithDate:(NSDate *)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉", @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未", @"甲申", @"乙酉", @"丙戌", @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳", @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑", @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥", @"壬子", @"癸丑", @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月",
                            @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月", nil];
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"廿十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    //    NSLog(@"%ld-%ld-%ld",localeComp.year,localeComp.month,localeComp.day);
    
    NSString *yearStr = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *monthStr = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *dayStr = [chineseDays objectAtIndex:localeComp.day-1];
    NSString *chineseCalendarStr = [NSString stringWithFormat:@"%@年%@%@",yearStr,monthStr,dayStr];
    
    return chineseCalendarStr;
}

/**
 *  获取日期格式为:2016-11-09 20:44:23 需要传入符号,默认为年月日
 */
+(NSString *)getFormateTimeStringFromNSDateAll:(NSDate *)theDate withSignString:(NSString *)signString{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unitFlags fromDate:theDate];
    
    NSInteger year = [cmps year];
    NSInteger month = [cmps month];
    NSInteger day = [cmps day];
    NSInteger hour = [cmps hour];
    NSInteger minute = [cmps minute];
    NSInteger second = [cmps second];
    
    NSString *timeStringFromNSDateAll;
    
    if (signString) {
        
        timeStringFromNSDateAll = [NSString stringWithFormat:@"%ld%@%02ld%@%02ld %02ld:%02ld:%02ld",(long)year,signString,(long)month,signString,(long)day,(long)hour,(long)minute,(long)second];
    }else{
        
        timeStringFromNSDateAll = [NSString stringWithFormat:@"%ld年%02ld月%02ld日 %02ld:%02ld:%02ld",(long)year,(long)month,(long)day,(long)hour,(long)minute,(long)second];
    }
    
    return timeStringFromNSDateAll;
    
}
/**
 *  获取日期格式为:2016-11-9 20:44:23 需要传入符号,默认为年月日
 */
+(NSString *)getFormateTimeStringFromNSDateAll2:(NSDate *)theDate withSignString:(NSString *)signString{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unitFlags fromDate:theDate];
    
    NSInteger year = [cmps year];
    NSInteger month = [cmps month];
    NSInteger day = [cmps day];
    NSInteger hour = [cmps hour];
    NSInteger minute = [cmps minute];
    NSInteger second = [cmps second];
    
    NSString *timeStringFromNSDateAll;
    
    if (signString) {
        
        timeStringFromNSDateAll = [NSString stringWithFormat:@"%ld%@%ld%@%ld %02ld:%02ld:%02ld",(long)year,signString,(long)month,signString,(long)day,(long)hour,(long)minute,(long)second];
    }else{
        
        timeStringFromNSDateAll = [NSString stringWithFormat:@"%ld年%ld月%ld日 %02ld:%02ld:%02ld",(long)year,(long)month,(long)day,(long)hour,(long)minute,(long)second];
    }
    
    return timeStringFromNSDateAll;
    
}


/**
 *  获取日期格式为:2016-09-09 需要传入符号,默认为年月日
 */
+(NSString *)getFormateDateStringFormNSDate:(NSDate *)theDate withSignString:(NSString *)signString{
    
    NSString *dateString = [self getFormateTimeStringFromNSDateAll:theDate withSignString:signString];
    
    dateString = [dateString substringToIndex:dateString.length - 9];
    
    return dateString;
}

/**
 *  获取日期格式为:2016-9-9 需要传入符号,默认为年月日
 */
+(NSString *)getFormateDateStringFormNSDate2:(NSDate *)theDate withSignString:(NSString *)signString{
    
    NSString *dateString = [self getFormateTimeStringFromNSDateAll:theDate withSignString:signString];
    
    dateString = [dateString substringToIndex:dateString.length - 9];
    
    return dateString;
}

/**
 *  获取时间格式为:10:45:39 可传入其他符号，默认为":"
 */
+(NSString *)getFormateTimeStringFromNSDate:(NSDate *)theDate{
    
    NSString *timeString = [self getFormateTimeStringFromNSDateAll:theDate withSignString:nil];
    
    timeString = [timeString substringFromIndex:timeString.length - 8];
    
    return timeString;
}


/**
 *  获取时间格式为:10:45 可传入其他符号，默认为":"
 */
+(NSString *)getFormateTimeStringFromNSDate2:(NSDate *)theDate{
    
    NSString *timeString = [self getFormateTimeStringFromNSDate:theDate];
    
    timeString = [timeString substringToIndex:5];
    
    return timeString;
}


/**
 *  MD5加密
 */
+(NSString *)md5HexDigest:(NSString *)input{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


/**
 base64
 
 @param text nil
 @return nil
 */
+(NSString *)base64StringFromText:(NSString *)text
{
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}


/**
 获取调整时间
 
 @param beginTimeStr 开始时间
 @param endTimeStr 结束时间
 @param point 分隔时间点
 */
+(void)adjustSearchTimeToEightFromCurrentTime:(NSString**)beginTimeStr endTime:(NSString**)endTimeStr withTimePoint:(NSInteger)point
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    
    NSDateComponents* comps  = [calendar components:unitFlags fromDate:[NSDate date]];
    year = [comps year];
    month = [comps month];
    day = [comps day];
    hour = [comps hour];
    minute = [comps minute];
    
    *endTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:00", (long)year, (long)month, (long)day, (long)hour, (long)minute];
    
    if (!point) {
        point = 8;
    }
    
    if(hour>=12)
    {
        *beginTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:00:00", (long)year, (long)month, (long)day,point];
    }
    else
    {
        NSDate* preDate = [[NSDate date] dateByAddingTimeInterval:-24*3600];
        comps = [calendar components:unitFlags fromDate:preDate];
        year = [comps year];
        month = [comps month];
        day =[comps day];
        hour = [comps hour];
        
        *beginTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:00:00", (long)year, (long)month, (long)day,point];
    }
}

@end

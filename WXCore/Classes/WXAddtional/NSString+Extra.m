//
//  NSString+Extra.m
//  Roosher
//
//  Created by Levin on 10-9-27.
//  Copyright 2010 Roosher inc. All rights reserved.
//

#import "NSString+Extra.h"
#import "WXDefines.h"

@implementation NSString (Extra)


+ (NSString*)stringWithNewUUID {
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, uuidObj);
    NSString *result = (__bridge_transfer NSString *)CFStringCreateCopy(NULL, uuidString);
    CFRelease(uuidObj);
    CFRelease(uuidString);
    return result;
}

- (NSString *)URLEncodedString {
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (__bridge CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
	return result;
}

- (NSString*)URLDecodedString {
	NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
	return result;	
}

- (NSString*)stringByTrimmingBoth {
    NSString *trimmed = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmed;
}

- (NSString*)stringByTrimmingLeadingWhitespace {
    NSInteger i = 0;
    
    while ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}

+ (NSString*)formatYearMonthDayHourMinute:(NSTimeInterval)interval
{
    NSLog(@"interval:%f", interval);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

+ (NSString*)formatYearMonth:(NSTimeInterval)interval
{
    if (interval == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"yyyy.MM"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

+ (NSString*)formatYearMonthCN:(NSTimeInterval)interval
{
    if (interval == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"yyyy年M月"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

+ (NSString*)formatYearMonthDay:(NSTimeInterval)interval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

+ (NSString*)formatDay:(NSTimeInterval)interval
{
    if (interval == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

+ (NSString*)formatHourMinute:(NSTimeInterval)interval
{
    if (interval == 0) {
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: @"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}
- (CGSize)measureTextSize:(UIFont *)desFont desWidth:(CGFloat)desWidth
{
    CGSize size=CGSizeMake(0, 0);
    if (self.length < 1) {
        return size;
    }
    CGSize textSize = CGSizeMake(desWidth, 10000.0f);
    if (IOS_VERSION >= 7.0) {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        NSAttributedString * string = [[NSAttributedString alloc]initWithString:self attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:style}];
        size =  [string boundingRectWithSize:textSize options:
                 NSStringDrawingTruncatesLastVisibleLine |
                 NSStringDrawingUsesLineFragmentOrigin |
                 NSStringDrawingUsesFontLeading context:nil].size;
    }else{
        NSDictionary *attribute = @{NSFontAttributeName:desFont};
        size = (CGSize)[self boundingRectWithSize:textSize options:
                        NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin   |
                        NSStringDrawingUsesFontLeading
                                       attributes:attribute context:nil].size;
    }
    return size;

}
- (CGFloat)measureTextHeight:(UIFont *)desFont desWidth:(CGFloat)desWidth
{
    if (self==nil) {
        return 1.0f;
    }
    if (self.length < 1) {
        return 1.0f;
    }
    CGSize result = [self measureTextSize:desFont desWidth:desWidth];
    CGFloat height = ceil(result.height) + 1;
    return height;
}

//- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
//    CGSize fontSize = [self measureTextSize:font desWidth:size.width];
//    return fontSize;
//}

//- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
//    CGSize fontSize = [self measureTextSize:font desWidth:size.width];
//    return fontSize;
//}

- (NSString*)trimText
{
    if (self.length > 0) {
        NSCharacterSet* set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString* text = [self stringByTrimmingCharactersInSet:set];
        return text;
    }
    else {
        return self;
    }
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareCurrentTime:(NSString*) compareDate
//
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[compareDate intValue]];
    NSTimeInterval  timeInterval = [confromTimesp timeIntervalSinceNow];
    
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

-(NSString*)getEnUSTimeOut:(NSString*)time
{
    NSString* string = time;//@"20110826134106";
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    NSLog(@"date = %@", inputDate);//2011-08-26 05:41:06 +0000
    return string;
}
-(NSString*)getTimeOut:(NSString*)time
{
    //@"20110826134106";
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    NSDate* inputDate = [outputFormatter dateFromString:time];
    NSString *str = [outputFormatter stringFromDate:inputDate];
//    NSLog(@"testDate:%@", str);//2011年08月26日 13时41分06秒
    return str;
    
}
//获取当前系统的时间戳
+(long)getTimeSp{
    long time;
    NSDate *fromdate=[NSDate date];
    time=(long)[fromdate timeIntervalSince1970];
    return time;
}

//将时间戳转换成NSDate
+(NSDate *)changeSpToTime:(NSString*)spString{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    return confromTimesp;
}
//将时间戳转换成NSDate,加上时区偏移
+(NSDate*)zoneChange:(NSString*)spString{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
    NSDate *localeDate = [confromTimesp  dateByAddingTimeInterval: interval];
    return localeDate;
}
//比较给定NSDate与当前时间的时间差，返回相差的秒数
+(long)timeDifference:(NSDate *)date{
    NSDate *localeDate = [NSDate date];
    long difference =fabs([localeDate timeIntervalSinceDate:date]);
    return difference;
}
//将NSDate按yyyy-MM-dd HH:mm:ss格式时间输出
+(NSString*)nsdateToString:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}
//将yyyy-MM-dd HH:mm:ss格式时间转换成时间戳
+(long)changeTimeToTimeSp:(NSString *)timeStr{
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:timeStr];
    time= (long)[fromdate timeIntervalSince1970];
    return time;
}
+(long)changeDateToTimeSp:(NSString *)timeStr{
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *fromdate=[format dateFromString:timeStr];
    time= (long)[fromdate timeIntervalSince1970];
    return time;
}
//获取当前系统的yyyy-MM-dd HH:mm:ss格式时间
+(NSString *)getTime{
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}


//+(NSString *) jsonStringWithString:(NSString *) string{
//    return [NSString stringWithFormat:@"'%@'",[[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@""withString:@"'\'\'"]];
//}
//
//+(NSString *) jsonStringWithArray:(NSArray *)array{
//    NSMutableString *reString = [NSMutableString string];
//    [reString appendString:@"["];
//    NSMutableArray *values = [NSMutableArray array];
//    for (id valueObj in array) {
//        NSString *value = [NSString jsonStringWithObject:valueObj];
//        if (value) {
//            [values addObject:[NSString stringWithFormat:@"%@",value]];
//        }
//    }
//    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
//    [reString appendString:@"]"];
//    return reString;
//}

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}
+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}
+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}
+(NSString*)getTimestampForDate:(NSString*)timestamp
{//1490261503
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timestamp intValue]];
    NSString * confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    NSArray * timeList = [confromTimespStr componentsSeparatedByString:@" "];
    
    NSString * tremp = [timeList firstObject];
    
    return tremp;
}
+(NSString*)getTimestampForDateS:(NSString*)timestamp
{//1490261503
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timestamp intValue]];
    NSString * confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
//+(NSString *) jsonStringWithObject:(id) object{
//    NSString *value = nil;
//    if (!object) {
//        return value;
//    }
//    if ([object isKindOfClass:[NSString class]]) {
//        value = [NSString jsonStringWithString:object];
//    }else if([object isKindOfClass:[NSDictionary class]]){
//        value = [NSString jsonStringWithDictionary:object];
//    }else if([object isKindOfClass:[NSArray class]]){
//        value = [NSString jsonStringWithArray:object];
//    }
//    return value;
//}
//
//+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
//    NSArray *keys = [dictionary allKeys];
//    NSMutableString *reString = [NSMutableString string];
//    [reString appendString:@"{"];
//    NSMutableArray *keyValues = [NSMutableArray array];
//    for (int i=0; i<[keys count]; i++) {
//        NSString *name = [keys objectAtIndex:i];
//        id valueObj = [dictionary objectForKey:name];
//        NSString *value = [NSString jsonStringWithObject:valueObj];
//        if (value) {
//            [keyValues addObject:[NSString stringWithFormat:@"%@:%@",name,value]];
//        }
//    }
//    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
//    [reString appendString:@"}"];
//    return reString;
//}
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;

}

+ (NSString *)timeWithTimeIntervalMouthString:(NSString *)timeString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
}
+(BOOL) isPhoneNumber:(NSString *) phoneNumString{
    NSPredicate * pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[\\d][\\d]{9}$"];
    return [pred3 evaluateWithObject:phoneNumString];
}
@end

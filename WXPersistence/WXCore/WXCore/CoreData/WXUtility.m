//
//  WXUtility.m
//  WXCore
//
//  Created by 朱洪伟 on 15/6/30.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXUtility.h"
#import "AppDelegate.h"

#import <CommonCrypto/CommonDigest.h>
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import<CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>
#import <Foundation/Foundation.h>

#import <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#include <net/ethernet.h>
#include <AudioToolbox/AudioToolbox.h>

#import <AdSupport/ASIdentifierManager.h>


//普通动画延时
#define NORMAL_ANIMATION_DURATION  0.4

//=====================================================================


#pragma mark === Constants ===
#define kCharm_ID 21211  //charm官方ID

#define Dubbler_ID @"10000403"

#define didShowGuideKey  @"didShowGuide"


#define PMDefaultCountryCode @"001"
#define PMDefaultCountryName @"US"

#define kPMAppName              @"PhotoMe"
#define kPMCrashLogPath         @"CrashLog"
#define kPMNSLogPath			@"NSLog"
#define kPMStatisticLogPath     @"StatisticLog"
#define kPMCrashLogFileName     @"crashLog.txt"
#define kPMStatisticLogFileName @"statisticLog.plist"
#define kPMQACrashLogPath       @"qa"
#define kAlbumName @"Charm"

// 持久化目录名
#define kPMPersistantDataFolderName @"Data"
// 临时文件目录名
#define kPMTemporaryDataFolderName @"Temp"
// 自定义缓存数据目录名，存放假Feed, plist, caf
#define kPMCustomDataCacheFolderName @"CustomDataCache"
// 自定义缓存图片目录名
#define kPMCustomImageCacheFolderName @"CustomImageCache"

// mp3文件目录名
#define kPMMp3FileFolderName @"MP3"
// 优化卷轴视图在加载是后台发送请求的最大数目，提高滚动效率
#define PMNotificationOptimizationScrollSpeed @"PMNotificationOptimizationScrollSpeed"

// 系统共用常量
#define kPMUploadImageCompressionQuality 0.6

//chat 文本最大长度
#define maxLengthChatText 5000

//time 检查通讯录更新的时间间隔 目前是24小时
#define checkAddressBookModifyInterval 86400

//上传图片的最大值
#define  maxSizeOfImage 28000000
//chat 聊天上传图片最短边的最大值
#define imageMaxLength 960
//nickName 最大长度与最小长度
#define nameLengthMax 50
#define nameLengthMin 3
//fullName 最大长度与最小长度
#define fullNameLengthMax 60
#define fullNameLengthMin 1

/// 一些错误码
#define kNetworkErrorCode -10000

#define kRVImageNeedCircleMask @"circleMask"


@implementation WXUtility

// No-ops for non-retaining objects.
static const void* TTRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void TTReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

#define    min(a,b)    ((a) < (b) ? (a) : (b))
#define    max(a,b)    ((a) > (b) ? (a) : (b))

#define MAXADDRS    32
#define BUFFERSIZE    4000

char *if_names[MAXADDRS];
char *ip_names[MAXADDRS];
char *hw_addrs[MAXADDRS];
unsigned long ip_addrs[MAXADDRS];

static int   nextAddr = 0;

void InitAddresses()
{
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = hw_addrs[i] = NULL;
        ip_addrs[i] = 0;
    }
}

void FreeAddresses()
{
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if (if_names[i] != 0) free(if_names[i]);
        if (ip_names[i] != 0) free(ip_names[i]);
        if (hw_addrs[i] != 0) free(hw_addrs[i]);
        ip_addrs[i] = 0;
    }
    InitAddresses();
}

void GetIPAddresses()
{
    int                 i, len, flags;
    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifconf       ifc;
    struct ifreq        *ifr, ifrcopy;
    struct sockaddr_in    *sin;
    
    char temp[80];
    
    int sockfd;
    
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)
    {
        perror("ioctl error");
        return;
    }
    
    lastname[0] = 0;
    
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
    {
        ifr = (struct ifreq *)ptr;
        len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
        ptr += sizeof(ifr->ifr_name) + len;    // for next one in buffer
        
        if (ifr->ifr_addr.sa_family != AF_INET)
        {
            continue;    // ignore if not desired address family
        }
        
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)
        {
            *cptr = 0;        // replace colon will null
        }
        
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
        {
            continue;    /* already processed this interface */
        }
        
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
        
        ifrcopy = *ifr;
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
        flags = ifrcopy.ifr_flags;
        if ((flags & IFF_UP) == 0)
        {
            continue;    // ignore if interface not up
        }
        
        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);
        if (if_names[nextAddr] == NULL)
        {
            return;
        }
        strcpy(if_names[nextAddr], ifr->ifr_name);
        
        sin = (struct sockaddr_in *)&ifr->ifr_addr;
        strcpy(temp, inet_ntoa(sin->sin_addr));
        
        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);
        if (ip_names[nextAddr] == NULL)
        {
            return;
        }
        strcpy(ip_names[nextAddr], temp);
        
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
        
        ++nextAddr;
    }
    
    close(sockfd);
}

void GetHWAddresses()
{
    struct ifconf ifc;
    struct ifreq *ifr;
    int i, sockfd;
    char buffer[BUFFERSIZE], *cp, *cplim;
    char temp[80];
    
    for (i=0; i<MAXADDRS; ++i)
    {
        hw_addrs[i] = NULL;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, (char *)&ifc) < 0)
    {
        perror("ioctl error");
        close(sockfd);
        return;
    }
    
    ifr = ifc.ifc_req;
    
    cplim = buffer + ifc.ifc_len;
    
    for (cp=buffer; cp < cplim; )
    {
        ifr = (struct ifreq *)cp;
        if (ifr->ifr_addr.sa_family == AF_LINK)
        {
            struct sockaddr_dl *sdl = (struct sockaddr_dl *)&ifr->ifr_addr;
            int a,b,c,d,e,f;
            int i;
            
            strcpy(temp, (char *)ether_ntoa(ether_aton(LLADDR(sdl))));
            sscanf(temp, "%x:%x:%x:%x:%x:%x", &a, &b, &c, &d, &e, &f);
            sprintf(temp, "%02X:%02X:%02X:%02X:%02X:%02X",a,b,c,d,e,f);
            
            for (i=0; i<MAXADDRS; ++i)
            {
                if ((if_names[i] != NULL) && (strcmp(ifr->ifr_name,if_names[i]) == 0))
                {
                    if (hw_addrs[i] == NULL)
                    {
                        hw_addrs[i] = (char *)malloc(strlen(temp)+1);
                        strcpy(hw_addrs[i], temp);
                        break;
                    }
                }
            }
        }
        cp += sizeof(ifr->ifr_name) + max(sizeof(ifr->ifr_addr), ifr->ifr_addr.sa_len);
    }
    
    close(sockfd);
}

+ (NSString *)currentIPAddress {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    if (ip_names[1] == NULL) {
        return @"127.0.0.1";
    }
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}

// save object to
+ (void)persistantSetValue:(id)value withKey:(NSString *)key intoPath:(RVPersistentPathType)pathType{
    
    NSString *storeFilePath = nil;
    switch (pathType) {
        case RVCustomPersistentDataPathType:
        {
            storeFilePath = [WXUtility persistantDataPath]; // 持久化目录
        }
            break;
            
        case RVCustomDataCachePathType:
        {
            storeFilePath = [WXUtility customDataCachePath]; // 数据缓存目录
        }
            break;
            
        case RVCustomImageCachePathType:
        {
            storeFilePath = [WXUtility customImageCachePath]; // 图片缓存目录
        }
            break;
            
        default:
            break;
    }
    
    NSString *uidStr = [[NSUserDefaults standardUserDefaults] valueForKey:kPersistantUserDefaultId];
    if (!uidStr){
        return;
    }
    
    NSString *persistantfilePath = [storeFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"RVVoice-%@-%@.plist", uidStr, key]];
    
    if(key && persistantfilePath){
        unlink([persistantfilePath UTF8String]);
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:value, key, nil];
        [data writeToFile:persistantfilePath atomically:YES];
    }
}

// get object from persistant
+ (id)persistantGetValueForKey:(NSString *)key fromPath:(RVPersistentPathType)pathType{
    NSString *storeFilePath = nil;
    switch (pathType) {
        case RVCustomPersistentDataPathType:
        {
            storeFilePath = [WXUtility persistantDataPath]; // 持久化目录
        }
            break;
            
        case RVCustomDataCachePathType:
        {
            storeFilePath = [WXUtility customDataCachePath]; // 数据缓存目录
        }
            break;
            
        case RVCustomImageCachePathType:
        {
            storeFilePath = [WXUtility customImageCachePath]; // 图片缓存目录
        }
            break;
            
        default:
            break;
    }
    
    NSString *uidStr = [[NSUserDefaults standardUserDefaults] valueForKey:kPersistantUserDefaultId];
    if (!uidStr)
        uidStr = @"0";
    NSString *persistantfilePath = [storeFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"RVVoice-%@-%@.plist", uidStr, key]];
    
    if (key && persistantfilePath && (access([persistantfilePath UTF8String], F_OK) == 0)){
        id value = [[NSDictionary dictionaryWithContentsOfFile:persistantfilePath] valueForKey:key];
        return value;
    }
    else
        return nil;
}

// 删除本地序列化文件
+ (BOOL)removePersistantFileWithFileName:(NSString *)fileName
{
    NSString *filePath = [[WXUtility persistantDataPath] stringByAppendingPathComponent:fileName]; // 持久化目录
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    return NO;
}

// 创建持久化目录和临时文件目录
+ (BOOL)createPersistantPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL result = NO;
    BOOL isExist = [manager fileExistsAtPath:filePath isDirectory:&result];
    if (!isExist || (isExist && !result)) {
        result = [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else
    {
        result = YES;     // 目录已创建
    }
    
    return result;
}

+ (BOOL)cleanPathFolder:(NSString *)path
{
    if (!path || [@"" isEqualToString:path]) {
        return YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:&error];
    }
    
    if (error != nil)
        return NO;
    else
        return YES;
}

+ (NSString *)persistantDataPath
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kPMPersistantDataFolderName];
    if ([WXUtility createPersistantPath:path]) {
        return path;
    }
    else
    {
        NSLog(@"硬盘可能满了，无法创建持久化目录！");
        return nil;
    }
    
}

+ (NSString *)temporaryDataPath
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kPMTemporaryDataFolderName];
    if ([WXUtility createPersistantPath:path]) {
        return path;
    }
    else
    {
        NSLog(@"硬盘可能满了，无法创建临时文件目录！");
        return nil;
    }
}

+ (NSString *)cachePath
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [cachePaths objectAtIndex:0];
}

+ (NSString *)customDataCachePath
{
    NSString *path = [[self cachePath] stringByAppendingPathComponent:kPMCustomDataCacheFolderName];
    if ([WXUtility createPersistantPath:path]) {
        return path;
    }
    else
    {
        NSLog(@"硬盘可能满了，无法创建自定义数据缓存目录！");
        return nil;
    }
}

+ (NSString *)customImageCachePath
{
    NSString *path = [[self cachePath] stringByAppendingPathComponent:kPMCustomImageCacheFolderName];
    if ([WXUtility createPersistantPath:path]) {
        return path;
    }
    else
    {
        NSLog(@"硬盘可能满了，无法创建自定义图片缓存目录！");
        return nil;
    }
}

+ (NSMutableArray*)CreateNonRetainingArray{
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = TTRetainNoOp;
    callbacks.release = TTReleaseNoOp;
    NSMutableArray * arry = (NSMutableArray *)CFBridgingRelease(CFArrayCreateMutable(nil, 0, &callbacks));
    return arry;
}

+ (NSMutableDictionary*)CreateNonRetainingDictionary {
    CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
    CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
    callbacks.retain = TTRetainNoOp;
    callbacks.release = TTReleaseNoOp;
    NSMutableDictionary *dic = (NSMutableDictionary *)CFBridgingRelease(CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks));
    return dic;
}

// 返回 持久化目录路径下的mp3文件目录
+ (NSString *)mp3FilePath
{
    NSString *path = [[WXUtility persistantDataPath] stringByAppendingPathComponent:kPMMp3FileFolderName];
    if ([WXUtility createPersistantPath:path]) {
        return path;
    }
    else
    {
        NSLog(@"硬盘可能满了，无法创建mp3文件目录！");
        return nil;
    }
}

//返回本地存储假feed封面图片的目录
+ (NSString*)localFakeFeedCoverImagePath{
    return [self mp3FilePath];
}

+ (NSMutableSet *) createNonRetainingSet {
    CFSetCallBacks callbacks = kCFTypeSetCallBacks;
    callbacks.retain = TTRetainNoOp;
    callbacks.release = TTReleaseNoOp;
    NSMutableSet * set = (NSMutableSet *)CFBridgingRelease(CFSetCreateMutable(nil, 0, &callbacks));
    return set;
}

// --------------------------------------------------------------
//   对input进行md5加密
// --------------------------------------------------------------
+ (NSString *)md5HexDigest:(NSString *)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (int)strlen(str), result);
    NSMutableString *returnHashSum = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [returnHashSum appendFormat:@"%02x", result[i]];
    }
    
    return returnHashSum;
}

+ (NSString *)md5HexDigest:(NSString *)input withRange:(NSRange) range{
    NSString* md5Str = [WXUtility md5HexDigest:input];
    return [md5Str substringWithRange:range];
}

+ (NSString *)md5UTF8:(NSString *)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    bzero( result, sizeof( result ) );
    CC_MD5(str, (int)strlen(str), result);
    
    /*
     NSMutableString *returnHashSum = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
     for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
     [returnHashSum appendFormat:@"%c", result[i]];
     }
     */
    NSString *returnHashSum = [[NSString alloc] initWithBytes:(const void*)result length:CC_MD5_DIGEST_LENGTH encoding:NSASCIIStringEncoding];
    
    return returnHashSum;
}

+ (NSString *)generateSig:(NSMutableDictionary *)paramsDict appSecretKey:(NSString *)appSecretKey userSecretKey:(NSString *)userSecretKey limitParamLength:(int)length{
    NSMutableString* joined = [NSMutableString string];
    NSArray* keys = [paramsDict.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (id obj in [keys objectEnumerator]) {
        id value = [paramsDict valueForKey:obj];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [(NSNumber *)value stringValue];
        }
        if ([value isKindOfClass:[NSString class]]) {
            [joined appendString:obj];
            [joined appendString:@"="];
            if ((length > 0) && [(NSString*)value length]>length) {
                [joined appendString:[value substringToIndex:length]];
            }else{
                [joined appendString:value];
            }
            
        }
    }
    
    // appSecretKey是必填项
    NSAssert([appSecretKey length] > 0, @"AppSecretKey MUST NOT be null");
    [joined appendString:appSecretKey];
    
    // userSecretKey是可选项
    if ([userSecretKey length] > 0) {
        [joined appendString:userSecretKey];
    }
    
    return [WXUtility md5HexDigest:joined];
}

static const int kMCPSigParamDefautLengthLimit = 0;
+ (NSString *)generateSig:(NSMutableDictionary *)paramsDict appSecretKey:(NSString *)appSecretKey userSecretKey:(NSString *)userSecretKey{
    return [self generateSig:paramsDict appSecretKey:appSecretKey userSecretKey:userSecretKey limitParamLength:kMCPSigParamDefautLengthLimit];
}


+ (NSString *)documentPath{
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [searchPath objectAtIndex:0];
    return path;
}

+ (NSString *)crashLogPath{
    NSString* path = [NSString stringWithFormat:@"%@/%@",[WXUtility documentPath],kPMCrashLogPath];
    //检查此目录是否存在,不存在就创建
    NSError* error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"崩溃日志目录创建失败:%@",error);
        return nil;
    }
    
    return path;
}

+ (NSString *)statisticLogPath{
    NSString* path = [NSString stringWithFormat:@"%@/%@",[WXUtility documentPath],kPMStatisticLogPath];
    //检查此目录是否存在,不存在就创建
    NSError* error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"崩溃日志目录创建失败:%@",error);
        return nil;
    }
    return path;
}

//APP保存崩溃日志到本地
+ (BOOL)saveCrashLog:(NSString *)log{
    NSMutableString *dateLog = nil;
    if ([[WXUtility readCrashLogs] objectAtIndex:0]) {
        dateLog = [NSMutableString stringWithContentsOfFile:[[WXUtility readCrashLogs] objectAtIndex:0] encoding:NSUTF8StringEncoding error:nil];
    }
    if (!dateLog) {
        dateLog = [NSMutableString stringWithFormat:@"******%@******\n",[[NSDate date] description]];
    }
    [dateLog appendFormat:@"ExceptionInfo:\n%@\n",log];
    NSString *logPath = [NSString stringWithFormat:@"%@/%@_%@",[WXUtility crashLogPath],[[NSDate date] description],kPMCrashLogFileName];
    NSError* error;
    if (![dateLog writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"write to file error:%@",error);
        return NO;
    }
    return YES;
    
}

//APP保存统计日志到本地
+ (BOOL)saveStatistLog:(NSDictionary *)log{
    NSString* logPath = [NSString stringWithFormat:@"%@/%@_%@",[WXUtility statisticLogPath],[[NSDate date] description],kPMStatisticLogFileName];
    
    return [log writeToFile:logPath atomically:YES];
}

//从本地读取的崩溃日志
+ (NSArray *)readCrashLogs{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    NSArray* logs = [fileManager contentsOfDirectoryAtPath:[WXUtility crashLogPath] error:&error];
    if (logs == nil || logs.count == 0) {
        NSLog(@"没有崩溃日志存在:%@",error);
        return nil;
    }
    return logs;
    
}
+ (NSArray *)readStatistLogs{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    NSArray* logs = [fileManager contentsOfDirectoryAtPath:[WXUtility statisticLogPath] error:&error];
    if (logs == nil || logs.count == 0) {
        NSLog(@"没有统计日志存在:%@",error);
        return nil;
    }
    return logs;
}

+ (BOOL)removeCrashLog{
    return [[NSFileManager defaultManager] removeItemAtPath:[WXUtility crashLogPath] error:nil];
}

+ (BOOL)removeStatistLog{
    return [[NSFileManager defaultManager] removeItemAtPath:[WXUtility statisticLogPath] error:nil];
}

+ (BOOL)saveQACrashLog:(NSString *)log{
    NSString* path = [NSString stringWithFormat:@"%@/%@",[WXUtility documentPath],kPMQACrashLogPath];
    //检查此目录是否存在,不存在就创建
    NSError* error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"崩溃日志目录创建失败:%@",error);
        return NO;
    }
    
    NSString* logPath = [NSString stringWithFormat:@"%@/%@.crash",[WXUtility statisticLogPath],[[NSDate date] description]];
    
    return [log writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

+(NSString*)coverImagePathByFeedId:(NSString*)fid pack640:(BOOL)pack checkExists:(BOOL)check{
    if (!fid || [fid isEqualToString:@""]) {
        return nil;
    }
    NSString* fileName = [NSString stringWithFormat:@"kFeedCoverImage-%@",fid];
    if (pack) {
        fileName =  [fileName stringByAppendingString:@"-640"];
    }
    fileName = [fileName stringByAppendingPathExtension:@"jpg"];
    
    if (check) {
        NSString* coverFilePath = [WXUtility localFakeFeedCoverImagePath];
        NSString* path = [coverFilePath stringByAppendingPathComponent:fileName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            fileName = nil;
        }
    }
    NSString* filePath = nil;
    if (fileName) {
        filePath = [WXUtility localFakeFeedCoverImagePath];
        filePath = [filePath stringByAppendingPathComponent:fileName];
    }
    return filePath;
}



+ (int)getFileSizeFromPath:(NSString *) path
{
    int filesize = 0;
    BOOL isDirectory;
    NSFileManager * filemanager = [NSFileManager defaultManager];
    if([filemanager fileExistsAtPath:path isDirectory:&isDirectory]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        // file size
        NSNumber *theFileSize;
        if ((theFileSize = [attributes objectForKey:NSFileSize]))
            filesize= [theFileSize intValue];
    }
    return filesize;
}

+ (float)getCAFTimelength:(NSString *)path{
    NSURL *cafFileUrl = [NSURL fileURLWithPath:path];
    AudioFileID cafFileID = NULL;
    OSStatus readStatus;
    float timelen = 0.0;
    
    AudioStreamBasicDescription fileFormat={};
    UInt32 propsize = sizeof(AudioStreamBasicDescription);
    
    UInt32 audioFileDataLeng;
    
    if (!path || access([path UTF8String], F_OK))
        return 0.0;
    
    // read caf file and its information
    readStatus = AudioFileOpenURL((__bridge CFURLRef)(cafFileUrl), kAudioFileReadPermission, kAudioFileCAFType, &cafFileID);
    if (readStatus != noErr) {
        NSLog(@"CAF文件打开失败！");
        goto getCAFTimelength_exit;
    }
    readStatus = AudioFileGetProperty(cafFileID, kAudioFilePropertyDataFormat, &propsize, &fileFormat);
    if (readStatus != noErr) {
        NSLog(@"CAF文件格式获取失败！");
        goto getCAFTimelength_exit;
    }
    
    readStatus = AudioFileGetUserDataSize(cafFileID, 'data', 0, &audioFileDataLeng);
    if (readStatus != noErr) {
        NSLog(@"get audio file data chunck length error");
        goto getCAFTimelength_exit;
    }
    
    timelen = (float)(audioFileDataLeng*8)/(float)(fileFormat.mBitsPerChannel*fileFormat.mSampleRate*fileFormat.mChannelsPerFrame);
    
getCAFTimelength_exit:
    
    if (cafFileID)
        AudioFileClose(cafFileID);
    
    return timelen;
}

+ (float)getMP3Timelength:(NSString *)path{
    float timelen = 0.0;
    
    NSURL *mp3FileUrl = [NSURL fileURLWithPath:path];
    AudioFileID mp3FileID = NULL;
    OSStatus readStatus;
    
    AudioStreamBasicDescription fileFormat={};
    UInt32 propsize = sizeof(AudioStreamBasicDescription);
    
    UInt64 audioFileDataLeng;
    UInt32 bitsRate;
    
    if (!path || access([path UTF8String], F_OK))
        return 0.0;
    
    // read caf file and its information
    readStatus = AudioFileOpenURL((__bridge CFURLRef)(mp3FileUrl), kAudioFileReadPermission, kAudioFileMP3Type, &mp3FileID);
    if (readStatus != noErr) {
        NSLog(@"mp3文件打开失败！");
        goto getMP3Timelength_exit;
    }
    readStatus = AudioFileGetProperty(mp3FileID, kAudioFilePropertyDataFormat, &propsize, &fileFormat);
    if (readStatus != noErr) {
        NSLog(@"mp3文件格式获取失败！");
        goto getMP3Timelength_exit;
    }
    propsize = sizeof(UInt64);
    readStatus = AudioFileGetProperty(mp3FileID, kAudioFilePropertyAudioDataByteCount, &propsize, &audioFileDataLeng);
    if (readStatus != noErr) {
        NSLog(@"get audio file data chunck length error");
        goto getMP3Timelength_exit;
    }
    propsize = sizeof(UInt32);
    readStatus = AudioFileGetProperty(mp3FileID, kAudioFilePropertyBitRate, &propsize, &bitsRate);
    if (readStatus != noErr) {
        NSLog(@"get audio file data chunck length error");
        goto getMP3Timelength_exit;
    }
    if (bitsRate > 0)
        timelen = (float)audioFileDataLeng/(bitsRate*0.125);
    
getMP3Timelength_exit:
    
    if (mp3FileID)
        AudioFileClose(mp3FileID);
    return timelen;
}


/*
 *判断用户名是否合法 去除开头与结尾的空格，如果中间字符有空格则未非法用户名
 */
+ (NSString *)nickNameValid:(NSString *)nickName
{
    int start = 0 ,finish = (int)[nickName length] -1;
    for (int i=0; i<[nickName length]; i++){
        char cName = [nickName characterAtIndex:i];
        if (cName !=32) {
            start = i;
            break;
        }
    }
    for ( int j=(int)[nickName length]-1; j >= 0; j--) {
        char cName = [nickName characterAtIndex:j];
        if (cName !=32) {
            finish = j;
            break;
        }
    }
    
    for (int k=start; k<=finish; k++) {
        
        char cName= [nickName characterAtIndex:k];
        if(cName ==32){
            
            return  nil;//空格 ;
        }
    }
    
    NSString *realName= [nickName substringWithRange:NSMakeRange(start, finish-start+1)];
    return  realName;
}


+ (BOOL) nickNameValidSecond: (NSString *)nickName
{
    NSString *asNSString = nickName;
    NSLog(@"nickname length %d ",(int)[nickName length]);
#ifdef USE_IN_BOBO
    if ([asNSString length]!=[WXUtility convertToInt:asNSString]) {
        NSLog(@"不准输入汉字哦～");
        return  NO;
    }   //use in Dc
#endif
    
    if ([asNSString length]>nameLengthMax) {
        
        return NO;
    }
    for (int i=0; i<[asNSString length]; i++){
        char cName = [asNSString characterAtIndex:i];
        if ( (cName>=97&&cName<=122) ||(cName>=65&&cName<=90) ||(cName>=48&&cName<=57) ||cName==95||cName == 46) {
            ;
        }
        else{
            return  NO;
        }
    }
    
    return YES;
}

+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    NSLog(@"lengthOfBytesUsingEncoding:NSUnicodeStringEncoding :%d ",(int)[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]);
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    NSLog(@"\n");
    return strlength;
}
+ (CGRect)moveFrameForKeyboardUp:(BOOL)up inFrame:(CGRect)targetFrame numberOfRows:(float)rowIndex{
    NSTimeInterval animationDuration = 0.80f;
    CGRect frame = targetFrame;
    int yOffset = 80;
    if (up) {
        frame.origin.y -=yOffset*rowIndex;
        frame.size.height +=yOffset*rowIndex;
    }else{
        frame.origin.y +=yOffset*rowIndex;
        frame.size. height -=yOffset*rowIndex;
    }
    targetFrame = frame;
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    targetFrame = frame;
    [UIView commitAnimations];
    return targetFrame;
}
+(BOOL )ChatNsstring:(NSString *)sourceNsstring{
    if ([sourceNsstring length]==0) {
        return NO;
    }
    for (int i=0; i<[sourceNsstring length]; i++){
        char c1 = [sourceNsstring characterAtIndex:i];
        if (c1!=32 && c1!=10 ) {
            return YES;
        }
    }
    return NO;
}

+ (NSString*)deviceString{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone3,2"])    return@"Verizon iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 6";

    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    return deviceString;
}
/*
 *字符串过滤//去处首尾空格回车与字符串中连续的首尾空格
 */

+(NSString *)NsstringFilter:(NSString *)sourceNsstring{
    if ([sourceNsstring length]>0) {
        NSString *delSpaceNsstring = [sourceNsstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *delNewlineNsstring = [delSpaceNsstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        NSMutableString *string =[NSMutableString stringWithString:delNewlineNsstring];
        if ([string length]==0) {
            return string;
        }
        for (int i=0; i<[string length]-1; i++){
            char c1 = [string characterAtIndex:i];
            char c2 = [string characterAtIndex:i+1];
            if ((c1==32 && c2==32)||(c1==10 && c2==10)) {//去除连续的空格与回车
                [string deleteCharactersInRange:NSMakeRange(i, 1)];
                i--;
            }
            else if((c1==32 && c2==10)){ //空格与回车连续时候去除空格
                [string deleteCharactersInRange:NSMakeRange(i, 1)];
                i--;
            }
            else if(c1==10 &&c2==32){//回车与空格连续时去除空格
                [string deleteCharactersInRange:NSMakeRange(i+1, 1)];
                i--;
            }
        }
        
        return string;
    }
    else
        return sourceNsstring;
    
}

//去除空格，包括字符之间的空格
+(NSString *)NsstringRemoveWhitespace:(NSString *)sourceNsstring{
    if ([sourceNsstring length]>0) {
        NSString *delSpaceNsstring = [sourceNsstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSMutableString *string =[NSMutableString stringWithString:delSpaceNsstring];
        if ([string length]==0) {
            return string;
        }
        
        for (int i=0; i<[string length]-1; i++){
            char c1 = [string characterAtIndex:i];
            if (c1==32) {
                [string deleteCharactersInRange:NSMakeRange(i, 1)];
                i--;
            }
        }
        
        return string;
    }
    else
        return sourceNsstring;
}

//头像缓存图片
+(NSString *)photoCache:(UIImage *) photoImage type:(NSString *)prefixNSString{
    
    if (photoImage) {
        NSString *photoFilePath = [WXUtility persistantDataPath];
        if (![[NSFileManager defaultManager]fileExistsAtPath:photoFilePath]) {
            [[NSFileManager defaultManager] createFileAtPath:photoFilePath contents:nil attributes:nil];
        }
        NSDate * senddate=[NSDate date];
        NSString * locationString=[NSString stringWithFormat:@"%d",(int)[senddate timeIntervalSince1970]*1000000];
        NSString *fileName = [prefixNSString stringByAppendingString:locationString];
        fileName = [fileName stringByAppendingPathExtension:@"png"];
        NSString *wpath = [photoFilePath stringByAppendingPathComponent:fileName];
        //if (![[NSFileManager defaultManager] fileExistsAtPath:wpath])
        {
            NSData *photoImageData = UIImagePNGRepresentation(photoImage);
            // UIImageJPEGRepresentation(photoImage, kRVUploadImageCompressionQuality);
            BOOL result = [photoImageData writeToFile:wpath atomically:YES];
            if (!result) {
                NSLog(@"ATTENTION! \n error occured in writing cover image");
                return nil;
            }
            else
                return wpath;
        }
        
    }
    return nil;
}


+ (void)dismissAlertsAndActionSheets{
    
    AppDelegate* delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if (delegate.alertsAndActionSheets.count == 0) {
        return;
    }
    [delegate.alertsAndActionSheets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIAlertView class]]) {
            UIAlertView* alert = (UIAlertView*)obj;
            alert.delegate = nil;
            [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:NO];
        }
        if ([obj isKindOfClass:[UIActionSheet class]]) {
            UIActionSheet* actionSheet = (UIActionSheet*)obj;
            actionSheet.delegate = nil;
            [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
        }
    }];
    delegate.alertsAndActionSheets = nil;
}

+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    va_list args;
    va_start(args, otherButtonTitles); // scan for arguments after firstObject.
    // get rest of the objects until nil is found
    for (NSString* objectArg = otherButtonTitles; objectArg != nil; objectArg = va_arg(args,NSString*)) {
        
        [alert addButtonWithTitle:objectArg];
    }
    
    va_end(args);
    AppDelegate* appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.alertsAndActionSheets addObject:alert];
    return alert;
}

+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:delegate cancelButtonTitle:nil destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    //actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    va_list args;
    va_start(args, otherButtonTitles); // scan for arguments after firstObject.
    // get rest of the objects until nil is found
    for (NSString* objectArg = otherButtonTitles; objectArg != nil; objectArg = va_arg(args,NSString*)) {
        
        [actionSheet addButtonWithTitle:objectArg];
    }
    va_end(args);
    if(cancelButtonTitle){
        [actionSheet addButtonWithTitle:cancelButtonTitle];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    AppDelegate* appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [appdelegate.alertsAndActionSheets addObject:actionSheet];
    return actionSheet;
    
}


+ (NSDictionary *)countryCodeInfoFromCurrentCarrier {
    
    NSString *currentCountryCode = nil;
    NSString *currentCountryName = nil;
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *iso = carrier.isoCountryCode; //ISO 3166-1 表示，用户的电话服务提供者的国家代码 例如“cn”
    
    //TODO: 判断cell网络是否可用
    if (iso) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"countrycode" ofType:@"plist"];
        NSArray *countryCodesArray = [[NSArray alloc] initWithContentsOfFile:path];
        
        NSMutableDictionary *namesCodes = [NSMutableDictionary new];
        for (NSDictionary *obj in countryCodesArray) {
            [namesCodes setValue:[obj valueForKey:@"countryCode"] forKey:[obj valueForKey:@"countryName"]];
        }
        for (NSString *name in [namesCodes allKeys]){
            if([name hasSuffix:[iso uppercaseString]]){
                currentCountryCode = [namesCodes valueForKey:name];
                currentCountryName = [iso uppercaseString];
            }
        }
    }
    
    if (!currentCountryCode) {
        currentCountryCode = PMDefaultCountryCode;
        currentCountryName = PMDefaultCountryName;
    }
    
    NSDictionary *infoDic = @{@"countryCode" : currentCountryCode,
                              @"countryName" : currentCountryName,
                              @"displayCode" : [self displayCountryCodeWithCountryCode:currentCountryCode countryName:currentCountryName]
                              };
    
    return infoDic;
}

+ (NSString *)countryNameOfCountryCode:(NSString *)countryCode {
    if (countryCode) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"countrycode" ofType:@"plist"];
        NSArray *countryCodesArray = [[NSArray alloc] initWithContentsOfFile:path];
        
        NSMutableDictionary *codesNames = [NSMutableDictionary new];
        for (NSDictionary *obj in countryCodesArray) {
            [codesNames setValue:[obj valueForKey:@"countryName"] forKey:[obj valueForKey:@"countryCode"]];
        }
        
        return [codesNames valueForKey:countryCode];
    }
    
    return nil;
}

+ (NSString *)displayCountryCodeWithCountryCode:(NSString *)countryCode countryName:(NSString *)countryName {
    
    if ([countryCode length] > 2 && [countryName length] >= 2) {
        return [NSString stringWithFormat:@"+%@ ",[countryCode substringFromIndex:2]];
    }
    
    return nil;
}

+(NSString *)convertDescriptionStr:(NSString *)desStr withAtInfo:(NSDictionary *)infoDic{
    NSString *processStr = [NSString stringWithFormat:@"%@ ", desStr]; //对原始description末尾增加空格
    NSString  * __block tempresult = [processStr copy];
    if (![infoDic isKindOfClass:[NSString class]]) {
        NSMutableDictionary *newFriendsDic = [[NSMutableDictionary alloc] initWithCapacity:5]; //存储新的withFriends
        
        if (infoDic) {
            NSMutableDictionary *friendsDic = [[NSMutableDictionary alloc] init];
            for (id key in infoDic) {
                NSString *userId =[NSString stringWithFormat:@"%@",[infoDic objectForKey:key]];
                if (![userId isEqualToString:@"0"]){
                    [friendsDic setObject:userId forKey:key];
                }
            }
            [newFriendsDic addEntriesFromDictionary:friendsDic];
            [friendsDic enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop) {
                NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:key options:NSRegularExpressionCaseInsensitive error:NULL];
                [regex enumerateMatchesInString:processStr options:0 range:NSMakeRange(0, processStr.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    NSRange range = result.range;
                    NSString * temp = [processStr substringWithRange:range];
                    [newFriendsDic setValue:obj forKey:temp];
                }];
            }];
        }
        [newFriendsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            tempresult = [tempresult stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"@%@ ",key]withString:[NSString stringWithFormat:@"<_link>%@|@%@</_link> ",obj,key]];
        }];
    }
    return tempresult;
}



//step2 add legal tag with information dictionary
+ (NSString *)addLegalTagUsingInfo:(NSArray *)infoArray toString:(NSString *)processString
{
    //    NSDictionary *infoDic;
    NSMutableString *tempStr = [[NSMutableString alloc] initWithString:processString];
    NSString *linkString = @"";
    int idLength = 8;
    int linkLengthSum = 0;
    for (int i = 0; i<[infoArray count]; i++) {
        if ([[infoArray objectAtIndex:i] valueForKey:@"tagName"]) {
            linkString = @"tagName";
        }else{
            linkString = @"userId";
        }
        
        idLength = (int)[[NSString stringWithFormat:@"%@",[[infoArray objectAtIndex:i] valueForKey:linkString]] length];
        
        
        if ([[[infoArray objectAtIndex:i] valueForKey:@"start"] intValue]+i*(8+8)+linkLengthSum>tempStr.length) {
            return processString;
        }else{
            [tempStr insertString:[NSString stringWithFormat:@"<_link>%@|",[[infoArray objectAtIndex:i] valueForKey:linkString]] atIndex:[[[infoArray objectAtIndex:i] valueForKey:@"start"] intValue]+i*((8)+8)+linkLengthSum];
            linkLengthSum = linkLengthSum+idLength;
            if ([[[infoArray objectAtIndex:i] valueForKey:@"end"] intValue]<[processString length]) {
                int indext = [[[infoArray objectAtIndex:i] valueForKey:@"end"] intValue]+1+(i+1)*(8)+linkLengthSum+i*8;
                int temStrL = (int)[tempStr length];
                if (temStrL<indext) {
                    [tempStr insertString:@"</_link>" atIndex:temStrL];
                }else{
                    [tempStr insertString:@"</_link>" atIndex:indext];
                }
            }else{
                [tempStr insertString:@"</_link>" atIndex:[processString length]+(i+1)*(8)+i*8+linkLengthSum];
            }
        }
    }
    
    return tempStr;
}// sort information by position
+ (NSArray *)sortInfomation: (NSArray *)infoDic
{
    //存储infoDic中所有的value
    NSMutableArray *valueArray = [[NSMutableArray alloc] initWithCapacity:3];
    [valueArray addObjectsFromArray:infoDic];
    //给valueArray中的元素排序
    NSObject *tempObj;
    for (int i=0; i<[valueArray count]-1; i++) {
        for (int j=i+1; j<[valueArray count]; j++) {
            if ([[[valueArray objectAtIndex:j] objectForKey:@"start"] intValue]<[[[valueArray objectAtIndex:i] objectForKey:@"start"] intValue]) {
                tempObj = [valueArray objectAtIndex:i];
                [valueArray replaceObjectAtIndex:i withObject:[valueArray objectAtIndex:j]];
                [valueArray replaceObjectAtIndex:j withObject:tempObj];
            }
        }
    }
    return valueArray;
}

+ (NSArray *)addHashTagToString:(NSString *)processString withExp:(NSString *)expString andInfoArray:(NSMutableArray *)infoArray
{
    //test Regular expressions
    NSRange currentRage = NSMakeRange(0, [processString length]);
    NSMutableArray *tagInfoArray = [[NSMutableArray alloc] initWithCapacity:2];
    while (currentRage.length>0) {
        NSRange tagRange = [processString rangeOfString:expString options:NSRegularExpressionSearch range:currentRage];
        NSMutableDictionary *tagInfoDic = [[NSMutableDictionary alloc] initWithCapacity:2];
        if (tagRange.location == NSNotFound) {
            currentRage.length = 0;
        }else{
            //如果@列表中有人，查找有没有重复的，没重复的才添加；如果没人，直接添加
            if ([infoArray count]>0) {
                BOOL notFoundTagInUsername = YES;
                for (NSObject *obj in infoArray) {
                    NSRange tempRage = NSMakeRange([[obj valueForKey:@"start"] intValue], [[obj valueForKey:@"end"] intValue]-[[obj valueForKey:@"start"] intValue]);
                    if (!NSIntersectionRange(tempRage, tagRange).length == 0) {
                        notFoundTagInUsername = NO;
                        break;
                    }
                }
                if (notFoundTagInUsername) {
                    [tagInfoDic setValue:[NSNumber numberWithInt:(int)tagRange.location] forKey:@"start"];
                    [tagInfoDic setValue:[NSNumber numberWithInt:(int)tagRange.location+(int)tagRange.length-1] forKey:@"end"];
                    [tagInfoDic setValue:[processString substringWithRange:tagRange] forKey:@"tagName"];
                    //检查合法#tag前一位和后一位
                    [self addTagInfoDic:tagInfoDic toTagArray:tagInfoArray withRage:tagRange inString:processString];
                }
            }else{
                [tagInfoDic setValue:[NSNumber numberWithInt:(int)tagRange.location] forKey:@"start"];
                [tagInfoDic setValue:[NSNumber numberWithInt:(int)tagRange.location+(int)tagRange.length-1] forKey:@"end"];
                [tagInfoDic setValue:[processString substringWithRange:tagRange] forKey:@"tagName"];
                // 检查合法#tag前一位 和后一位
                [self addTagInfoDic:tagInfoDic toTagArray:tagInfoArray withRage:tagRange inString:processString];
            }
            currentRage.location = tagRange.location+tagRange.length;
            currentRage.length = [processString length]-currentRage.location;
        }
    }
    return tagInfoArray;
}


+(void)addTagInfoDic:(NSDictionary *)tagInfoDic toTagArray:(NSMutableArray *)tagInfoArray withRage:(NSRange)tagRange inString:(NSString *)processString{
    if (tagRange.location==0) {
        if (tagRange.location+tagRange.length < processString.length) {
            if ([processString rangeOfString:@"#"options:NSRegularExpressionSearch range:NSMakeRange(tagRange.location+tagRange.length, 1)].length==1) {
                NSLog(@"后面第一位是非法#    %@",[processString substringWithRange:NSMakeRange(tagRange.location+tagRange.length, 1)]);
            }else{
                [tagInfoArray addObject:tagInfoDic];
                
            }
        }else if (tagRange.location+tagRange.length == processString.length){
            [tagInfoArray addObject:tagInfoDic];
        }
    }else {
        if ([processString rangeOfString:@"[0-9A-Za-z#]*"options:NSRegularExpressionSearch range:NSMakeRange(tagRange.location-1, 1)].length==1) {
            NSLog(@"前面第一位是非法1232adsfwf    %@",[processString substringWithRange:NSMakeRange(tagRange.location-1, 1)]);
        }else{
            if (tagRange.location+tagRange.length < processString.length) {
                if ([processString rangeOfString:@"#"options:NSRegularExpressionSearch range:NSMakeRange(tagRange.location+tagRange.length, 1)].length==1) {
                    NSLog(@"后面第一位是非法#    %@",[processString substringWithRange:NSMakeRange(tagRange.location+tagRange.length, 1)]);
                }else{
                    [tagInfoArray addObject:tagInfoDic];
                }
            }else if (tagRange.location+tagRange.length == processString.length){
                [tagInfoArray addObject:tagInfoDic];
            }
        }
    }
}
//判断字符串中是否含有emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         NSLog(@"%c\n",hs);
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3 ||ls) {
                 returnValue = YES;
             }
             const unichar s = [substring characterAtIndex:0 ];
             if (s==0x263a ||s==0x2614) {//增加2个ios 7 的emoji 过滤，笑脸 雨伞 ☔
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

//过滤字符串中的emoji表情
+ (NSString *)stringFilterEmoji:(NSString *)string {
    __block NSString *returnValue = string;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = [returnValue stringByReplacingOccurrencesOfString:substring withString:@""];
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             const unichar fs = [substring characterAtIndex:0];
             if (ls == 0x20e3 ||fs ==0x2614 || fs ==0x263a) {
                 returnValue = [returnValue stringByReplacingOccurrencesOfString:substring withString:@""];
             }
             
             
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue =  [returnValue stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = [returnValue stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = [returnValue stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = [returnValue stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = [returnValue stringByReplacingOccurrencesOfString:substring withString:@""];
             }
         }
     }];
    
    return returnValue;
}

+ (NSArray *)coreTextStyle
{
    
    NSMutableArray *result = [NSMutableArray array];
    /*
     FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
     defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
     defaultStyle.color = UIColorFromRGB(0x666666);
     defaultStyle.font = [UIFont fontWithName:UIFontNameForUserName size:12.f];
     defaultStyle.textAlignment = FTCoreTextAlignementLeft;
     [result addObject:defaultStyle];
     
     FTCoreTextStyle *linkStyle = [FTCoreTextStyle new];
     linkStyle.name = FTCoreTextTagLink;
     linkStyle.color = UIColorFromRGB(0xcb553b);
     linkStyle.font = [UIFont fontWithName:UIFontNameForTopBarTitle size:12.f];
     [result addObject:linkStyle];
     
     FTCoreTextStyle *boldStyle = [FTCoreTextStyle styleWithName:@"bold"]; // using fast method
     boldStyle.font = [UIFont fontWithName:UIFontNameForUserName size:17.f];
     boldStyle.color = [UIColor blueColor];
     boldStyle.textAlignment = FTCoreTextAlignementLeft;
     [result addObject:boldStyle];
     */
    return  result;
}

+ (BOOL)isBlank:(NSString *)str{
    if (str == nil || str == NULL || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]) {
        return YES;
    }
    NSAssert([str isKindOfClass:[NSString class]], @"param's Class of isBlank   is not NSString : %@", str);
    return [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}
+ (BOOL)isEmpty:(id)collection{
    if (collection == nil || collection == NULL || [collection isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSAssert([collection isKindOfClass:[NSDictionary class]] ||
             [collection isKindOfClass:[NSArray class]] ||
             [collection isKindOfClass:[NSSet class]] , @"param's Class of isEmptyCollection is not collection : %@", collection);
    return [collection count] == 0;
}


/**
 *  考虑NSString中对Emoji截长的subStringToIndex 方法
 **/
+ (NSString *)availableSubString:(NSString *)sourceString toIndex:(NSUInteger)to{
    NSString *clipString = [sourceString substringToIndex:to];
    
    NSData *data = [clipString dataUsingEncoding:NSUTF8StringEncoding];
    while (data ==  nil) {
        clipString = [clipString substringToIndex:(clipString.length - 1)];
        data = [clipString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return clipString;
}


#pragma mark - device info

+ (NSString*)uniqueContentId:(NSString*)userID
{
//    long long millisecond = [NSDate millisecondsSince1970toNow];    // 毫秒
//    
//    // 去后四个字节
//    int now = millisecond & 0xFFFFFFFF;
//    
//    long long uid = [userID intValue];
//    
//    uid = uid << 32;
//    
//    uid = uid | now;
//    
//    return [NSNumber numberWithLongLong:uid].stringValue;
    return nil;
}

// 获取用户的 advertising Identifier
+ (NSString *)advertisingIdentifier
{
    NSString *ai = @"";
    ai = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (![ai isKindOfClass:[NSString class]] || [ai length] <= 0) {
        ai = @"";
    }
    
    return ai;
}

+ (NSString *)udid
{
//    return [OpenUDID value];
    return nil;
}

+(BOOL)imageSizeLegal:(UIImage *)image{
    
    CGFloat minlength = MIN(image.size.width, image.size.height);
    if (minlength <=1280 &&
        image.size.height*image.size.width*image.scale >10000000){
        return NO;
    }
    
    if (image.size.height*image.size.width*image.scale >maxSizeOfImage
        ||image.size.height<50||image.size.width<50) {
        return NO;
    }else
        return YES;
    
    
}
+ (NSUInteger)unreadMessageCount{
//    NSPredicate *predic = [NSPredicate predicateWithFormat:@"messageStatus==%d", PMDataMessageReadStatus_UnRead];
//    NSFetchRequest *req = [[NSFetchRequest alloc] init];
//    req.entity = [PMDataMessage entityWithMOC:[LSCoreDataManager manager].mainMOC];
//    req.predicate = predic;
//    return [[LSCoreDataManager manager].mainMOC countForFetchRequest:req error:nil];
    return 0;
}

/*
 *将可变参数的转化为一个数组
 */
+(NSArray*)arrayWithArgs:(id)firstArg,...{
    NSMutableArray *argsArray = nil;
    va_list args;
    va_start(args, firstArg); // scan for arguments after firstObject.
    // get rest of the objects until nil is found
    for (id objectArg = firstArg; objectArg != nil; objectArg = va_arg(args,id)) {
        if (!argsArray) {
            argsArray = [[NSMutableArray alloc] init];
        }
        [argsArray addObject:objectArg];
    }
    va_end(args);
    return argsArray;
}

//截屏 ios 官方代码
+(UIImage*)screenshot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != &UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else{
        UIGraphicsBeginImageContext(imageSize);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}




+(CABasicAnimation *)opacityForever_Animation:(float)time //永久闪烁的动画
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.0];
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time//有闪烁次数的动画
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.4];
    animation.repeatCount=repeatTimes;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=YES;
    return  animation;
}

+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x //横向移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.toValue=x;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

+(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y //纵向移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.toValue=y;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes //缩放
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=orginMultiple;
    animation.toValue=Multiple;
    animation.duration=time;
    animation.autoreverses=YES;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes //组合动画
{
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    animation.animations=animationAry;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes //路径动画
{
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path=path;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=NO;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    return animation;
}

+(CABasicAnimation *)movepoint:(CGPoint )point //点移动
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation"];
    animation.toValue=[NSValue valueWithCGPoint:point];
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount //旋转
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0,direction);
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration= dur;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= repeatCount;
    animation.delegate= self;
    
    return animation;
}

@end

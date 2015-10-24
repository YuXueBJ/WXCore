//
//  WXUtility.h
//  WXCore
//
//  Created by 朱洪伟 on 15/6/30.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//持久化常量定义
#define kPersistantUserDefaultId        @"kUserDefaultsUid"

#define kPersistantAtFriends            @"kUserAtFriends"
#define kPersistantFeeds                @"kUserFeeds"
#define kPersistantTrendingFeeds        @"kUserTrendingFeeds"
#define kPersistantFollowing            @"kUserFollowing"
#define kPersistantLoginInvite          @"kUserLoginInvite"
#define kPersistantUser                 @"kUserKey"
#define kPersistantUserFriends          @"kUserFriendKey"
#define kPersistantMessage              @"kUserMessage"
#define kPersistantProfile              @"kUserProfile"
#define kPersistantTag                  @"kPersistantTag"
#define kPersistantHotDubbler           @"kPersistantHotDubbler"

#define kPersistantShareToFriend        @"kUserShareToFriendsData"
#define kPersistantFakeFeed             @"kUserFakeFeed"
#define kPersistantHistoryTags          @"kUserHistoryTags"
#define kPersistantReadTags             @"kUserReadTags"
#define kPersistantHotTags              @"kUserHotTags"
#define kPersistantRecentSearchTags     @"kRecentSearchTags"

#define kPersistantTransferingFiles     @"kTransferingFiles"
#define kPersistantLikedFeedList        @"kPersistantLikedFeedList"


typedef enum RVPersistentPathType : NSInteger {
    RVCustomDataCachePathType =  0,               // Library/Cache/CustomDataCache  目录
    RVCustomImageCachePathType = 1,               // Library/Cache/CustomImageCache  目录
    RVCustomPersistentDataPathType = 2            // Document/Data 目录
    
} RVPersistentPathType;


@interface WXUtility : NSObject

/**
 * @brief 尝试获取并返回本机的ip地址，如果获取失败则默认返回127.0.0.1
 */
+ (NSString *)currentIPAddress;

/**
 * @brief 设备信息判断是iphone几
 */
+ (NSString*)deviceString;

/**
 ＊@brief  检查名字合法性
 */
+ (NSString *)nickNameValid:(NSString *)nickName;//判断用户名是否合法 去除开头与结尾的空格，如果中间字符有空格则未非法用户名RVP

+ (BOOL) nickNameValidSecond :(NSString *)nickName;//3－20个字母 数字 下划线

+ (int)convertToInt:(NSString*)strtemp;//获取字符串真正长度（汉字占2个字符）
+(NSString *)NsstringFilter:(NSString *)sourceNsstring;//去除字符串首尾空格回车与字符串中连续的空格回车
+(NSString *)NsstringRemoveWhitespace:(NSString *)sourceNsstring;//去除空格，包括字符之间的空格
+(NSString *)photoCache:(UIImage *) photoImage type:(NSString *)prefixNSString;//头像图片缓存
+(BOOL)stringContainsEmoji:(NSString *)string ;//判断是否含有emoji表情
+ (NSString *)stringFilterEmoji:(NSString *)string;//过滤字符串中的emoji表情

/*
 *根据需要，上下移动frame
 */
+ (CGRect)moveFrameForKeyboardUp:(BOOL)up inFrame:(CGRect)targetFrame numberOfRows:(float)rowIndex;

/*
 *判断聊天输入字符串是否全为空格与回车
 */
+(BOOL )ChatNsstring:(NSString *)sourceNsstring;
//feed描述解析@和#TAG时使用
+ (NSString *)addLegalTagUsingInfo:(NSArray *)infoArray toString:(NSString *)processString;//增加合法标签
+ (NSArray *)sortInfomation: (NSArray *)infoDic;//给infoDic排序
+ (NSArray *)addHashTagToString:(NSString *)processString withExp:(NSString *)expString andInfoArray:(NSMutableArray *)infoArray;//使用正则表达式expString将processString中符合条件的字符串解析出来，并把位置信息添加到infoArray中
+ (void)addTagInfoDic:(NSDictionary *)tagInfoDic toTagArray:(NSMutableArray *)tagInfoArray withRage:(NSRange)tagRange inString:(NSString *)processString;//判断tagInfoDic中的信息是否符合条件，符合就添加到tagInfoArray中，

+ (NSArray *)coreTextStyle;


//////////////////////////////////////////
//
//  persistant data storage
//
// 本地序列化工具方法
+ (void)persistantSetValue:(id)value withKey:(NSString *)key intoPath:(RVPersistentPathType)pathType;   // save object to persistant
+ (id)persistantGetValueForKey:(NSString *)key fromPath:(RVPersistentPathType)pathType;                 // get object from persistant
+ (BOOL)removePersistantFileWithFileName:(NSString *)fileName;  // 删除本地序列化文件

// 创建持久化目录 创建成功或者已经存在返回YES
+ (BOOL)createPersistantPath:(NSString *)filePath;
// return 成功时 持久化目录路径，否则nil
+ (NSString *)persistantDataPath;
// return 成功时 临时目录路径，否则nil
+ (NSString *)temporaryDataPath;
// 清除 目录中的所有文件包括目录本身，成功返回YES，否则NO
+ (BOOL)cleanPathFolder:(NSString *)path;
// return 成功时 mp3文件目录，否则nil
+ (NSString *)mp3FilePath;
// return 成功时 存储假feed封面的目录
+ (NSString*)localFakeFeedCoverImagePath;
// return 成功时 缓存路径，否则nil
+ (NSString *)cachePath;
// 自定义缓存数据目录名，存放假Feed, plist, caf
+ (NSString *)customDataCachePath;
// 自定义缓存图片目录名
+ (NSString *)customImageCachePath;
// 通过feedid拿到发feed时存储的图片路径信息
// 参数pack:是否要拿压缩成640的图片路径
// 参数check:是否检查此路径是否为可用路径，当check为yes时，如果文件不存在，则返回结果为nil
+ (NSString*)coverImagePathByFeedId:(NSString*)fid pack640:(BOOL)pack checkExists:(BOOL)check;

// 创建不保留object应用计数的Dictonary和Array和set
+ (NSMutableDictionary*)CreateNonRetainingDictionary;
+ (NSMutableArray*)CreateNonRetainingArray;
+ (NSMutableSet *) createNonRetainingSet;

// 获取RestAPP的基础平台参数Sig
+ (NSString *)md5HexDigest:(NSString *)input;
+ (NSString *)md5HexDigest:(NSString *)input withRange:(NSRange) range;
+ (NSString *)generateSig:(NSMutableDictionary *)paramsDict appSecretKey:(NSString *)appSecretKey userSecretKey:(NSString *)userSecretKey;
+ (NSString *)generateSig:(NSMutableDictionary *)paramsDict appSecretKey:(NSString *)appSecretKey userSecretKey:(NSString *)userSecretKey limitParamLength:(int)length;

//日志处理
+ (NSString *)documentPath;                 //APP 的文档路径  序列化存储路径

+ (NSString *)crashLogPath;                 //APP 的崩溃日志路径
+ (NSString *)statisticLogPath;             //APP的统计日志路径
+ (BOOL)saveCrashLog:(NSString *)log;       //APP保存崩溃日志到本地
+ (BOOL)saveStatistLog:(NSDictionary *)log; //APP保存统计日志到本地
+ (NSArray *)readCrashLogs;                 //从本地读取的崩溃日志
+ (NSArray *)readStatistLogs;               //从本地读取统计日志
+ (BOOL)removeCrashLog;                     //删除本地的crashLog
+ (BOOL)removeStatistLog;                   //删除本地的StatistLog

+ (BOOL)saveQACrashLog:(NSString *)log; // 本地崩溃日志，用来QA测试，不删除

+ (int)getFileSizeFromPath:(NSString *) path;
+ (float)getCAFTimelength:(NSString *)path;
+ (float)getMP3Timelength:(NSString *)path;

+ (void)dismissAlertsAndActionSheets;

+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


// 国家码相关的计算
+ (NSDictionary *)countryCodeInfoFromCurrentCarrier;
+ (NSString *)countryNameOfCountryCode:(NSString *)countryCode;
+ (NSString *)displayCountryCodeWithCountryCode:(NSString *)countryCode countryName:(NSString *)countryName;


/**
 *	@brief	判断NSString是否为空
 *
 *	@return	str 为 nil NULL NSNull 或者 只有空格回车换行 返回YES
 */
+ (BOOL)isBlank:(NSString *)str;

/**
 *	@brief	判断集合对象的元素数
 *
 *	@param 	collection 	集合对象
 *
 *	@return	collection 为 nil NULL NSNull 或者 元素数为0 返回YES
 */
+ (BOOL)isEmpty:(id)collection;

/**
 *  考虑NSString中对Emoji截长的subStringToIndex 方法
 **/
+ (NSString *)availableSubString:(NSString *)sourceString toIndex:(NSUInteger)to;

/**
 *  发布feed或comment时 指定的唯一id，需要传入userID
 **/
+ (NSString*)uniqueContentId:(NSString*)userID;

// return advertising Identifier if success, or return @""
+ (NSString *)advertisingIdentifier;

/**
 * 【外观设计模式】使用OpenUDID等技术实现的获取用户设备唯一标识
 **/
+ (NSString *)udid;

/*
 *判断所上传图片是否合乎规格
 */
+ (BOOL)imageSizeLegal:(UIImage *)image;

+ (NSUInteger)unreadMessageCount;

/*
 *将可变参数的转化为一个数组
 */
+(NSArray*)arrayWithArgs:(id)firstArg,...;

/*
 *截屏
 */
+(UIImage *)screenshot;


/*
 *动画效果
 */
+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount; //旋转
+(CABasicAnimation *)movepoint:(CGPoint )point; //点移动
+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes; //路径动画
+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes; //组合动画
+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes; //缩放
+(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y; //纵向移动
+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x;
+(CABasicAnimation *)opacityForever_Animation:(float)time; //永久闪烁的动画
+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time;//有闪烁次数的动画
@end

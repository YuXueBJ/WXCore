//
//  WXHomeTableViewObject.h
//  WXCore
//
//  Created by 朱洪伟 on 15/10/24.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HomeTableViewStyle) {
    HomeTableViewStyleNone,
    HomeTableViewStyle_Colleague,
    HomeTableViewStyle_Other,
    HomeTableViewStyleDefault NS_ENUM_AVAILABLE_IOS(7_0)
};

@interface WXHomeTableViewObject : NSObject

@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * subTitle;
@property (nonatomic,strong)NSString * imageUrl;
@property (nonatomic,assign)HomeTableViewStyle inputStype;

-(instancetype)initWithJson:(NSDictionary*)object;
@end

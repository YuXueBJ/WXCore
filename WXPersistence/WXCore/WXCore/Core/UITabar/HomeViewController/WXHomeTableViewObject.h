//
//  WXHomeTableViewObject.h
//  WXCore
//
//  Created by 朱洪伟 on 15/10/24.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXHomeTableViewObject : NSObject

@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * subTitle;
@property (nonatomic,strong)NSString * imageUrl;
-(instancetype)initWithJson:(NSDictionary*)object;
@end

//
//  HomeDataObject.h
//  TestPersistence
//
//  Created by 朱洪伟 on 15/12/12.
//  Copyright © 2015年 个人博客：www.zhwios.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSPersistenceObject.h"

@interface HomeDataObject : WSPersistenceObject

@property (nonatomic,copy)NSString * homeName;
@property (nonatomic,copy)NSString * homeId;
@property (nonatomic,copy)NSString * homeText;
- (id)initWithJson:(NSDictionary *)json;
@end

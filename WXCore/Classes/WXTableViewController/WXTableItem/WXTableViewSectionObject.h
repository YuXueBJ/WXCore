//
//  WXTableViewSectionObject.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXTableViewSectionObject : NSObject
@property (nonatomic, copy) NSString *letter;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) id userInfo;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, copy) NSString *footerTitle;
@end

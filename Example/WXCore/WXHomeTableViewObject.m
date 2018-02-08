//
//  WXHomeTableViewObject.m
//  WXCore
//
//  Created by 朱洪伟 on 15/10/24.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXHomeTableViewObject.h"

@implementation WXHomeTableViewObject
-(instancetype)initWithJson:(NSDictionary*)object{
    self = [super init];
    if (self) {
        self.title = [object objectForKey:@"title"];
        self.subTitle = [object objectForKey:@"sub_title"];
        self.imageUrl = [object objectForKey:@"imgUrl"];
        
        NSNumber * temp = [object objectForKey:@"sub_Type"];
        self.inputStype = [temp integerValue];
    }
    return self;
}
@end

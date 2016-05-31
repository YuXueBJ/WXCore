//
//  HomeDataObject.m
//  TestPersistence
//
//  Created by 朱洪伟 on 15/12/12.
//  Copyright © 2015年 个人博客：www.zhwios.com. All rights reserved.
//

#import "HomeDataObject.h"

static NSString * kHomeName = @"name";
static NSString * kHomeID   = @"id";
static NSString * kHomeText = @"text";



@implementation HomeDataObject

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        self.homeName   = [json objectForKey:kHomeName];
        self.homeId     = [json objectForKey:kHomeID];
        self.homeText   = [json objectForKey:kHomeText];
    }
    
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
     [aCoder encodeObject:self.homeName        forKey:kHomeName];
     [aCoder encodeObject:self.homeId          forKey:kHomeID];
     [aCoder encodeObject:self.homeText        forKey:kHomeText];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self){
        
        self.homeName    = [aDecoder decodeObjectForKey:kHomeName];
        self.homeId      = [aDecoder decodeObjectForKey:kHomeID];
        self.homeText    = [aDecoder decodeObjectForKey:kHomeText];
    }
    return self;
}

@end

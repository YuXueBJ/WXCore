//
//  WSPersistenceUtil.m
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import "WSPersistenceUtil.h"

@implementation WSPersistenceUtil

+ (NSString *)convert2DatabaseNameFrom:(NSString *)src {
    NSMutableString *ret = [NSMutableString string];
    for (int i = 0; i < [src length]; i++) {
        NSRange sRange = NSMakeRange(i, 1);
        NSString *oneChar = [src substringWithRange:sRange];
        if ([oneChar isEqualToString:[oneChar uppercaseString]] && i > 0)
            [ret appendFormat:@"_%@", [oneChar lowercaseString]];
        else
            [ret appendString:[oneChar lowercaseString]];
    }
    return ret;
}

@end

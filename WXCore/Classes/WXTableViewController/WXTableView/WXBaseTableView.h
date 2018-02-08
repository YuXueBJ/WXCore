//
//  WXBaseTableView.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXBaseTableView : UITableView
{
@private
    
    CGFloat             _contentOrigin;
    
    BOOL _showShadows;
    
    //    CAGradientLayer* _originShadow;
    //    CAGradientLayer* _topShadow;
    //    CAGradientLayer* _bottomShadow;
}

@property (nonatomic)         CGFloat             contentOrigin;
@property  (nonatomic)         BOOL                showShadows;
@end

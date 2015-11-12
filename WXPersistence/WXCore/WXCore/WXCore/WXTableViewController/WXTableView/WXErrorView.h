//
//  WXErrorView.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXErrorView : UIView
{
    UIImageView*  _imageView;
    UILabel*      _subtitleView;
    UIButton*     _titleButton;
}
@property (nonatomic, retain) UIImage*  image;
@property (nonatomic, retain) UIImage*  titleImage;
@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* subtitle;

- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle image:(UIImage*)image;
- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle titleImage:(UIImage*)tImage watermarkImage:(UIImage *)wImage;
- (void)addTarget:(id)target action:(SEL)action;// forControlEvents:(UIControlEvents)controlEvents;
@end

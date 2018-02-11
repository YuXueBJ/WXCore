//
//  WXErrorView.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXErrorView.h"
#import "WXCode.h"
#import "Masonry.h"

@implementation WXErrorView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle image:(UIImage*)image
{
    if (self = [self init]) {
        self.title = title;
        self.subtitle = subtitle;
        self.image = image;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle titleImage:(UIImage*)tImage watermarkImage:(UIImage *)wImage
{
    if (self = [self init]) {
        self.title = title;
        self.subtitle = subtitle;
        self.image = wImage;
        self.titleImage = tImage;
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
        //        [self setBackgroundColor:[UIColor blueColor]];
        
        _titleButton = [[UIButton alloc] init];
        _titleButton.backgroundColor = [UIColor clearColor];
        _titleButton.userInteractionEnabled = NO; // 默认无操作
        [_titleButton setTitleColor:RGBCOLOR(153, 153, 153)
                           forState:UIControlStateNormal];
        [_titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [_titleButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_titleButton.titleLabel setNumberOfLines:0];// 换行
        [_titleButton setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
        [self addSubview:_titleButton];
        
        _subtitleView = [[UILabel alloc] init];
        _subtitleView.backgroundColor = [UIColor clearColor];
        _subtitleView.textColor = RGBCOLOR(153, 153, 153);
        _subtitleView.font = [UIFont boldSystemFontOfSize:15.0f];
        _subtitleView.textAlignment = NSTextAlignmentCenter;
        _subtitleView.numberOfLines = 0;
        [self addSubview:_subtitleView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@100);
            make.height.equalTo(@100);
            make.centerY.equalTo(self.mas_centerY).offset(-160);
        }];
        [_subtitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@30);
            make.top.equalTo(_imageView.mas_bottom).offset(0);
            make.centerX.equalTo(self.mas_centerX);
        }];
        [_titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@30);
            make.top.equalTo(_subtitleView.mas_bottom).offset(10);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Action
- (void)addTarget:(id)target action:(SEL)action
{
    _imageView.userInteractionEnabled = YES;
    _titleButton.userInteractionEnabled = YES;
    [_titleButton addTarget:target
                     action:action
           forControlEvents:UIControlEventTouchUpInside];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)title {
    return _titleButton.currentTitle;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTitle:(NSString*)title {
    [_titleButton setTitle:title forState:UIControlStateNormal];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitle {
    return _subtitleView.text;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSubtitle:(NSString*)subtitle {
    _subtitleView.text = subtitle;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)image {
    return _imageView.image;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setImage:(UIImage*)image {
    _imageView.image = image;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)titleImage {
    return _titleButton.currentBackgroundImage;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTitleImage:(UIImage*)image {
    [_titleButton setBackgroundImage:image forState:UIControlStateNormal];
}


@end

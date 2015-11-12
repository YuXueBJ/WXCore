//
//  WXErrorView.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXErrorView.h"


static const CGFloat kVPadding1 = 30;
static const CGFloat kVPadding2 = 20;
static const CGFloat kHPadding  = 10;




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
- (void)layoutSubviews {
    _subtitleView.size = [_subtitleView sizeThatFits:CGSizeMake(self.width - kHPadding*2, 0)];
    //    [_titleButton sizeToFit];
    [_imageView sizeToFit];
    CGFloat maxHeight = _imageView.height + _titleButton.height + _subtitleView.height
    + kVPadding1 + kVPadding2;
    BOOL canShowImage = _imageView.image && self.height > maxHeight;
    
    CGFloat totalHeight = 0;
    
    if (canShowImage) {
        totalHeight += _imageView.height;
    }
    if (_titleButton.currentTitle.length) {
        totalHeight += (totalHeight ? kVPadding1 : 0) + _titleButton.height;
    }
    if (_subtitleView.text.length) {
        totalHeight += (totalHeight ? kVPadding2 : 0) + _subtitleView.height;
    }
    
    //    CGFloat top = floor(self.height/2 - totalHeight/2) - 50;
    CGFloat top = floor(self.height/2 - totalHeight/2)-20;
    if (!([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)) {
        top+=20;
    }
    
    if (canShowImage) {
        _imageView.origin = CGPointMake(floor(self.width/2 - _imageView.width/2), top);
        _imageView.hidden = NO;
        top += _imageView.height + kVPadding1;
        
    } else {
        _imageView.hidden = YES;
    }
    if (_titleButton.currentTitle.length) {
        CGFloat anchorWidth = self.width-20.0f;
        CGSize titleViewSize = [_titleButton.currentTitle measureTextSize:_titleButton.titleLabel.font desWidth:self.height/2];
//        [_titleButton.currentTitle sizeWithFont:_titleButton.titleLabel.font
//                                                     constrainedToSize:CGSizeMake(anchorWidth, self.height/2)
//                                                         lineBreakMode:NSLineBreakByWordWrapping];
        titleViewSize.height += 10.0f;
        if (titleViewSize.width < anchorWidth) {
            titleViewSize.width = anchorWidth;
        }
        _titleButton.size = titleViewSize;
        _titleButton.origin = CGPointMake(floor(self.width/2 - _titleButton.width/2), top-20);
        top += _titleButton.height + kVPadding2;
    }
    if (_subtitleView.text.length) {
        _subtitleView.origin = CGPointMake(floor(self.width/2 - _subtitleView.width/2), top);
    }
}


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

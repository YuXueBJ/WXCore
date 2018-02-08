//
//  UIBarButtonItem+Image.m
//  XYCore
//
//  Created by sunyuping on 13-1-21.
//  Copyright (c) 2013年 Xingyun.cn. All rights reserved.
//

#import "UIBarButtonItem+Image.h"

//#import "PKResManager.h"

@implementation UIBarButtonItem (CustomImage)

- (void)setButtonAttribute:(NSDictionary*)dic
{
    if ([self.customView isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*)self.customView;
        UIFont* font = [dic objectForKey:@"font"];
        if (font != nil && [font isKindOfClass:[UIFont class]]) {
            [button.titleLabel setFont:font];
        }
        NSNumber* shadowOffset = [dic objectForKey:@"shadowOffset"];
        if (shadowOffset != nil && [shadowOffset isKindOfClass:[NSNumber class]]) {
            [button.titleLabel setShadowOffset:shadowOffset.CGSizeValue];
        }
        NSNumber* buttonWidth = [dic objectForKey:@"width"];
        if (buttonWidth != nil && [buttonWidth isKindOfClass:[NSNumber class]]) {
            CGRect rc = button.frame;
            rc.size.width = buttonWidth.floatValue;
            button.frame = rc;
        }
        UIColor* titleColorNormal = [dic objectForKey:@"titleColorNormal"];
        if (titleColorNormal != nil && [titleColorNormal isKindOfClass:[UIColor class]]) {
            [button setTitleColor:titleColorNormal forState:UIControlStateNormal];
        }
        UIColor* shadowColorNormal = [dic objectForKey:@"shadowColorNormal"];
        if (shadowColorNormal != nil && [shadowColorNormal isKindOfClass:[UIColor class]]) {
            [button setTitleShadowColor:shadowColorNormal forState:UIControlStateNormal];
        }
        UIColor* titleColorHighlighted = [dic objectForKey:@"titleColorHighlighted"];
        if (titleColorHighlighted != nil && [titleColorHighlighted isKindOfClass:[UIColor class]]) {
            [button setTitleColor:titleColorHighlighted forState:UIControlStateHighlighted];
        }
        UIColor* shadowColorHightlighted = [dic objectForKey:@"shadowColorHightlighted"];
        if (shadowColorHightlighted != nil && [shadowColorHightlighted isKindOfClass:[UIColor class]]) {
            [button setTitleShadowColor:shadowColorHightlighted forState:UIControlStateHighlighted];
        }
    }
}

+ (UIBarButtonItem *)rsBarButtonItemWithTitle:(NSString *)title
                                        image:(UIImage *)image
                             heightLightImage:(UIImage *)hlImage
                                 disableImage:(UIImage *)disImage
                                       target:(id)target
                                       action:(SEL)selector
{
        UIButton* customButton = [self rsCustomBarButtonWithTitle:title
                                                            image:image
                                                 heightLightImage:hlImage
                                                     disableImage:disImage
                                                           target:target
                                                           action:selector];
        CGSize sizeOfTitle = CGSizeZero;
        if (title!=nil && ![title isEqualToString:@""]) {
            sizeOfTitle = [title sizeWithFont:customButton.titleLabel.font
                            constrainedToSize:CGSizeMake(100.0f, 22.0f)
                                lineBreakMode:NSLineBreakByTruncatingMiddle];
        }
        if (sizeOfTitle.width <= 0.0f) {
            [customButton setFrame:CGRectMake(0.0f,
                                              0.0f,
                                              customButton.currentBackgroundImage.size.width,
                                              customButton.currentBackgroundImage.size.height)];
        } else {
            [customButton setFrame:CGRectMake(0.0f,
                                              0.0f,
                                              sizeOfTitle.width+20.0f,
                                              customButton.currentBackgroundImage.size.height)];
        }
        
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
        barBtnItem.width = 44;//[customButton currentBackgroundImage].size.width;
        return barBtnItem;
}

+ (UIBarButtonItem *)rsBarButtonItemWithTitle:(NSString *)title
                                       target:(id)target
                                       action:(SEL)selector{
    UIImage *imageOri = [UIImage imageNamed:@"navigation_button_text"];
    UIImage* image = [imageOri stretchableImageWithLeftCapWidth:imageOri.size.width/2.0f topCapHeight:imageOri.size.height/2.0f];
    //stretchableImageWithLeftCapWidth:18.0f
    //topCapHeight:18.0f];
    UIImage *hlImage = nil;//[UIImage imageForKey:@"navigation_button_blue_hl"];
    //stretchableImageWithLeftCapWidth:18.0f
    //topCapHeight:18.0f];
    UIImage* disImage = [UIImage imageNamed:@"navigation_button_disable"];
    return [UIBarButtonItem rsBarButtonItemWithTitle:title
                                               image:image
                                    heightLightImage:hlImage
                                        disableImage:[disImage stretchableImageWithLeftCapWidth:imageOri.size.width/2.0f topCapHeight:imageOri.size.height/2.0f]
                                              target:target
                                              action:selector];
}

+ (UIButton*)rsCustomBarButtonWithTitle:(NSString*)title
                                  image:(UIImage *)image
                       heightLightImage:(UIImage *)hlImage
                           disableImage:(UIImage *)disImage
                                 target:(id)target
                                 action:(SEL)selector
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setBackgroundColor:[UIColor clearColor]];
    [customButton setBackgroundImage:image forState:UIControlStateNormal];
    [customButton setBackgroundImage:hlImage forState:UIControlStateHighlighted];
    if (nil != disImage)
    {
        [customButton setBackgroundImage:disImage forState:UIControlStateDisabled];
    }

    if (title!=nil && title.length > 0) {
        [customButton setTitle:title forState:UIControlStateNormal];
        [customButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [customButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [customButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    [customButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return customButton;
}

@end

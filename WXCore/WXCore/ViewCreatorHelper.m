//
//  ViewCreatorHelper.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 田立彬 on 13-5-29.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "ViewCreatorHelper.h"

//#import "RTLabel.h"
//#import "CBAutoScrollLabel.h"
//#import "SevenSwitch.h"
//#import "InsetsLabel.h"
//#import "MDCustomSwitch.h"

@implementation ViewCreatorHelper



+ (UIButton*)createButtonWithTitle:(NSString*)title
                             frame:(CGRect)frame
                        normaImage:(NSString*)normalImageKey
                    highlitedImage:(NSString*)highlitedImageKey
                      disableImage:(NSString*)disableImageKey
                            target:(id)target
                            action:(SEL)action
{
    UIImage* normalImage = [UIImage imageNamed:normalImageKey];

    UIImage* highlitedImage = nil;
    if (highlitedImageKey != nil) {
        highlitedImage = [UIImage imageNamed:highlitedImageKey];
    }
    
    UIImage* disableImage = nil;
    if (disableImageKey != nil) {
        disableImage = [UIImage imageNamed:disableImageKey];
    }

    
    return [self createButtonWithTitle:title frame:frame image:normalImage hlImage:highlitedImage disImage:disableImage target:target action:action];
}

+ (UIButton*)createButtonWithTitle:(NSString*)title
                             frame:(CGRect)frame
                             image:(UIImage*)normalImage
                           hlImage:(UIImage*)highlitedImage
                          disImage:(UIImage*)disableImage
                            target:(id)target
                            action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (normalImage != nil) {
        CGSize size = normalImage.size;
        [button setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:size.width/2.0f
                                                                    topCapHeight:size.height/2.0f]
                          forState:UIControlStateNormal];
    }
    
    if (highlitedImage != nil) {
        CGSize size = highlitedImage.size;
        UIImage* image = [highlitedImage stretchableImageWithLeftCapWidth:size.width/2.0f
                                                             topCapHeight:size.height/2.0f];
        [button setBackgroundImage:image
                          forState:UIControlStateHighlighted];
        [button setBackgroundImage:image
                          forState:UIControlStateSelected];
    }
    
    if (disableImage != nil) {
        CGSize size = disableImage.size;
        [button setBackgroundImage:[disableImage stretchableImageWithLeftCapWidth:size.width/2.0f
                                                                     topCapHeight:size.height/2.0f]
                          forState:UIControlStateDisabled];
    }
    
    if (target != nil && action != nil) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    return button;

}

//+ (UIButton*)createFrameButtonWithTitle:(NSString*)title
//                                  frame:(CGRect)frame
//                                 target:(id)target
//                                 action:(SEL)action
//{
//    UIButton* button = [self createButtonWithTitle:title
//                                             frame:frame
//                                        normaImage:@"btn_white.png"
//                                    highlitedImage:@"btn_white_click.png"
//                                      disableImage:nil
//                                            target:target
//                                            action:action];
//    [button setTitleColor:MAIN_ACTIVE_COLOR forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    
//    return button;
//}
//
//+ (UIButton*)createRedFrameButtonWithTitle:(NSString*)title
//                                     frame:(CGRect)frame
//                                    target:(id)target
//                                    action:(SEL)action
//{
//    UIButton* button = [self createButtonWithTitle:title
//                                             frame:frame
//                                        normaImage:@"btn_red.png"
//                                    highlitedImage:@"btn_red_click.png"
//                                      disableImage:nil
//                                            target:target
//                                            action:action];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    
//    return button;
//}
//


+ (UIButton*)createIconButtonWithFrame:(CGRect)frame
                            normaImage:(NSString*)normalImageKey
                        highlitedImage:(NSString*)highlitedImageKey
                          disableImage:(NSString*)disableImageKey
                                target:(id)target
                                action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    if (normalImageKey != nil) {
        UIImage* image = [UIImage imageNamed:normalImageKey];
        if (image != nil) {
            [button setImage:image forState:UIControlStateNormal];
        }
    }
    
    if (highlitedImageKey != nil) {
        UIImage* image = [UIImage imageNamed:highlitedImageKey];
        if (image != nil) {
            [button setImage:image forState:UIControlStateHighlighted];
        }
    }
    
    if (disableImageKey != nil) {
        UIImage* image = [UIImage imageNamed:disableImageKey];
        if (image != nil) {
            [button setImage:image forState:UIControlStateDisabled];
        }
    }
    
    if (target != nil && action != nil) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

    return button;
}

+ (UIButton *)createButtonWithTitle:(NSString *)title
                              frame:(CGRect)frame
                              color:(UIColor *)color
                            hlColor:(UIColor *)hlColor
                             target:(id)target
                             action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(title){
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if(!CGRectEqualToRect(frame, CGRectZero)){
        button.frame = frame;
    }
    if(color != nil){
//        [button setBackgroundImage:[UIImage imageWithColor:color size:frame.size] forState:UIControlStateNormal];
    }
    
    if(hlColor != nil){
//        [button setBackgroundImage:[UIImage imageWithColor:hlColor size:frame.size] forState:UIControlStateHighlighted];
    }
    
    if(target != nil && action != nil){
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

+ (void)initButton:(UIButton *)button
             title:(NSString *)title
             frame:(CGRect)frame
             color:(UIColor *)color
           hlColor:(UIColor *)hlColor
            target:(id)target action:(SEL)action
{
    if(title){
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if(!CGRectEqualToRect(frame, CGRectZero)){
        button.frame = frame;
    }
    if(color){
//        [button setBackgroundImage:[UIImage imageWithColor:color size:frame.size] forState:UIControlStateNormal];
    }
    
    if(hlColor){
//        [button setBackgroundImage:[UIImage imageWithColor:hlColor size:frame.size] forState:UIControlStateHighlighted];
    }
    
    if(target && action){
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

}


+ (UILabel*)createLabelWithTitle:(NSString*)title
                            font:(UIFont*)font
                           frame:(CGRect)frame
                       textColor:(UIColor*)textColor
                   textAlignment:(NSTextAlignment)textAlignment
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    if (font != nil) {
        label.font = font;
    }
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

//+ (InsetsLabel*)createInsetsLabelWithTitle:(NSString*)title
//                                      font:(UIFont*)font
//                                     space:(CGFloat)space
//                                 textColor:(UIColor*)textColor
//                             textAlignment:(NSTextAlignment)textAlignment
//{
//    UIEdgeInsets insets = UIEdgeInsetsMake(space, 0.0f, 0.0f, 0.0f);
//    InsetsLabel* label = [[InsetsLabel alloc] initWithInsets:insets];
//    label.text = title;
//    if (font != nil) {
//        label.font = font;
//    }
//    label.textColor = textColor;
//    label.textAlignment = textAlignment;
//    label.backgroundColor = [UIColor clearColor];
//    
//    return label;
//}

+ (UISwitch*)createSwitchWithFram:(CGRect)frame
                     switchViewOn:(BOOL)on
                           target:(id)target
                           action:(SEL)action
{
    UISwitch * switchView = [[UISwitch alloc] initWithFrame:frame];
    switchView.on=on;
    [switchView addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return switchView;
}
+ (UITextField*)createTextFiledWithFrame:(CGRect)frame
                                delegate:(id<UITextFieldDelegate>)delegate
                             placeHolder:(NSString*)placeHolder
                            keyboardType:(UIKeyboardType)keyboardType
                           returnKeyType:(UIReturnKeyType)returnKeyType
{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.delegate = delegate;
    textField.placeholder = placeHolder;
    textField.keyboardType = keyboardType;
    textField.returnKeyType = returnKeyType;
    
    UIView* leftView = [self emptyViewWithWidth:10.0f];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    //    textField.rightViewMode = UITextFieldViewModeAlways;
    //    textField.rightView = leftView;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textColor = [UIColor blackColor];
    
    return textField;
}
+ (UITextView*)createTextViewWithFrame:(CGRect)frame
                              delegate:(id<UITextViewDelegate>)delegate
                           placeHolder:(NSString*)placeHolder
                          keyboardType:(UIKeyboardType)keyboardType
                         returnKeyType:(UIReturnKeyType)returnKeyType
{
    UITextView * textView=[[UITextView alloc] initWithFrame:frame];
    textView.delegate=delegate;
    textView.keyboardType = keyboardType;
    textView.returnKeyType = returnKeyType;
    textView.scrollEnabled = YES;//是否可以拖动
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.textColor = [UIColor blackColor];
    
    return textView;
}


//+ (RTLabel*)createRTLabelWithFrame:(CGRect)frame
//                              font:(UIFont*)font
//                         textColor:(UIColor*)textColor
//                   backgroundColor:(UIColor*)backgroundColor
//{
//    RTLabel* label = [[RTLabel alloc] initWithFrame:frame];
//    [label setParagraphReplacement:@""];
//    [label setTextColor:textColor];
//    [label setFont:font];
//    [label setBackgroundColor:backgroundColor];
//    
//    return label;
//}
//
//+ (CBAutoScrollLabel*)createAutoScrollLabelWithFrame:(CGRect)frame
//                                                font:(UIFont*)font
//                                           textColor:(UIColor*)textColor
//                                     backgroundColor:(UIColor*)backgroundColor
//{
//    CBAutoScrollLabel* navLabel = [[CBAutoScrollLabel alloc] initWithFrame:frame];
//    navLabel.textColor = textColor;
//    navLabel.labelSpacing = 35; // distance between start and end labels
//    navLabel.pauseInterval = 0.3; // seconds of pause before scrolling starts again
//    navLabel.scrollSpeed = 30; // pixels per second
//    navLabel.textAlignment = UITextAlignmentCenter; // centers text when no auto-scrolling is applied
//    navLabel.fadeLength = 12.f;
//    navLabel.font = font;
//    navLabel.backgroundColor = backgroundColor;
//    
//    return navLabel;
//}
//

+ (UIView*)lineWithWidth:(CGFloat)width
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat h = 1.0f;
    if (screenScale > 0.0f) {
        h = 1.0f / screenScale;
    }
    
    CGRect rc = CGRectMake(0.0f, 0.0f, width, h);
    UIView* lineView = [[UIView alloc] initWithFrame:rc];
    lineView.backgroundColor = RGBCOLOR(229, 229, 229);//[ColorUtility colorWithHexString:@"#DCDCDC"];
    return lineView;
}

+ (UIView*)vLineWithHeight:(CGFloat)height
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat w = 1.0f;
    if (screenScale > 0.0f) {
        w = 1.0f / screenScale;
    }
    
    CGRect rc = CGRectMake(0.0f, 0.0f, w, height);
    UIView* lineView = [[UIView alloc] initWithFrame:rc];
    lineView.backgroundColor = RGBCOLOR(200.0f, 200.0f, 200.0f);
    
    return lineView;
}

+(UIView *)lineWithWidth:(CGFloat)width color:(UIColor *)color
{
    UIView * view = [self lineWithWidth:width];
    view.backgroundColor = color;
    return view;
}

+(UIView *)vLineWithHeight:(CGFloat)height color:(UIColor *)color
{
    UIView * view = [self vLineWithHeight:height];
    view.backgroundColor = color;
    return view;
}


//+ (SevenSwitch*)createSwitchWithTarget:(id)target
//                                action:(SEL)action
//{
//    CGRect rc = CGRectMake(0, 0, 40, 24);
//    SevenSwitch* sw = [[SevenSwitch alloc] initWithFrame:rc];
//    sw.onColor = RGBCOLOR(30.0f, 168.0f, 157.0f);
//    sw.inactiveColor = RGBCOLOR(250.0f, 250.0f, 250.0f);
//    sw.isRounded = YES;
//    sw.backgroundColor = [UIColor clearColor];
//    if (target != nil && action != nil) {
//        [sw addTarget:target action:action forControlEvents:UIControlEventValueChanged];
//    }
//    
//    return sw;
//}


+ (void)addBorderForView:(UIView *)view
{
    UIColor* color = [UIColor lightGrayColor];
    [self addBorderForView:view color:color];
}

+ (void)addBorderForView:(UIView*)view color:(UIColor*)color
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat h = 1.0f;
    if (screenScale > 0.0f) {
        h = 1.0f / screenScale;
    }
    view.layer.borderWidth = h;
    view.layer.borderColor = color.CGColor;
}


+ (UIView*)emptyViewWithWidth:(CGFloat)width
{
    CGRect rc = CGRectMake(0.0f, 0.0f, width, 1.0f);
    return [self emptyViewWithFrame:rc];
}

+ (UIView*)emptyViewWithHeight:(CGFloat)height
{
    CGRect rc = CGRectMake(0.0f, 0.0f, 1.0f, height);
    return [self emptyViewWithFrame:rc];
}

+ (UIView*)emptyViewWithFrame:(CGRect)frame
{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


@end

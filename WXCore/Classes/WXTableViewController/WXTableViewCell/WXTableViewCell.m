//
//  WXTableViewCell.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXTableViewCell.h"
#import "WXCode.h"

@implementation WXTableViewCell

@synthesize object = _object;
@synthesize indexPath;
@synthesize userInteractionBlockSafe = _userInteractionBlockSafe;
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    if (object==nil) {
        return 0;
    }
    return 44;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
        //        self.textLabel.font = TTSTYLEVAR(tableFont);
        //        self.textLabel.textColor = TTSTYLEVAR(textColor);
        //        self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        //        self.textLabel.textAlignment = UITextAlignmentLeft;
        //        self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        //        self.textLabel.adjustsFontSizeToFitWidth = YES;
        //
        //        self.detailTextLabel.font = TTSTYLEVAR(font);
        //        self.detailTextLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        //        self.detailTextLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        //        self.detailTextLabel.textAlignment = UITextAlignmentLeft;
        //        self.detailTextLabel.contentMode = UIViewContentModeTop;
        //        self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        //        self.detailTextLabel.numberOfLines = kTableMessageTextLineCount;
        
        self.userInteractionBlockSafe = NO;
        self.backgroundColor = [UIColor clearColor];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
        {
            self.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        else
        {
            UIView *selectedView = [[UIView alloc] init];
            selectedView.backgroundColor = RGBCOLOR(217, 217, 217);
            self.selectedBackgroundView = selectedView;
        }
        
    }
    
    return self;
}

- (void)setObject:(id)object {
    if (object != _object) {
        if (_object) {
            [self finishObserveObjectProperty];
        }
        _object = object;
        if (_object)
            [self startObserveObjectProperty];
    }
}
//object属性observer相关
/**开始监听object属性,在subclass中通过该方法可自定义添加监听的属性*/
- (void)startObserveObjectProperty
{
    
}
/**清除监听,在subclass中应该清除已添加的属性*/
- (void)finishObserveObjectProperty
{
    
}

/***监听一个属性*/
- (void)addObservedProperty:(NSString *)property{
    [_object addObserver:self forKeyPath:property
                 options:NSKeyValueObservingOptionNew
                 context:nil];
}
/**移出监听*/
- (void)removeObservedProperty:(NSString *)property{
    [_object removeObserver:self forKeyPath:property];
}
/**属性发生变动的回调*/
- (void)objectPropertyChanged:(NSString *)property
{
    
}
/**阻塞自身*/
- (void)detachInteractionBlock
{
    self.userInteractionEnabled = NO;
    [NSThread detachNewThreadSelector:@selector(cancelInteractionBlock) toTarget:self withObject:nil];
}
/**解除阻塞*/
- (void)cancelInteractionBlock{
    if (![NSThread isMainThread]) {
        [NSThread sleepForTimeInterval:XYT_CELL_INTERACTION_BLOCK_DURATION];
        self.userInteractionEnabled = YES;
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object != _object) {
        [object removeObserver:self forKeyPath:keyPath];
    }
    else {
        [self objectPropertyChanged:keyPath];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.userInteractionBlockSafe) {
        [self detachInteractionBlock];
    }
    [super touchesEnded:touches withEvent:event];
}

+ (BOOL)isNibOrCored
{
    return NO;
}
+ (BOOL)isCacheCell
{
    return NO;
}
@end

//
//  WXTableViewDataSource.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXTableViewDataSource <UITableViewDataSource, UISearchDisplayDelegate>

+ (NSArray *)lettersForSectionsWithSearch:(BOOL)search summary:(BOOL)summary;

- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object;

- (NSString *)tableView:(UITableView *)tableView labelForObject:(id)object;

- (NSIndexPath *)tableView:(UITableView *)tableView indexPathForObject:(id)object;

- (void)tableView:(UITableView *)tableView cell:(UITableViewCell *)cell willAppearAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)titleForLoading:(BOOL)reloading;

- (UIImage*)imageForEmpty;

- (UIImage*)titleImageForEmpty;

- (NSString*)titleForEmpty;

- (NSString*)subtitleForEmpty;

- (UIImage*)imageForError:(NSError*)error;

- (NSString*)titleForError:(NSError*)error;

- (NSString*)subtitleForError:(NSError*)error;

- (BOOL)empty;

- (BOOL)buttonExecutable;

- (UIEdgeInsets)emptyViewEdgeInsets;

@optional

- (NSIndexPath *)tableView:(UITableView *)tableView willUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)tableView:(UITableView *)tableView willInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)tableView:(UITableView *)tableView willRemoveObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

- (void)search:(NSString *)text;

@end

@interface WXTableViewDataSource : NSObject<WXTableViewDataSource>

@end

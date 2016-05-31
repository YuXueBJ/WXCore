//
//  AddressBookModel.h
//  WXCore
//
//  Created by 朱洪伟 on 15/11/1.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface AddressBookModel : NSObject
@property (nonatomic,copy)NSString * personName;
@property (nonatomic,copy)NSString * lastname;
@property (nonatomic,copy)NSString * middlename;
@property (nonatomic,copy)NSString * prefix;
@property (nonatomic,copy)NSString * suffix;
@property (nonatomic,copy)NSString * nickname;
@property (nonatomic,copy)NSString * firstnamePhonetic;
@property (nonatomic,copy)NSString * lastnamePhonetic;
@property (nonatomic,copy)NSString * middlenamePhonetic;
@property (nonatomic,copy)NSString * organization;
@property (nonatomic,copy)NSString * jobtitle;
@property (nonatomic,copy)NSString * department;
@property (nonatomic,strong)NSDate * birthday;
@property (nonatomic,copy)NSString * note;

@property (nonatomic,assign)int recordID;
@property (nonatomic,strong)NSString * tel;
@property (nonatomic,strong)NSString * email;

- (instancetype)initWithUserInfo:(ABRecordRef)info;
@end

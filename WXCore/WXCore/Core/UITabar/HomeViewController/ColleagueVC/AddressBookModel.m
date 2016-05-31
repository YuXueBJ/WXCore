//
//  AddressBookModel.m
//  WXCore
//
//  Created by 朱洪伟 on 15/11/1.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "AddressBookModel.h"


@implementation AddressBookModel
- (instancetype)initWithUserInfo:(ABRecordRef)info
{
    AddressBookModel * model = [[AddressBookModel alloc] init];
    
    ABRecordRef person = info;
    //读取firstname
    NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if(personName != nil)
        model.personName = personName;

    //读取lastname
    NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if(lastname != nil)
        model.lastname = lastname;
    
    //读取middlename
    NSString *middlename = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    if(middlename != nil)
        model.middlename = middlename;
    
    //读取prefix前缀
    NSString *prefix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
    if(prefix != nil)
        model.prefix = prefix;
    
    //读取suffix后缀
    NSString *suffix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
    if(suffix != nil)
        model.suffix = suffix;
    
    //读取nickname呢称
    NSString *nickname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
    if(nickname != nil)
        model.nickname = nickname;
    
    //读取firstname拼音音标
    NSString *firstnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
    if(firstnamePhonetic != nil)
        model.firstnamePhonetic = firstnamePhonetic;
//        NSLog(@"%@",firstnamePhonetic);
    
    //读取lastname拼音音标
    NSString *lastnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
    if(lastnamePhonetic != nil)
        model.lastnamePhonetic = lastnamePhonetic;
    
    //读取middlename拼音音标
    NSString *middlenamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
    if(middlenamePhonetic != nil)
        model.middlenamePhonetic = middlenamePhonetic;

    //读取organization公司
    NSString *organization = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
    if(organization != nil)
        model.organization = organization;
    
    //读取jobtitle工作
    NSString *jobtitle = (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
    if(jobtitle != nil)
        model.jobtitle = jobtitle;
    //读取department部门
    NSString *department = (__bridge NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
    if(department != nil)
        model.department =department;

    //读取birthday生日
    NSDate *birthday = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
    if(birthday != nil)
        model.birthday = birthday;
    //读取note备忘录
    NSString *note = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
    if(note != nil)
        model.note = note;
    //第一次添加该条记录的时间
    NSString *firstknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
    NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
    //最后一次修改該条记录的时间
    NSString *lastknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
    NSLog
    (@"最后一次修改該条记录的时间%@\n",lastknow);
    
    //获取email多值
    ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
    int emailcount = ABMultiValueGetCount(email);
    for (int x = 0; x < emailcount; x++)
    {
        //获取email Label
        NSString* emailLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
        //获取email值
        NSString* emailContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(email, x);
        //            textView.text = [textView.text stringByAppendingFormat:@"%@:%@\n",emailLabel,emailContent];
        NSLog(@"%@:%@\n",emailLabel,emailContent);
    }
    //读取地址多值
    ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
    int count = ABMultiValueGetCount(address);
    
    for(int j = 0; j < count; j++)
    {
        //获取地址Label
        NSString* addressLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, j);
        //            textView.text = [textView.text stringByAppendingFormat:@"%@\n",addressLabel];
        NSLog(@"%@\n",addressLabel);
        //获取該label下的地址6属性
        NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
        NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
        if(country != nil)
            //                textView.text = [textView.text stringByAppendingFormat:@"国家：%@\n",country];
            NSLog(@"国家：%@\n",country);
        NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
        if(city != nil)
            //                textView.text = [textView.text stringByAppendingFormat:@"城市：%@\n",city];
            NSLog(@"城市：%@\n",city);
        NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
        if(state != nil)
            //                textView.text = [textView.text stringByAppendingFormat:@"省：%@\n",state];
            NSLog(@"省：%@\n",state);
        NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
        if(street != nil)
            //                textView.text = [textView.text stringByAppendingFormat:@"街道：%@\n",street];
            NSLog(@"街道：%@\n",street);
        NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
        if(zip != nil)
            //                textView.text = [textView.text stringByAppendingFormat:@"邮编：%@\n",zip];
            NSLog(@"邮编：%@\n",zip);
        NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
        if(coutntrycode != nil)
            //                textView.text = [textView.text stringByAppendingFormat:@"国家编号：%@\n",coutntrycode];
            NSLog(@"国家编号：%@\n",coutntrycode);
    }
    
    //获取dates多值
    ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
    int datescount = ABMultiValueGetCount(dates);
    for (int y = 0; y < datescount; y++)
    {
        //获取dates Label
        NSString* datesLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
        //获取dates值
        NSString* datesContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(dates, y);
        //            textView.text = [textView.text stringByAppendingFormat:@"%@:%@\n",datesLabel,datesContent];
        NSLog(@"%@:%@\n",datesLabel,datesContent);
    }
    //获取kind值
    CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
    if (recordType == kABPersonKindOrganization) {
        // it's a company
        NSLog(@"it's a company\n");
    } else {
        // it's a person, resource, or room
        NSLog(@"it's a person, resource, or room\n");
    }
    
    
    //获取IM多值
    ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
    for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
    {
        //获取IM Label
        NSString* instantMessageLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
        //            textView.text = [textView.text stringByAppendingFormat:@"%@\n",instantMessageLabel];
        NSLog(@"%@\n",instantMessageLabel);
        //获取該label下的2属性
        NSDictionary* instantMessageContent =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
        NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
        if(username != nil)
            //                textView.text = [textView.text stringByAppendingFormat:@"username：%@\n",username];
            NSLog(@"username：%@\n",username);
        NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
        if(service != nil)
            //                textView.text = [textView.text stringByAppendingFormat:@"service：%@\n",service];
            NSLog(@"service：%@\n",service);
    }
    
    //读取电话多值
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int k = 0; k<ABMultiValueGetCount(phone); k++)
    {
        //获取电话Label
        NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
        //获取該Label下的电话值
        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
        
        //            textView.text = [textView.text stringByAppendingFormat:@"%@:%@\n",personPhoneLabel,personPhone];
        NSLog(@"%@:%@\n",personPhoneLabel,personPhone);
    }
    //获取URL多值
    ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
    for (int m = 0; m < ABMultiValueGetCount(url); m++)
    {
        //获取电话Label
        NSString * urlLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
        //获取該Label下的电话值
        NSString * urlContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(url,m);
        
        //            textView.text = [textView.text stringByAppendingFormat:@"%@:%@\n",urlLabel,urlContent];
        NSLog(@"%@:%@\n",urlLabel,urlContent);
    }
    //读取照片
    NSData *image = (__bridge NSData*)ABPersonCopyImageData(person);
    UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 50, 50)];
    [myImage setImage:[UIImage imageWithData:image]];
    myImage.opaque = YES;
    //        [textView addSubview:myImage];
    return model;
}
@end

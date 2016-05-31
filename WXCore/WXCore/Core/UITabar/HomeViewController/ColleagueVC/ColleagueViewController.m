//
//  ColleagueViewController.m
//  WXCore
//
//  Created by 朱洪伟 on 15/11/1.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "ColleagueViewController.h"
#import "ColleagueDataSource.h"
#import "AddressBookModel.h"
#import <AddressBook/AddressBook.h>

@interface ColleagueViewController ()
@property (nonatomic,assign)ABAddressBookRef addressBook;
@property (nonatomic,strong)NSMutableArray * addressBookTemp;
@property (nonatomic,assign)NSInteger requestPage;

@end

@implementation ColleagueViewController

- (void)initializationTableView{
    
    self.dataSource = [[ColleagueDataSource alloc] init];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsPullToRefresh =YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyView.userInteractionEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableView.frame = CGRectMake(0, 65, self.view.width, self.view.height-65);

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializationTableView];
    [self createAddressBook];
    [self readPeopleInfo];
    
    [self showEmpty:YES];
//    [self showError:YES];
}
/*
 移除注册函数
 */
-(void)dealloc{
    ABAddressBookUnregisterExternalChangeCallback(self.addressBook, ContactsChangeCallback, nil);
}
/*
 注册回调函数
 */
- (void)createAddressBook {
    self.addressBook = ABAddressBookCreate();
    //注册通讯录更新回调
    ABAddressBookRegisterExternalChangeCallback(self.addressBook, ContactsChangeCallback, nil);
}
/*
 回调函数，实现自己的逻辑。
 */
void ContactsChangeCallback (ABAddressBookRef addressBook,
                             CFDictionaryRef info,
                             void *context){
    
    NSLog(@"ContactsChangeCallback");
}
- (void)readPeopleInfo
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        //读取firstname
        NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if(personName != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"\n姓名：%@\n",personName];
            NSLog(@"%@",personName);
        //读取lastname
        NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if(lastname != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"%@\n",lastname];
        NSLog(@"%@",lastname);

        //读取middlename
        NSString *middlename = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        if(middlename != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"%@\n",middlename];
            NSLog(@"%@",middlename);

        //读取prefix前缀
        NSString *prefix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
        if(prefix != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"%@\n",prefix];
            NSLog(@"%@",prefix);

        //读取suffix后缀
        NSString *suffix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
        if(suffix != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"%@\n",suffix];
            NSLog(@"%@",suffix);
        //读取nickname呢称
        NSString *nickname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
        if(nickname != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"%@\n",nickname];
            NSLog(@"%@",nickname);

        
        //读取firstname拼音音标
        NSString *firstnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
        if(firstnamePhonetic != nil)
//           textView.text = [textView.text stringByAppendingFormat:@"%@\n",firstnamePhonetic];
            NSLog(@"%@",firstnamePhonetic);

        //读取lastname拼音音标
        NSString *lastnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
        if(lastnamePhonetic != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"%@\n",lastnamePhonetic];
            NSLog(@"%@",lastnamePhonetic);
        //读取middlename拼音音标
        NSString *middlenamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
        if(middlenamePhonetic != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"%@\n",middlenamePhonetic];
            NSLog(@"middlenamePhonetic");
        //读取organization公司
        NSString *organization = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        if(organization != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"%@\n",organization];
            NSLog(@"%@",organization);
        //读取jobtitle工作
        NSString *jobtitle = (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
        if(jobtitle != nil)
//           textView.text = [textView.text stringByAppendingFormat:@"%@\n",jobtitle];
            NSLog(@"%@",jobtitle);
        //读取department部门
        NSString *department = (__bridge NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
        if(department != nil)
//          textView.text = [textView.text stringByAppendingFormat:@"%@\n",department];
            NSLog(@"%@",department);
        //读取birthday生日
        NSDate *birthday = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        if(birthday != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"%@\n",birthday];
            NSLog(@"%@",birthday);
        //读取note备忘录
        NSString *note = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
        if(note != nil)
//            textView.text = [textView.text stringByAppendingFormat:@"%@\n",note];
            NSLog(@"%@",note);
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
    }
    CFRelease(results);
    CFRelease(addressBook);
    
    
}
- (void)readAllPeople{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        addressBooks = ABAddressBookCreate();
    }
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        AddressBookModel *addressBook = [[AddressBookModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [self.addressBookTemp addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)emptyViewButtonAction
{
    [self pullToRefreshAction];
}
-(void)pullToRefreshAction{
    
    if (self.loadingData) {
        return;
    }
    [self showEmpty:NO];
    [self showError:NO];
    [self startRefreshAction];
    self.loadingData = YES;
    [self requestData:0];
}
- (void)loadMoreAction
{
    if (self.loadingData) {
        return;
    }
    self.loadingData=YES;
    [self requestData:1];
}
-(void)requestData:(NSInteger)type
{
    if (type==0) {
        self.requestPage=1;
    }else{
        self.requestPage++;
    }
    
//    //{
//    /**
//     请求完成执行
//     */
    [self stopRefreshAction];
    [self setLoadingData:NO];
//
//    if ([self.dataSourceArray count]==0) {
//        [self showEmpty:YES];
//    }else{
//        [self showEmpty:NO];
//    }
//    //RequestSuccess
//    if (/* DISABLES CODE */ (1)) {
//        [(WXHomeViewDataSource*)self.dataSource reloadHomeTableViewData:self.dataSourceArray];
//        [self.tableView reloadData];
//    }else{
//        [(WXHomeViewDataSource*)self.dataSource reloadHomeTableViewData:nil];
//        [self showError:YES];
//        [self.tableView reloadData];
//    }
//    //}
    
}
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSMutableArray*)addressBookTemp
{
    if (!_addressBookTemp) {
        _addressBookTemp = [[NSMutableArray alloc] init];
    }
    return _addressBookTemp;
}
@end

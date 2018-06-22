//
//  RuntimeController.m
//  SDWebLearning
//
//  Created by peipei on 2018/5/14.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "RuntimeController.h"
#import <objc/runtime.h>



@interface RuntimeController ()
@property(nonatomic,copy) NSDictionary *dataDic;
@end

@implementation RuntimeController

-(NSDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic=@{@"name":@"pp",
                   @"id":@"123",
                   @"age":@"23",
                   @"cars":@[@"aa",@"bb",@"cc"],
                   @"houses":@[@"mm",@"kk"],
                   @"utils":@{@"uName":@"qq",@"uCode":@123123}
                   };
    }
    return _dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getPropertyByRuntimeWith:NSClassFromString(@"FirstModel")];
    [self getIVarByRuntimeWith:NSClassFromString(@"FirstModel")];
    FirstModel *model = [[FirstModel alloc]init];
    //model = [FirstModel getModelByKVC:self.dataDic];
    model = [FirstModel objcWithDict:self.dataDic mapDict:@{@"ID":@"id"}];
    NSLog(@"%@,%@,%@,%@,%f",model.name,model.cars,model.age,model.ID,model.contentHeight);
}

//runtime应用一：字典转模型
-(void)getPropertyByRuntimeWith:(Class)desClass{
    unsigned int count;
    //属性
    objc_property_t *pro = class_copyPropertyList(desClass, &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(pro[i]);
        NSLog(@"property----="">%@", [NSString stringWithUTF8String:propertyName]);
    }
}

-(void)getIVarByRuntimeWith:(Class)desClass{
    unsigned int count;
    //获取成员变量列表
    Ivar *ivarList = class_copyIvarList(desClass, &count);
    for (unsigned int i = 0; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"ivar----="">%@", [NSString stringWithUTF8String:ivarName]);
    }
}

-(void)getMethodByRuntimeWith:(Class)desClass{
    unsigned int count;
    //获取方法列表
    Method *methodList = class_copyMethodList(desClass, &count);
    for (unsigned int i = 0; i<count; i++) {
        Method method = methodList[i];
        NSLog(@"method----="">%@", NSStringFromSelector(method_getName(method)));
    }
}

-(void)getprotocolByRuntimeWith:(Class)desClass{
    unsigned int count;
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(desClass, &count);
    for (unsigned int i = 0; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol----="">%@", [NSString stringWithUTF8String:protocolName]);
    }
}

//runtime运用2，动态新增方法
//runtime运用3，方法交换




//runtime运用4，对象关联







@end

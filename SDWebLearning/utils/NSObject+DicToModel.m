//
//  NSObject+DicToModel.m
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/16.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "NSObject+DicToModel.h"
#import <objc/runtime.h>

@implementation NSObject (DicToModel)
//利用kvc的字典转模型1，直接转模型，遇到不匹配的key时直接走-(void)setValue:(id)value forUndefinedKey:(NSString *)key
//利用kvc的字典转模型2，直接转模型，遇到不匹配的key时重写setValue forKey:的方法
+(instancetype)getModelByKVC:(NSDictionary*)dic{
    id model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}


//利用runtime进行手动的setValuesForKeysWithDictionary:方法。可以根据一个映射表来处理未知key
+ (instancetype)objcWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict
{
    id objc = [[self alloc] init];
    
    
    // 遍历模型中成员变量
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(self, &outCount);
    
    for (int i = 0 ; i < outCount; i++) {
        Ivar ivar = ivars[i];
        
        // 成员变量名称
        NSString *ivarName = @(ivar_getName(ivar));
        
        // 获取出来的是`_`开头的成员变量名，需要截取`_`之后的字符串
        ivarName = [ivarName substringFromIndex:1];
        
        id value = dict[ivarName];
        // 由外界通知内部，模型中成员变量名对应字典里面的哪个key
        // ID -> id
        if (value == nil) {
            if (mapDict) {
                NSString *keyName = mapDict[ivarName];
                value = dict[keyName];
            }
        }
        [objc setValue:value forKeyPath:ivarName];
    }
    return objc;
}
@end

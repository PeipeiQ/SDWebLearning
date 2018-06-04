//
//  BaseModel.m
//  SDWebLearning
//
//  Created by peipei on 2018/5/14.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

@end

@implementation FirstModel

//setValuesForKeysWithDictionary:的底层是调用setValue:forKey:的，所以可以考虑重写这个方法，并且判断其key是id时，手动转换成模型的成员变量名，这里假设把id对应成以下属性
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ID"];
    }else{
        [super setValue:value forKey:key];
    }
}

//如果找不到对应的key值时对应的对象会走这个方法。这个方法的原由实现是抛出异常
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"value:%@,key%@",value,key);
}
@end

@implementation FriendCircleItemModel

@end

@implementation FriendCircleModel

@end

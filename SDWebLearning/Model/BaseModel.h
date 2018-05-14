//
//  BaseModel.h
//  SDWebLearning
//
//  Created by peipei on 2018/5/14.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property(nonatomic,copy) NSString *type;
@end

@interface FirstModel : BaseModel
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *age;
@property(nonatomic,copy) NSArray *cars;
@property(nonatomic,copy) NSArray *houses;
@property(nonatomic,copy) NSDictionary *utils;
@end

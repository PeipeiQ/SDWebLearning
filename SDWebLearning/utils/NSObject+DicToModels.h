//
//  NSObject+DicToModels.h
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/28.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DicToModels)
+(instancetype)getModelByKVC:(NSDictionary*)dic;
+ (instancetype)objcWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict;
@end

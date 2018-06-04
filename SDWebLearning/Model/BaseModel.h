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
@property(nonatomic,assign) CGFloat contentHeight;

@end


@interface FriendCircleItemModel :BaseModel
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSArray *picLists;
@property(nonatomic,assign) CGFloat totalHeight;
@property(nonatomic,assign) CGFloat contentHeight;
@property(nonatomic,assign) CGFloat totalContentHeight;
@property(nonatomic,assign) CGFloat picsHeight;
@end

@interface FriendCircleModel:BaseModel
@property(nonatomic,strong) NSArray<FriendCircleItemModel*> *listItems;
@end

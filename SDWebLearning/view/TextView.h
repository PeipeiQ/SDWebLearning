//
//  TextView.h
//  SDWebLearning
//
//  Created by peipei on 2018/5/23.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void (^TextBlock)(NSString *text);

@interface TextView : UIView
@property(nonatomic,copy) NSString *contentText;
-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;
@end

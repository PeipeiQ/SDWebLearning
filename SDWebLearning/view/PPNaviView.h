//
//  PPNaviView.h
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/28.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PPNaviView : UIView
@property(nonatomic,strong)UITableView *tableView;
-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;
@end

//
//  FriendCircleTableViewCell.h
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/29.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface FriendCircleTableViewCell : UITableViewCell
@property(nonatomic,strong) FriendCircleItemModel *itemData;
@property(nonatomic,assign) NSInteger currentIndex;
@end

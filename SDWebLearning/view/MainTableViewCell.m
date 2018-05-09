//
//  MainTableViewCell.m
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/9.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "MainTableViewCell.h"
@interface MainTableViewCell()

@end

@implementation MainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self showCell];
    }
    return self;
}

-(void)showCell{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 50,kScreenWidth , 50)];
    [self addSubview:label];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

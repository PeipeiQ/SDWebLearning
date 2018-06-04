//
//  MainTableViewCell.m
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/9.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "MainTableViewCell.h"
@interface MainTableViewCell()
@property(nonatomic,strong) UILabel *label;
@end

@implementation MainTableViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self showCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)showCell{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0,kScreenWidth-30 , 50)];
    _label = label;
    [self addSubview:label];
}

-(void)setPage:(NSString *)page{
    _label.text = page;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

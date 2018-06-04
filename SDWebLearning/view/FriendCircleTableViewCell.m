//
//  FriendCircleTableViewCell.m
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/29.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "FriendCircleTableViewCell.h"
@interface FriendCircleTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    BOOL _showAllContentState;
}
@property(nonatomic,strong) UIImageView *avatarView;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UICollectionView *picCollectionView;
@property(nonatomic,strong) UILabel *nickNameLabel;
@property(nonatomic,strong) UIButton *showAllContentBtn;
@end

@implementation FriendCircleTableViewCell

-(UIButton *)showAllContentBtn{
    if(!_showAllContentBtn){
        _showAllContentBtn = [[UIButton alloc]init];
        _showAllContentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _showAllContentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _showAllContentState = NO;
        [_showAllContentBtn addTarget:self action:@selector(tapShowAllContent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showAllContentBtn];
    }
    return _showAllContentBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _avatarView = [[UIImageView alloc]init];
        _nickNameLabel = [[UILabel alloc]init];
        _contentLabel = [[UILabel alloc]init];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //layout.itemSize = CGSizeMake((kScreenWidth-70*2-20)/3, (kScreenWidth-70*2-20)/3);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _picCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _picCollectionView.backgroundColor = [UIColor whiteColor];
        _picCollectionView.delegate = self;
        _picCollectionView.dataSource = self;
        
        [_picCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"picsCell"];
        [self addSubview:_avatarView];
        [self addSubview:_nickNameLabel];
        [self addSubview:_contentLabel];
        [self addSubview:_picCollectionView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)renderView{
    BOOL isShow = self.itemData.totalContentHeight>self.itemData.contentHeight;
    
    if (isShow) {
        self.showAllContentBtn.frame = _showAllContentState ? CGRectMake(70, 50+self.itemData.totalContentHeight+5, 100, 15) : CGRectMake(70, 50+self.itemData.contentHeight+5, 100, 15);
        _showAllContentState ? [self.showAllContentBtn setTitle:@"收起全文" forState:UIControlStateNormal] : [self.showAllContentBtn setTitle:@"显示全文" forState:UIControlStateNormal];
        [self.showAllContentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    
    _avatarView.frame = CGRectMake(10, 15, 50, 50);
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:self.itemData.avatar]];
    
    _nickNameLabel.frame = CGRectMake(70, 15, kScreenWidth-70-10, 15);
    _nickNameLabel.text = self.itemData.nickname;
    
    _contentLabel.frame = _showAllContentState ? CGRectMake(70, 40, kScreenWidth-70-10, self.itemData.totalContentHeight) : CGRectMake(70, 40, kScreenWidth-70-10, self.itemData.contentHeight);
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = self.itemData.content;
    
    _picCollectionView.frame = _showAllContentState ? CGRectMake(70, 50+self.itemData.totalContentHeight+10+25*isShow, (kScreenWidth-70*2), self.itemData.picsHeight) : CGRectMake(70, 50+self.itemData.contentHeight+10+25*isShow, (kScreenWidth-70*2), self.itemData.picsHeight);
}

-(void)tapShowAllContent:(UIButton*)sender{
    if(_showAllContentState){
        _showAllContentState = NO;
        [self renderView];
        //通知外界刷新高度
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unshowAllContent" object:@{@"index":@(_currentIndex)}];
    }else{
        //显示全文
        _showAllContentState = YES;
        //[self renderView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAllContent" object:@{@"index":@(_currentIndex)}];
    }
}

-(void)setItemData:(FriendCircleItemModel *)itemData{
    _itemData = itemData;
    [self renderView];
}

#pragma -mark collection delegate&datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemData.picLists.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picsCell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.width)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.itemData.picLists[indexPath.item]]];
    [cell.contentView addSubview:imageView];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-70*2-20)/3, (kScreenWidth-70*2-20)/3);
}





@end

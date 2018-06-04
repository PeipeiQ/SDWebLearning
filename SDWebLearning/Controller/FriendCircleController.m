//
//  FriendCircleController.m
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/28.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "FriendCircleController.h"
#import "PPNaviView.h"
#import "FriendCircleTableViewCell.h"
@interface FriendCircleController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) FriendCircleModel *itemsModel;
@property(nonatomic,strong) UITableView *mainTableView;

@end

@implementation FriendCircleController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    PPNaviView *navView = [[PPNaviView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight) title:@"朋友圈"];
    [self.view addSubview:navView];
    [self setupTableView];
    navView.tableView = _mainTableView;
    [self.view bringSubviewToFront:navView];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unshowAllContent:) name:@"unshowAllContent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAllContent:) name:@"showAllContent" object:nil];
}

-(void)setupTableView{
    UITableView *mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
    view.backgroundColor = [UIColor whiteColor];
    mainTableView.tableHeaderView = view;
    
    //没有这三行，reload时会导致EXC_BAD_ACCESS
    
    mainTableView.estimatedRowHeight = 0;
    mainTableView.estimatedSectionFooterHeight = 0;
    mainTableView.estimatedSectionHeaderHeight = 0;

    [mainTableView registerClass:[FriendCircleTableViewCell class] forCellReuseIdentifier:@"mainCell"];
    _mainTableView = mainTableView;
    [self.view addSubview:mainTableView];
}

//计算label高度
- (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

-(NSDictionary*)getContentSizeWith:(FriendCircleItemModel*)item{
    CGSize labelSize = [self labelAutoCalculateRectWith:item.content FontSize:17 MaxSize:CGSizeMake(kScreenWidth-70-10, 160)];
    //实际文本长度
    CGSize totalLabelSize = [self labelAutoCalculateRectWith:item.content FontSize:17 MaxSize:CGSizeMake(kScreenWidth-70-10, 1000)];
    CGFloat picHeight = (kScreenWidth-70*2-20)/3;
    CGFloat picsHeight = item.picLists.count? (int)((item.picLists.count-0.01)/3+1)*picHeight+(CGFloat)((item.picLists.count-0.01)/3)*10 : 0;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if(labelSize.height) [dic setValue:@(labelSize.height) forKey:@"label"];
    if(picsHeight) [dic setValue:@(picsHeight) forKey:@"pics"];
    if(totalLabelSize.height) [dic setValue:@(totalLabelSize.height) forKey:@"totalLabel"];
    
    //是否有显示全文
    CGFloat totalHeight = totalLabelSize.height>labelSize.height?(labelSize.height+picsHeight+100):(labelSize.height+picsHeight+80);
    if(totalHeight) [dic setValue:@(totalHeight) forKey:@"total"];
    return dic;
}

-(void)showAllContent:(NSNotification*)noti{
    //[self.mainTableView beginUpdates];
    int index = [noti.object[@"index"] intValue];
    self.itemsModel.listItems[index].totalHeight += (self.itemsModel.listItems[index].totalContentHeight-self.itemsModel.listItems[index].contentHeight);
    [self.mainTableView reloadData];
    //[self.mainTableView endUpdates];
}

-(void)unshowAllContent:(NSNotification*)noti{
    //[self.mainTableView beginUpdates];
    int index = [noti.object[@"index"] intValue];
    self.itemsModel.listItems[index].totalHeight -= (self.itemsModel.listItems[index].totalContentHeight-self.itemsModel.listItems[index].contentHeight);
    [self.mainTableView reloadData];

    //[self.mainTableView endUpdates];
}

#pragma -mark network
-(void)loadData{
    
    [NetworkUtil getFromUrl:@"/pic2" para:nil successResult:^(id response, NSInteger httpStatusCode, NSDictionary *responseHeader) {
        
//        NSArray *items = response[@"data"][@"items"];
//        FriendCircleModel *itemsModel = [[FriendCircleModel alloc]init];
//        NSMutableArray *listItems = [[NSMutableArray alloc]init];
//        [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            //字典转模型
//            FriendCircleItemModel *model = [[FriendCircleItemModel alloc]init];
//            model = [FriendCircleItemModel objcWithDict:items[idx] mapDict:nil];
//            //计算内容需要的高度并储存
//            model.contentHeight = [[self getContentSizeWith:model][@"label"] floatValue];
//            model.totalHeight = [[self getContentSizeWith:model][@"total"] floatValue];
//            model.picsHeight = [[self getContentSizeWith:model][@"pics"] floatValue];
//            model.totalContentHeight = [[self getContentSizeWith:model][@"totalLabel"] floatValue];
//            [listItems setObject:model atIndexedSubscript:idx];
//        }];
//        itemsModel.listItems = listItems;
//        _itemsModel = itemsModel;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.mainTableView reloadData];
//        });
        
    } errorResult:^(NSString *errorMessasge, NSError *error) {
        
    }];
}


#pragma -mark tableview delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsModel.listItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemsModel.listItems[indexPath.item].totalHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    cell.itemData = _itemsModel.listItems[indexPath.item];
    cell.currentIndex = indexPath.item;
    return cell;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unshowAllContent" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showAllContent" object:nil];
}


@end

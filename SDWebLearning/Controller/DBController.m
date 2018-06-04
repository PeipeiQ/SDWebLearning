//
//  DBController.m
//  SDWebLearning
//
//  Created by peipei on 2018/5/21.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "DBController.h"
#import "TextView.h"
#import <sqlite3.h>

@interface DBController (){
    sqlite3 *_db;
}
@property(nonatomic,strong) TextView *ageText;
@property(nonatomic,strong) TextView *sexText;
@property(nonatomic,strong) TextView *cityText;
@property(nonatomic,strong) TextView *nameText;
@property(nonatomic,strong) TextView *searchText;

@end

@implementation DBController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _nameText = [[TextView alloc]initWithFrame:CGRectMake(50, 100, 200, 30) title:@"姓名"];
    _ageText = [[TextView alloc]initWithFrame:CGRectMake(50, 150, 200, 30) title:@"年龄"];
    _sexText = [[TextView alloc]initWithFrame:CGRectMake(50, 200, 200, 30) title:@"性别"];
    _cityText = [[TextView alloc]initWithFrame:CGRectMake(50, 250, 200, 30) title:@"城市"];

    
    UIButton *insertBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 300, 200, 20)];
    [insertBtn setTitle:@"插入数据" forState:UIControlStateNormal];
    [insertBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    insertBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [insertBtn addTarget:self action:@selector(tapInsertData) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 350, 200, 20)];
    [searchAllBtn setTitle:@"查询全部数据" forState:UIControlStateNormal];
    [searchAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    searchAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchAllBtn addTarget:self action:@selector(searchDataFromDB) forControlEvents:UIControlEventTouchUpInside];
    
    _searchText = [[TextView alloc]initWithFrame:CGRectMake(50, 400, 200, 30) title:@"查找"];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(280, 400, 100, 20)];
    [searchBtn setTitle:@"按条件查找" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchBtn addTarget:self action:@selector(searchOneFromDB) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_nameText];
    [self.view addSubview:_ageText];
    [self.view addSubview:_sexText];
    [self.view addSubview:_cityText];
    [self.view addSubview:insertBtn];
    [self.view addSubview:searchAllBtn];
    [self.view addSubview:_searchText];
    [self.view addSubview:searchBtn];

    
    [self createSqlitedb];
    //[self insertData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


-(void)createSqlitedb{
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"student.db"];
    NSLog(@"%@",fileName);
    
    //创建或者打开一个数据库
    int result = sqlite3_open(fileName.UTF8String, &_db);
    if(result==SQLITE_OK){
        //成功创建数据库
        
        //建表
        //const char *sql = "create table if not exists t_student (id INTEGER PRIMARY KEY AUTOINCREMENT,name text,age int,city text,sex int);";
        const char *sql = "create table if not exists t_class (id INTEGER PRIMARY KEY AUTOINCREMENT,name text,class text);";
        char *errorMsg = NULL;
        int result = sqlite3_exec(_db, sql, NULL, NULL, &errorMsg);
        NSLog(@"建表%d",result);
        NSLog(@"建表错误信息%s",errorMsg);
    }
}

//插入数据
-(void)insertData{
    
    for (int i = 0; i < 10; i++) {
        NSArray *names = @[@"Peter",@"Ann",@"Jim",@"Kay",@"Tom"];
        NSString *name = names[arc4random()%5];

        NSString *classes = [NSString stringWithFormat:@"class-%d",arc4random()%100];

        //插入语句（insert into 表名（字段1，字段2，..）values (字段1值，字段2值，..);）
        NSString *sql = [NSString stringWithFormat:@"insert into t_class (name,class) values ('%@','%@');",name,classes];
        char *errorMesg = NULL;
        int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMesg);
        
        if (result == SQLITE_OK) {
            NSLog(@"添加数据成功");
        }else {
            
            NSLog(@"添加数据失败");
        }
    }
}

//点击插入单条数据
-(void)tapInsertData{
    [self.view endEditing:YES];
    if (!_nameText.contentText || ![_ageText.contentText integerValue] || [_sexText.contentText integerValue]<0 ||[_sexText.contentText integerValue]>1 || !_cityText.contentText) {
        NSLog(@"数据不完整");
        return;
    }
    NSString *name = _nameText.contentText;
    NSInteger age = [_ageText.contentText integerValue];
    NSInteger sex = [_sexText.contentText integerValue];
    NSString *city = _cityText.contentText;
    //sql语句
    NSString *sql = [NSString stringWithFormat:@"insert into t_student (id,name,age,sex,city) values (null,'%@',%ld,%ld,'%@');",name,(long)age,(long)sex,city];
    //NSString *sql = @"drop table t_student";
    char *errorMesg = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMesg);
    if (result == SQLITE_OK) {
        NSLog(@"添加数据成功");
    }else {
        
        NSLog(@"添加数据失败");
    }
}

//查询数据
-(void)searchDataFromDB{
    //1.定义sql语句（查询所有学生的数据）
    //const char *sql = "select id, name, age from t_student;";
    //也可用where条件查询语句，查询年龄大于60的学生年龄
    const char *sql = "select * from t_student;";
    //2.定义一个stmt存放结果集
    sqlite3_stmt *stmt = NULL;
    //3.检测SQL语句的合法性
    int result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if(result==SQLITE_OK){
        //4.执行SQL语句
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSLog(@"---------------------------------------------------------------");
            //获得第几条的id
            int ID = sqlite3_column_int(stmt, 0);

            const unsigned char *sname = sqlite3_column_text(stmt, 1);
            NSString *name = sname?[NSString stringWithUTF8String:(const char *)sname]:nil;
 
            //获得第几条的age
            int age = sqlite3_column_int(stmt, 2);
            
            const unsigned char *scity = sqlite3_column_text(stmt, 3);
            NSString *city = scity?[NSString stringWithUTF8String:(const char *)scity]:nil;
            
            int sex = sqlite3_column_int(stmt, 4);
            NSLog(@"id:%d\nname:%@\nage:%d\ncity:%@\nsex:%d",ID,name,age,city,sex);
            
        }
        
    }

}

//按条件查询
-(void)searchOneFromDB{
    [self.view endEditing:YES];
    
    int ID = [_searchText.contentText intValue];
    NSString *sql = [NSString stringWithFormat:@"select * from t_student where id=%d",ID];
    sqlite3_stmt *stmt = NULL;
    int res = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (res == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSLog(@"姓名:%s,年龄:%d,性别:%d,城市:%s",sqlite3_column_text(stmt, 1),sqlite3_column_int(stmt, 2),sqlite3_column_int(stmt, 3),sqlite3_column_text(stmt, 4));
        }
    }
    
}

-(void)transformView:(NSNotification *)aNSNotification{
    
    //获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyBoardBeginBounds CGRectValue];
    
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];
    
    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    //NSLog(@"看看这个变化的Y值:%f",deltaY);
    
    //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    if (_searchText.textField.isEditing) {
        [UIView animateWithDuration:0.25f animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
        }];
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



@end

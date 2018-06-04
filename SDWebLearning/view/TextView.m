//
//  TextView.m
//  SDWebLearning
//
//  Created by peipei on 2018/5/23.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "TextView.h"
@interface TextView()<UITextFieldDelegate>{
    CGRect _frame;
}
@property(nonatomic,strong) NSString *title;
@end

@implementation TextView
-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title{
    if(self = [super initWithFrame:frame]){
        _title = title;
        _frame = frame;
        [self renderView];
    }
    return self;
}

-(void)renderView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    label.text = [NSString stringWithFormat:@"%@:",_title];
    [self addSubview:label];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(60, 0, _frame.size.width-50, 30)];
    _textField.layer.borderColor = [[UIColor blackColor] CGColor];
    _textField.layer.borderWidth = 0.5;
    _textField.delegate = self;
    [self addSubview:_textField];
}

-(void)layoutSubviews{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.contentText = textField.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}


@end

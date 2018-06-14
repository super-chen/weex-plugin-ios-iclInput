//
//  NumberKeypadView.m
//  AFNetworking
//
//  Created by chenyuan on 2018/5/17.
//

#define isIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIphone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define isIphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#import "NumberKeypadView.h"

@implementation NumberKeypadView{
    NSArray *data;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        data = @[@"7",@"8",@"9",@"4",@"5",@"6",@"1",@"2",@"3",@"-",@"0",@"."];
    }
    return self;
}

- (void)drawRect{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen ].bounds.size.width, 240);
    if (isIphoneX) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen ].bounds.size.width, 265);
    }
    
    self.backgroundColor = [UIColor colorWithRed:209/255.0 green:213/255.0 blue:219/255.0 alpha:1.0];
    for (int i=0; i<data.count; i++) {
        int row = i / 3;
        int column = i % 3;
        CGRect frame = CGRectMake(column*90 + 10, row*56 + 10, 83, 50);
        UIButton *btn = [self buttonWithFrame:frame tag:i title:data[i] imageName:@""];
        [self addSubview:btn];
        
    }

    UIButton *btn_delete = [self buttonWithFrame:CGRectMake(3*90 + 10, 0*56 + 10, 83, 50) tag:12 title:@"" imageName:@"keypad_delete"];
    [self addSubview:btn_delete];
    
    UIButton *btn_up = [self buttonWithFrame:CGRectMake(3*90 + 10, 1*56 + 10, 83, 50) tag:13 title:@"" imageName:@"keypad_up"];
    [self addSubview:btn_up];
    
    UIButton *btn_down = [self buttonWithFrame:CGRectMake(3*90 + 10, 2*56 + 10, 83, 50) tag:14 title:@"" imageName:@"keypad_down"];
    [self addSubview:btn_down];
    
    UIButton *btn_ok = [self buttonWithFrame:CGRectMake(3*90 + 10, 3*56 + 10, 83, 50) tag:15 title:@"确 认" imageName:@""];
    [self addSubview:btn_ok];
    
}

-(UIButton*)buttonWithFrame:(CGRect)frame tag:(int)tag title:(NSString *)title imageName:(NSString *)imageName{
    float scale = 1;
    if(isIphone5){
        scale = 0.86;
    }else if(isIphone6Plus){
        scale = 1.11;
    }
    frame.size.width = frame.size.width * scale;
    frame.origin.x = frame.origin.x * scale;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(clickUp:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(clickUp:) forControlEvents:UIControlEventTouchUpOutside];
    btn.layer.cornerRadius = 5;
    btn.layer.shadowOffset =  CGSizeMake(3, 4);
    btn.layer.shadowOpacity = 0.8;
    btn.layer.shadowColor =  [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0].CGColor;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize: 18.0];
    btn.frame = frame;
    if(title.length != 0){
        [btn setTitle:title forState:UIControlStateNormal];
        if ([title isEqualToString:@"确 认"]) {
            btn.backgroundColor = [UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:1.0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    if(imageName.length != 0){
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    btn.tag = tag;
    
    return btn;
}

-(void)clickDown:(UIButton *)sender{
    sender.backgroundColor = [UIColor colorWithRed:232/255.0 green:236/255.0 blue:240/255.0 alpha:1.0];
}

-(void)clickUp:(UIButton *)sender{
    if(sender.tag == 15){
        sender.backgroundColor = [UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:1.0];
    }else{
        sender.backgroundColor = [UIColor whiteColor];
    }
    NSString *temp;
    if(sender.tag == 12){
        temp = @"Delete";
    }
    if(sender.tag == 13){
        temp = @"touchUp";
    }
    if(sender.tag == 14){
        temp = @"touchDown";
    }
    if(sender.tag == 15){
        temp = @"Confirm";
    }
    if(temp.length == 0){
        temp = data[sender.tag];
    }
    if(self.click){
        self.click(temp);
    }
}

@end

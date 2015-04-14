//
//  ViewController.m
//  LinkLabelDemo
//
//  Created by CoderJee on 15/4/14.
//  Copyright (c) 2015年 com.huazhi. All rights reserved.
//

#import "ViewController.h"
#import "CJLinkLabel.h"
#import "CJLoadLinkController.h"
#import "UIColor+CJ.h"
@interface ViewController ()<CJLinkLabelDelegate>
@property (nonatomic, weak)CJLinkLabel *linkLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LinkLabelDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    // 加载超链接
    CJLinkLabel *linkLabel = [[CJLinkLabel alloc] initWithFrame:CGRectMake(10, 70, 300, 50)];
    [self.view addSubview:linkLabel];
    self.linkLabel = linkLabel;
    linkLabel.delegate = self;
    NSString *LinkStr = @"I'm CoderJee,正在帝都修行中!(加载超链接):\nhttp://www.baidu.com,http://www.jianshu.com/p/3511ec38ca20";
    [linkLabel setLinkString:LinkStr withTextColor:[UIColor blackColor] withLinkColor:[UIColor CJ_16_Color:@"00e7b9"] AndClickLinkColor:[UIColor blueColor] WithLinkFont:[UIFont systemFontOfSize:14]];
    linkLabel.backgroundColor = [UIColor lightGrayColor];
    
    // 加载HTML
    NSString *htmlString =  @"<html><body><font size=\"10\" color=\"red\"> 加载HTML: </font>I'm CoderJee,正在帝都修行中! </body></html>";
    CJLinkLabel *htmlLabel = [[CJLinkLabel alloc] initWithFrame:CGRectMake(10, 126, 300, 60)];
    htmlLabel.HTMLAttributeString = htmlString;
    htmlLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:htmlLabel];
}

- (void)linkLabel:(CJLinkLabel *)label linkClick:(NSString *)URL
{
    CJLoadLinkController *loadLink = [[CJLoadLinkController alloc] init];
    
    loadLink.URL = URL;
    
    [self.navigationController pushViewController:loadLink animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

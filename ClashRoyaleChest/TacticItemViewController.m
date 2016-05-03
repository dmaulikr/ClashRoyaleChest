//
//  TacticItemViewController.m
//  ClashRoyaleChest
//
//  Created by liujunyi on 16/4/10.
//  Copyright © 2016年 LJY. All rights reserved.
//

#import "TacticItemViewController.h"

@interface TacticItemViewController ()

@end

@implementation TacticItemViewController

@synthesize tacticTitle;
@synthesize tacticUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWebView];
}

- (void)createWebView {
    UIWebView *tacticItemWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:tacticItemWebView];
    NSString *urlString = self.tacticUrl;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [tacticItemWebView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

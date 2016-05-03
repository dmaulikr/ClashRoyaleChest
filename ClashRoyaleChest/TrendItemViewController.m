//
//  TrendItemViewController.m
//  ClashRoyaleChest
//
//  Created by liujunyi on 16/4/13.
//  Copyright © 2016年 LJY. All rights reserved.
//

#import "TrendItemViewController.h"

@interface TrendItemViewController ()

@end

@implementation TrendItemViewController

@synthesize trendTitle;
@synthesize trendUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWebView];
}

- (void)createWebView {
    UIWebView *trendItemWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:trendItemWebView];
    NSString *urlString = self.trendUrl;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [trendItemWebView loadRequest:urlRequest];
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

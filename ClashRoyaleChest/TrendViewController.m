//
//  TrendViewController.m
//  ClashRoyaleChest
//
//  Created by liujunyi on 16/4/13.
//  Copyright © 2016年 LJY. All rights reserved.
//

#import "TrendViewController.h"
#import "TrendModel.h"
#import "LJYTrendTableViewCell.h"
#import "TrendItemViewController.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MMProgressHUD.h"

#define COLOR [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]

@interface TrendViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_trendDataSourceArray;
    UITableView *_trendTableView;
    UIRefreshControl *_trendRefreshControl;
    BOOL _isLoading;
}

@property NSString *trendTitle;
@property NSString *trendUrl;

@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTrendTableView];
    [self createTrendDataSource];
    [self createTrendRefreshControl];
    [self setFooterView];
}

- (void)createTrendTableView {
    _trendTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    _trendTableView.dataSource = self;
    _trendTableView.delegate = self;
    
    [self.view addSubview:_trendTableView];
    
    [self HTTPRequestWithAddress:@"http://www.quweiwu.com/api.php?action=topicindex&curl=cr&from=com.ipadown.cr&version=1.0&size=600x260"];
}

- (void)HTTPRequestWithAddress:(NSString *)address {
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleBalloon];
    [MMProgressHUD showDeterminateProgressWithTitle:@"请稍候" status:@"正在打开宝箱=。="];
    
    [_trendDataSourceArray removeAllObjects];
    
    AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
    
    httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [httpSessionManager GET:address parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *trendDataDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *trendArray = trendDataDictionary[@"list"][1][@"list"];
        
        for (NSDictionary *dictionaryItem in trendArray) {
            TrendModel *trendModel = [TrendModel new];
            trendModel.title = dictionaryItem[@"title"];
            trendModel.ID = dictionaryItem[@"ID"];
            trendModel.thumb = dictionaryItem[@"thumb"];
            
            [_trendDataSourceArray addObject:trendModel];
            
        }
        
        [MMProgressHUD dismissWithSuccess:@"成功打开宝箱\\^o^/"];
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MMProgressHUD dismissWithError:@"打开宝箱失败~>_<~"];
    }];
    
}

- (void)reloadTableView {
    [_trendTableView reloadData];
}

- (void)createTrendDataSource {
    _trendDataSourceArray = [NSMutableArray new];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _trendDataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *trendTableViewCellIdentifier = @"大表妹：“你这周没来上英语课，这是笔记，考试重点也用红笔划过了。”海事姐姐：“你自己不用吗？”大表妹：“没关系，这本是我重新抄的一份。”海事姐姐：“你这样我也不会喜欢你的。”大表妹：“我知道。”";
    LJYTrendTableViewCell *trendTableViewCell = [tableView dequeueReusableCellWithIdentifier:trendTableViewCellIdentifier];
    
    if (trendTableViewCell == nil) {
        trendTableViewCell = [[LJYTrendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:trendTableViewCellIdentifier];
    }
    
    TrendModel *trendModel = _trendDataSourceArray[indexPath.row];
    
    [trendTableViewCell.thumbView sd_setImageWithURL:[NSURL URLWithString:trendModel.thumb]];
    trendTableViewCell.titleLabel.text = trendModel.title;
    
    trendTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return trendTableViewCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendItemViewController *trendItemViewController = [TrendItemViewController new];
    TrendModel *trendModel = _trendDataSourceArray[indexPath.row];
    trendItemViewController.trendTitle = trendModel.title;
    trendItemViewController.trendUrl = [NSString stringWithFormat:@"http://www.quweiwu.com/api.php?action=newsshow&id=%@&format=html", trendModel.ID];
    
    [self.navigationController pushViewController:trendItemViewController animated:NO];
}

- (void)createTrendRefreshControl {
    _trendRefreshControl = [UIRefreshControl new];
    _trendRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始为亲刷新今日宝箱内容o(╯□╰)o"];
    _trendRefreshControl.tintColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    [_trendRefreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [_trendTableView addSubview:_trendRefreshControl];
}

- (void)refresh {
    //判断当前是否在刷新状态 （不再刷新状态才响应 开始刷新的要求）
    if (_isLoading == NO) {
        
        _trendRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新ing(～ o ～)~zZ"];
        _isLoading = YES;
        [self performSelector:@selector(reload) withObject:nil afterDelay:3];
        
    }
    
}

- (void)reload {
    _trendRefreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"开始为亲刷新今日宝箱内容o(╯□╰)o"];
    _isLoading = NO;
    [self HTTPRequestWithAddress:@"http://www.quweiwu.com/api.php?action=topicindex&curl=cr&from=com.ipadown.cr&version=1.0&size=600x260"];
    [_trendRefreshControl endRefreshing];
}

- (void)setFooterView {
    UILabel *footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    footerLabel.backgroundColor = [UIColor whiteColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.numberOfLines = 0;
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:@"小手向下一拉可以刷新宝箱内容哦~~~"];
    
    NSRange range1 = NSMakeRange([[str1 string] rangeOfString:@"小手向下一拉"].location, [[str1 string] rangeOfString:@"小手向下一拉"].length);//取一个范围
    [str1 addAttribute:NSForegroundColorAttributeName value:COLOR range:range1];//在这个范围内设置字体颜色
    
    NSRange range2 = NSMakeRange([[str1 string] rangeOfString:@"可以刷新宝箱内容哦~~~"].location, [[str1 string] rangeOfString:@"可以刷新宝箱内容哦~~~"].length);
    [str1 addAttribute:NSForegroundColorAttributeName value:COLOR range:range2];
    
    [footerLabel setAttributedText:str1];
    
    _trendTableView.tableFooterView = footerLabel;
    
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

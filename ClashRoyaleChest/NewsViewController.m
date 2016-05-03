//
//  NewsViewController.m
//  ClashRoyaleChest
//
//  Created by liujunyi on 16/4/6.
//  Copyright © 2016年 LJY. All rights reserved.
//

#import "NewsViewController.h"
#import "LJYNewsTableViewCell.h"
#import "NewsModel.h"
#import "NewsItemViewController.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MMProgressHUD.h"

#define COLOR [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *_newsDataSourceArray;
    UITableView *_newsTableView;
    UIRefreshControl *_newsRefreshControl;
    BOOL _isLoading;
}

@property NSString *newsTitle;
@property NSString *newsUrl;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNewsTableView];
    [self createNewsDataSource];
    [self createNewsRefreshControl];
    [self setFooterView];
}

- (void)createNewsTableView {
    _newsTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    _newsTableView.dataSource = self;
    _newsTableView.delegate = self;
    
    [self.view addSubview:_newsTableView];
    
    [self HTTPRequestWithAddress:@"http://www.quweiwu.com/api.php?action=topicindex&curl=cr&from=com.ipadown.cr&version=1.0&size=600x260"];
}

- (void)HTTPRequestWithAddress:(NSString *)address {
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleBalloon];
    [MMProgressHUD showDeterminateProgressWithTitle:@"请稍候" status:@"正在打开宝箱=。="];
    
    [_newsDataSourceArray removeAllObjects];
    
    AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
    
    httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [httpSessionManager GET:address parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *newsDataDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *newsArray = newsDataDictionary[@"list"][2][@"list"];
        
        for (NSDictionary *dictionaryItem in newsArray) {
            NewsModel *newsModel = [NewsModel new];
            newsModel.title = dictionaryItem[@"title"];
            newsModel.ID = dictionaryItem[@"ID"];
            newsModel.thumb = dictionaryItem[@"thumb"];
            
            [_newsDataSourceArray addObject:newsModel];
            
        }
        
        [MMProgressHUD dismissWithSuccess:@"成功打开宝箱\\^o^/"];
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MMProgressHUD dismissWithError:@"打开宝箱失败~>_<~"];
    }];

}

- (void)reloadTableView {
    [_newsTableView reloadData];
}

- (void)createNewsDataSource {
    _newsDataSourceArray = [NSMutableArray new];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsDataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *newsTableViewCellIdentifier = @"许多年前, 海事姐姐有过这样一个诺基亚, 它只能存储200条短信, 里面装的满满的回忆. 每当存满了, 都要精挑细选删掉她自己的, 留住大表妹的. 当时海事姐姐真的好想要一个能存500条短信的手机; 而如今, 海事姐姐有了一个差不多可以无限量存储短信的爱疯6s, 但却再也找不到那个能和她聊200条短信的大表妹...";
    LJYNewsTableViewCell *newsTableViewCell = [tableView dequeueReusableCellWithIdentifier:newsTableViewCellIdentifier];
    
    if (newsTableViewCell == nil) {
        newsTableViewCell = [[LJYNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsTableViewCellIdentifier];
    }
    
    NewsModel *newsModel = _newsDataSourceArray[indexPath.row];
    
    [newsTableViewCell.thumbView sd_setImageWithURL:[NSURL URLWithString:newsModel.thumb]];
    newsTableViewCell.titleLabel.text = newsModel.title;
    
    newsTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return newsTableViewCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsItemViewController *newsItemViewController = [NewsItemViewController new];
    NewsModel *newsModel = _newsDataSourceArray[indexPath.row];
    newsItemViewController.newsTitle = newsModel.title;
    newsItemViewController.newsUrl = [NSString stringWithFormat:@"http://www.quweiwu.com/api.php?action=newsshow&id=%@&format=html", newsModel.ID];
    
    [self.navigationController pushViewController:newsItemViewController animated:NO];
}

- (void)createNewsRefreshControl {
    _newsRefreshControl = [UIRefreshControl new];
    _newsRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始为亲刷新今日宝箱内容o(╯□╰)o"];
    _newsRefreshControl.tintColor = COLOR;
    [_newsRefreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [_newsTableView addSubview:_newsRefreshControl];
}

- (void)refresh {
    //判断当前是否在刷新状态 （不再刷新状态才响应 开始刷新的要求）
    if (_isLoading == NO) {
        
        _newsRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新ing(～ o ～)~zZ"];
        _isLoading = YES;
        [self performSelector:@selector(reload) withObject:nil afterDelay:3];
        
    }
    
}

- (void)reload {
    _newsRefreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"开始为亲刷新今日宝箱内容o(╯□╰)o"];
    _isLoading = NO;
    [self HTTPRequestWithAddress:@"http://www.quweiwu.com/api.php?action=topicindex&curl=cr&from=com.ipadown.cr&version=1.0&size=600x260"];
    [_newsRefreshControl endRefreshing];
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
    
    _newsTableView.tableFooterView = footerLabel;
    
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

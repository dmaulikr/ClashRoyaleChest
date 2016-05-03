//
//  TacticViewController.m
//  ClashRoyaleChest
//
//  Created by liujunyi on 16/4/6.
//  Copyright © 2016年 LJY. All rights reserved.
//

#import "TacticViewController.h"
#import "TacticItemViewController.h"
#import "TacticModel.h"
#import "LJYTacticTableViewCell.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MMProgressHUD.h"

#define COLOR [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]

@interface TacticViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_tacticDataSourceArray;
    UITableView *_tacticTableView;
    UIRefreshControl *_tacticRefreshControl;
    BOOL _isLoading;
}

@property NSString *tacticTitle;
@property NSString *tacticUrl;

@end

@implementation TacticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isLoading = NO;
    [self createTacticTableView];
    [self createTacticDataSource];
    [self createTacticRefreshControl];
    [self setFooterView];
}

#pragma mark - 创建表格视图
- (void)createTacticTableView {
    _tacticTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    _tacticTableView.dataSource = self;
    _tacticTableView.delegate = self;
    
    [self.view addSubview:_tacticTableView];
    
    [self HTTPRequestWithAddress:@"http://www.quweiwu.com/api.php?action=topicindex&curl=cr&from=com.ipadown.cr&version=1.0&size=600x260"];
}

#pragma mark - 创建数据源
- (void)createTacticDataSource {
    _tacticDataSourceArray = [NSMutableArray new];
    
}

#pragma mark - 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tacticDataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tacticTableViewCellIdentifier = @"海事姐姐：我们能分手吗？大表妹：不可以。海事姐姐：为什么？大表妹：就像这食堂的包子，你咬了一口，人家肯给你换吗？海事姐姐：可你没我想象的好。大表妹：就像这食堂的包子，你本来想吃肉包，拿错了，咬了一口是菜包，想换又不给你换，难道扔了？凑合着吃吧。海事姐姐：噢。。。";
    LJYTacticTableViewCell *tacticTableViewCell = [tableView dequeueReusableCellWithIdentifier:tacticTableViewCellIdentifier];
    
    if (tacticTableViewCell == nil) {
        tacticTableViewCell = [[LJYTacticTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tacticTableViewCellIdentifier];
    }
    
    TacticModel *tacticModel = _tacticDataSourceArray[indexPath.row];
    
    [tacticTableViewCell.thumbView sd_setImageWithURL:[NSURL URLWithString:tacticModel.thumb]];
    tacticTableViewCell.titleLabel.text = tacticModel.title;
    
    tacticTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return tacticTableViewCell;
    
}

- (void)HTTPRequestWithAddress:(NSString *)address {
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleBalloon];
    [MMProgressHUD showDeterminateProgressWithTitle:@"请稍候" status:@"正在打开宝箱=。="];
    
    [_tacticDataSourceArray removeAllObjects];
    
    AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
    
    httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [httpSessionManager GET:address parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *tacticDataDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *tacticArray = tacticDataDictionary[@"list"][3][@"list"];
        
        for (NSDictionary *dictionaryItem in tacticArray) {
            TacticModel *tacticModel = [TacticModel new];
            tacticModel.title = dictionaryItem[@"title"];
            tacticModel.ID = dictionaryItem[@"ID"];
            tacticModel.thumb = dictionaryItem[@"thumb"];
            
            [_tacticDataSourceArray addObject:tacticModel];
            
        }
        
        [MMProgressHUD dismissWithSuccess:@"成功打开宝箱\\^o^/"];
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MMProgressHUD dismissWithError:@"打开宝箱失败~>_<~"];
    }];
    
}

- (void)reloadTableView {
    [_tacticTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TacticItemViewController *tacticItemViewController = [TacticItemViewController new];
    TacticModel *tacticModel = _tacticDataSourceArray[indexPath.row];
    tacticItemViewController.tacticTitle = tacticModel.title;
    tacticItemViewController.tacticUrl = [NSString stringWithFormat:@"http://www.quweiwu.com/api.php?action=newsshow&id=%@&format=html", tacticModel.ID];
    
    [self.navigationController pushViewController:tacticItemViewController animated:NO];
}

- (void)createTacticRefreshControl {
    _tacticRefreshControl = [UIRefreshControl new];
    _tacticRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始为亲刷新今日宝箱内容o(╯□╰)o"];
    _tacticRefreshControl.tintColor = COLOR;
    [_tacticRefreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [_tacticTableView addSubview:_tacticRefreshControl];
}

- (void)refresh {
    if (_isLoading == NO) {
        
        _tacticRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新ing(～ o ～)~zZ"];
        _isLoading = YES;
        [self performSelector:@selector(reload) withObject:nil afterDelay:3];
        
    }
    
}

- (void)reload {
    _tacticRefreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"开始为亲刷新今日宝箱内容o(╯□╰)o"];
    _isLoading = NO;
    [self HTTPRequestWithAddress:@"http://www.quweiwu.com/api.php?action=topicindex&curl=cr&from=com.ipadown.cr&version=1.0&size=600x260"];
    [_tacticRefreshControl endRefreshing];
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
    
    _tacticTableView.tableFooterView = footerLabel;
    
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

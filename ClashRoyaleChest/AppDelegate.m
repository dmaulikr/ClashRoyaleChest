//
//  AppDelegate.m
//  ClashRoyaleChest
//
//  Created by liujunyi on 16/4/6.
//  Copyright © 2016年 LJY. All rights reserved.
//

#import "AppDelegate.h"
#import "TacticViewController.h"
#import "NewsViewController.h"
#import "TrendViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    TacticViewController *tacticViewController = [TacticViewController new];
    UINavigationController *tacticNavigationController = [[UINavigationController alloc] initWithRootViewController:tacticViewController];
    tacticViewController.title = @"皇室攻略";
    tacticNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/256.0 green:169/256.0 blue:118/256.0 alpha:1];
    tacticViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"攻略" image:[[UIImage imageNamed:@"tabbar-tactic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  tag:901];
    
    NewsViewController *newsViewController = [NewsViewController new];
    UINavigationController *newsNavigationController = [[UINavigationController alloc] initWithRootViewController:newsViewController];
    newsViewController.title = @"皇室新闻";
    newsNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/256.0 green:169/256.0 blue:118/256.0 alpha:1];
    newsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"新闻" image:[[UIImage imageNamed:@"tabbar-news"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  tag:902];
    
    TrendViewController *trendViewController = [TrendViewController new];
    UINavigationController *trendNavigationController = [[UINavigationController alloc] initWithRootViewController:trendViewController];
    trendViewController.title = @"皇室热门";
    trendNavigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/256.0 green:169/256.0 blue:118/256.0 alpha:1];
    trendViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"热门" image:[[UIImage imageNamed:@"tabbar-trend"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  tag:903];
    
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = @[tacticNavigationController, newsNavigationController, trendNavigationController];
    tabBarController.tabBar.barStyle = UIBarStyleBlack;
    tabBarController.tabBar.translucent = NO;
    tabBarController.tabBar.tintColor = [UIColor greenColor];
    tabBarController.tabBar.barTintColor = [UIColor grayColor];
    tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tabBarBackground.png"];
    
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

//- (void)createTabBarController {
//    /*
//    NSMutableArray *viewControllersArray = [NSMutableArray new];
//    NSArray *viewControllerClassNamesArray = @[@"TacticViewController", @"NewsViewController"];
//    NSArray *tabBarItemTitlesArray = @[@"攻略", @"视频"];
//    NSArray *tabBarItemImagesArray = @[@"tabbar-tactic", @"tabbar-news"];
//    for (NSInteger i = 0; i < viewControllerClassNamesArray.count; i ++) {
//        Class viewControllerClass = NSClassFromString(viewControllerClassNamesArray[i]);
//        UIViewController *viewController = [viewControllerClass new];
//        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabBarItemTitlesArray[i] image:[[UIImage imageNamed:tabBarItemImagesArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:tabBarItemImagesArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    }
//    */
//    TacticViewController *tacticViewController = [TacticViewController new];
//    tacticViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"攻略" image:[[UIImage imageNamed:@"tabbar-tactic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  tag:101];
//    tacticViewController.title = @"攻略";
//    
//    NewsViewController *newsViewController = [NewsViewController new];
//    newsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"新闻" image:[[UIImage imageNamed:@"tabbar-新闻"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  tag:102];
//    newsViewController.title = @"新闻";
//    
//    UITabBarController *tabBarController = [UITabBarController new];
//    tabBarController.viewControllers = @[tacticViewController, newsViewController];
//    
//    [self setTabBar];
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
//    
//    
//}
//
//- (void)setTabBar {
//    
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

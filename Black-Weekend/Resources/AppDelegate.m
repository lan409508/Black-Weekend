
//  AppDelegate.m
//  Black-Weekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <BmobSDK/Bmob.h>
@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate>
@property(retain,nonatomic)UINavigationController *nav;
@end

@interface WBBaseRequest ()
-(void)debugPrint;
@end

@interface WBBaseResponse ()
-(void)debugPrint;
@end

@implementation AppDelegate

@synthesize wbToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAPPkey];
    [WXApi registerApp:kWeixinAppID];
    [Bmob registerWithAppKey:KbmobAppkey];
    
    
    
    
    
    
    //UITabBarController
    self.tabBarVC = [[UITabBarController alloc]init];
    //创建tabBarVC管理的视图控制器
    //主页
    UIStoryboard *mainstoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = mainstoryBoard.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic"];
    UIImage *selectImage = [UIImage imageNamed:@"ft_home_selected_ic"];
    mainNav.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //发现
    UIStoryboard *discoverstoryBoard = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    UINavigationController *discoverNav = discoverstoryBoard.instantiateInitialViewController;
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic"];
    UIImage *selectImage1 = [UIImage imageNamed:@"ft_found_selected_ic"];
    discoverNav.tabBarItem.selectedImage = [selectImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //我的
    UIStoryboard *minestoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UINavigationController *MineNav = minestoryBoard.instantiateInitialViewController;
    MineNav.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic"];
    UIImage *selectImage2 = [UIImage imageNamed:@"ft_person_selected_ic"];
    MineNav.tabBarItem.selectedImage = [selectImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //添加被管理的视图控制器
    _tabBarVC.viewControllers = @[mainNav,discoverNav,MineNav];
    
    self.window.rootViewController = _tabBarVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -------- 微博代理方法
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{

}

#pragma mark -------- 微信代理方法


#pragma mark -------- SDK

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}

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

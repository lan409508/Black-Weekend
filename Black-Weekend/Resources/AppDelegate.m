
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
//1.引入定位所需要的框架
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate,CLLocationManagerDelegate>
{
    //2.创建定位所需要的类的实例对象
    CLLocationManager *_locationManager;
    //创建地理编码对象
    CLGeocoder *_geocoder;
}
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
    
    //初始化定位对象
    _locationManager = [[CLLocationManager alloc]init];
    //初始化地理编码对象
    _geocoder = [[CLGeocoder alloc]init];
    if (![CLLocationManager locationServicesEnabled]) {
        LXJLog(@"用户位置服务不可用");
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度，精度越高越耗电
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率，每个多少米定位一次
        CLLocationDistance distance = 100.0;
        _locationManager.distanceFilter = distance;
        //启动定位服务
        [_locationManager startUpdatingLocation];
        
    }
    
    //新浪微博注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAPPkey];
    //微信注册
    [WXApi registerApp:kWeixinAppID];
    //注册bmobkey
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

#pragma mark -------- CLLocationManagerDelegate
/*定位协议代理方法
 param manager 当前使用的定位对象
 locations 返回定位的数据，是一个数组对象，数组里面的元素是CLLocation类型
 */
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //从数组中取出一个定位的信息
    CLLocation *location = [locations firstObject];
    LXJLog(@"%@",location);
    //从CLLocation中获取坐标
    //CLLocationCoordinate2D  坐标系，里边包含经度和纬度
    CLLocationCoordinate2D coordinate = location.coordinate;
    LXJLog(@"经度：%f  纬度：%f 海拔：%f 航向：%f行走速度：%f", coordinate.longitude, coordinate.latitude, location.altitude,location.course,location.speed);
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        NSString *city = placeMark.addressDictionary[@"city"];
        NSLog(@"%@",city);
        NSLog(@"%@",placeMark.addressDictionary);
    }];
    //如果不需要使用定位，使用完及时关闭定位服务
    [_locationManager stopUpdatingLocation];
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

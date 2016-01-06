
//  MainViewController.m
//  Black-Weekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectViewController.h"
#import "SearchViewController.h"
#import "ActivityDetailViewController.h"
#import "ThemeViewController.h"
#import "ClassifyViewController.h"
#import "ActivityViewController.h"
#import "HotViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数组
@property (nonatomic, strong) NSMutableArray *listArray;
//推荐活动数组
@property (nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数组
@property (nonatomic, strong) NSMutableArray *themeArray;
//广告数组
@property (nonatomic, strong) NSMutableArray *adArray;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //left
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setImage: [UIImage imageNamed: @"btn_search.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchActivityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarbtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarbtn;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self configTableViewHeaderView];
    //请求网络
    [self requestModel];
}

#pragma mark -------- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    } else {
    return self.themeArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *array = self.listArray[indexPath.section];
    mainCell.mainModel = array[indexPath.row];
    
    return mainCell;
}

#pragma mark -------- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 26;
}

//自定义分区头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    UIImageView *sectionView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 160, 5, 320, 16)];
    if (section == 0) {
        sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];
    }else{
        sectionView.image = [UIImage imageNamed:@"home_recommed_rc"];
    }
    [view addSubview:sectionView];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ActivityDetailViewController *activityVC = [[ActivityDetailViewController alloc]init];
        [self.navigationController pushViewController:activityVC animated:YES];
    } else {
        ThemeViewController *themeVC = [[ThemeViewController alloc]init];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}


#pragma mark -------- Custom Method
//选择城市
- (void)selectCityAction:(UIBarButtonItem *)barBtn{
    SelectViewController *selectCityVC = [[SelectViewController alloc]init];
    [self presentViewController:selectCityVC animated:YES completion:nil];
}

//搜索关键字
- (void)searchActivityAction:(UIButton *)btn {
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

//自定义TableView头部
- (void)configTableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 343)];
    self.tableView.tableHeaderView = tableViewHeaderView;
    //添加轮播图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 186)];
    self.scrollView.contentSize = CGSizeMake(self.adArray.count *[UIScreen mainScreen].bounds.size.width, 186);
    //整屏滑动
    self.scrollView.pagingEnabled = YES;
    //不显示水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    //创建小圆点
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 156, kScreenWidth, 30)];
    //小圆点个数
    self.pageControl.numberOfPages = self.adArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    [self.pageControl addTarget:self action:@selector(pageSelectAction:) forControlEvents:UIControlEventValueChanged];
    
    
    
    for (int i = 0;i < self.adArray.count ; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i]] placeholderImage:nil];
        [self.scrollView addSubview:imageView];
    }
    [tableViewHeaderView addSubview:self.scrollView];
    
   //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width / 4, 186, [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d",i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeaderView addSubview:btn];
        [tableViewHeaderView addSubview:self.pageControl];
    }
    //精选活动&热门活动
    UIButton *activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activityBtn.frame = CGRectMake(0, 186 + [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, 343 - 186 - [UIScreen mainScreen].bounds.size.width / 4);
    [activityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
    [activityBtn addTarget:self action:@selector(activityButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeaderView addSubview:activityBtn];
    
    UIButton *hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hotBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 186 + [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, 343 - 186 - [UIScreen mainScreen].bounds.size.width / 4);
    [hotBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
    [hotBtn addTarget:self action:@selector(hotButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeaderView addSubview:hotBtn];
}

- (void)requestModel{
    
    NSString *urlString = @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1";
    AFHTTPSessionManager *sessionManage = [AFHTTPSessionManager manager];
    sessionManage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManage GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld",downloadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            //推荐活动
            NSArray *acDataArray = dic[@"acData"];
            for (NSDictionary *dict in acDataArray) {
                MainModel *model = [[MainModel alloc]initWithDictionary:dict];
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
            
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            for (NSDictionary *dict in rcDataArray) {
                MainModel *model = [[MainModel alloc]initWithDictionary:dict];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            //刷新tableView数据
            [self.tableView reloadData];
            //广告
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dic in adDataArray) {
                [self.adArray addObject:dic[@"url"]];
            }
            
            //拿到数据之后重新刷新请求
            [self configTableViewHeaderView];
            //以请求回来的城市做为导航栏按钮标题
            NSString *cityName = dic[@"cityname"];
            self.navigationItem.leftBarButtonItem.title = cityName;
            
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark --------- 按钮实现方法

//分类列表
- (void)mainActivityButtonAction:(UIButton *)btn{
    ClassifyViewController *classifyVC = [[ClassifyViewController alloc]init];
    [self.navigationController pushViewController:classifyVC animated:YES];
}

//精选活动
- (void)activityButtonAction{
    ActivityViewController *activityVC = [[ActivityViewController alloc]init];
    [self.navigationController pushViewController:activityVC animated:YES];
}

//热门专题
- (void)hotButtonAction{
    HotViewController *hotVC = [[HotViewController alloc]init];
    [self.navigationController pushViewController:hotVC animated:YES];
}

#pragma mark -------- lazyLoading

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}

- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}

- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
}

#pragma mark ------- 首页轮播图

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取scrollView页面的宽度
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //获取scrollView停止时候的偏移量
    //contentOffset是当前scrollView距离原点偏移的位置
    CGPoint offset = self.scrollView.contentOffset;
    //通过偏移量计算出当前的页数
    NSInteger pageNum = offset.x / pageWidth;
    self.pageControl.currentPage = pageNum;
}

- (void)pageSelectAction:(UIPageControl *)pageControl{
    //获取scrollView页面的宽度
    NSInteger pageNumber = pageControl.currentPage;
    //获取scrollView停止时候的偏移量
    //contentOffset是当前scrollView距离原点偏移的位置
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //让小圆点滑动到第几页
    self.scrollView.contentOffset = CGPointMake(pageNumber * pageWidth, 0);
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

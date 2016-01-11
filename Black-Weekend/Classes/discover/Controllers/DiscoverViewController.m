//
//  DiscoverViewController.m
//  Black-Weekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoveryTableViewCell.h"
@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor redColor];
    CGRect tableViewRect = CGRectMake(0.0, 0.0, 50.0, 320.0);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.tableView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //tableview逆时针旋转90度。
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    
    // scrollbar 不显示
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell1;
    DiscoveryTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cell1];
    return cell;
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

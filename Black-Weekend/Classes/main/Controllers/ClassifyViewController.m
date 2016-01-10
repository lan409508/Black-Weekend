//
//  ClassifyViewController.m
//  Black-Weekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "ClassifyViewController.h"

@interface ClassifyViewController ()

@property(nonatomic, strong) UISegmentedControl *segmentControl;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButton];
    self.title = @"分类列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"演出剧目",@"景点场馆",@"学习益智",@"亲子游戏"]];
    self.segmentControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [self.view addSubview:self.segmentControl];
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

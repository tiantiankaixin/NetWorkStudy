//
//  MainPageViewController.m
//  NetWorkStudy
//
//  Created by wangtian on 16/4/21.
//  Copyright © 2016年 wangtian. All rights reserved.
//

#import "MainPageViewController.h"
#import "MoreRequestSyncViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"网络请求学习"];
    [self addARowWithCellTitle:@"多个网络请求的同步问题" vcClass:[MoreRequestSyncViewController class] turnType:M_push];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

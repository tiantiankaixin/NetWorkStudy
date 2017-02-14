//
//  RequestCancerViewController.m
//  NetWorkStudy
//
//  Created by mal on 16/11/25.
//  Copyright © 2016年 wangtian. All rights reserved.
//

#import "RequestCancerViewController.h"
#import "UIViewController+afn.h"

#define Url2 @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=1&contentType=album&device=iPhone&position=&scale=2&title=%E6%9B%B4%E5%A4%9A&version=4.3.38"

@interface RequestCancerViewController ()

@property (nonatomic, copy) NSString *requestFlag;

@end

@implementation RequestCancerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   [self postWithUrl:Url2 pa:nil finish:^(RequestResult *result) {
       
       NSLog(@"%@",result.errorDes);
       
   } des:@"测试"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"页面被释放了");
}

@end

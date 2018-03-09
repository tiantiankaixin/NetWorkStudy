//
//  MainPageViewController.m
//  NetWorkStudy
//
//  Created by wangtian on 16/4/21.
//  Copyright © 2016年 wangtian. All rights reserved.
//

#import "MainPageViewController.h"
#import "MoreRequestSyncViewController.h"
#import "RequestCancerViewController.h"
#import "RequestCacheViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"网络请求学习"];
    [self addARowWithCellTitle:@"多个网络请求的同步问题" vcClass:[MoreRequestSyncViewController class] turnType:M_push];
    [self addARowWithCellTitle:@"请求取消" vcClass:[RequestCancerViewController class] turnType:M_push];
    [self addARowWithCellTitle:@"请求缓存" vcClass:[RequestCacheViewController class] turnType:M_push];
    [self maxCount1];
    
    [MALAFNManger downLoadTest];
    // Do any additional setup after loading the view.
}

- (void)groupSync
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        sleep(5);
        NSLog(@"任务一完成");
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(8);
        NSLog(@"任务二完成");
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"任务完成");
    });
}

- (void)groupSync2
{
    dispatch_queue_t dispatchQueue = dispatch_queue_create("com.shidaiyinuo.NetWorkStudy1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        
        dispatch_async(globalQueue, ^{
           
            sleep(3);
            NSLog(@"任务一完成");
        });

    });
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        
        dispatch_async(globalQueue, ^{
            
            sleep(2);
            NSLog(@"任务二完成");
        });
        
    });
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        NSLog(@"dispatch_group_notify 被执行了");
    });
}

#pragma mark - 等任务1执行完再执行任务2
- (void)groupSync3
{
    __block dispatch_semaphore_t semap = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(5);
        NSLog(@"我是任务一");
        dispatch_semaphore_signal(semap);
        semap = nil;
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (dispatch_semaphore_wait(semap, dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC)))//超时返回非零
        {
            //处理超时  也可以把超时时间设置成forever；会一直等待直到收到信号
        }
        else//不超时返回0
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSLog(@"我是任务二");
            });
        }

    });
}

- (NSMutableArray *)testArray
{
    NSMutableArray *test = [[NSMutableArray alloc] init];
    int n = 10;//数组个数
    int m = 10;//每个数组元素个数
    for (int i = 0; i < n; i++)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int j = 0; j < m; j++)
        {
            [arr addObject:[NSNumber numberWithInt:arc4random() % 1000]];
        }
        [test addObject:arr];
    }
    return test;
}

- (int)maxNoInArray:(NSMutableArray *)array currentMax:(int)max
{
    for (NSNumber *num in array)
    {
        if (num.intValue > max)
        {
            max = num.intValue;
        }
    }
    return max;
}

- (void)maxCount1
{
    NSMutableArray *countArray = [self testArray];
    int max = 0;
    for (NSMutableArray *arr in countArray)
    {
        max = [self maxNoInArray:arr currentMax:max];
    }
    NSLog(@"=====真实最大值是%d",max);
}

- (void)maxCount2
{
    NSMutableArray *countArray = [self testArray];
    __block int max = 0;
    for (NSMutableArray *arr in countArray)
    {
        dispatch_async(dispatch_get_global_queue(0,0), ^{
        
            max = [self maxNoInArray:arr currentMax:max];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  NotiVincoNavigationController.m
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 14/10/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

#import "NotiVincoNavigationController.h"
#import <RESideMenu/RESideMenu.h>

@interface NotiVincoNavigationController ()

@end

@implementation NotiVincoNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognized:)];
    swipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.navigationBar addGestureRecognizer:swipeGesture];
    swipeGesture=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender{
    [self.sideMenuViewController presentLeftMenuViewController];
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

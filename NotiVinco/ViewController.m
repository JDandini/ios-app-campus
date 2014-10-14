//
//  ViewController.m
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 14/10/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController
-(void)awakeFromNib{
    self.contentViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuController"];
    self.backgroundImage=[UIImage imageNamed:@"Stars"];
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    self.panGestureEnabled=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

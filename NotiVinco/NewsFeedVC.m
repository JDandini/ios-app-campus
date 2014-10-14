//
//  NewsFeedVC.m
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 14/10/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

#import "NewsFeedVC.h"

@interface NewsFeedVC (){
    NSArray *newsArray;
}

@end

@implementation NewsFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    newsArray=@[@"Elemento 0",@"Elemento 1",@"Elemento 2",@"Elemento 3",@"Elemento 4"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [newsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellNews" forIndexPath:indexPath];
    cell.textLabel.text=[newsArray objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

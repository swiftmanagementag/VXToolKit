//
//  VXMoreTableViewDataSource.m
//  iTheorie
//
//  Created by Graham Lancashire on 11.02.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import "VXMoreTableViewDataSource.h"
#import "UIColor+Palette.h"

@implementation VXMoreTableViewDataSource

-(VXMoreTableViewDataSource *) initWithDataSource:(id<UITableViewDataSource>) dataSource
{
    self.originalDataSource = dataSource;
    if (!(self = [super init])) return nil;
	
    return self;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.originalDataSource tableView:table numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.originalDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
   	cell.textLabel.textColor = [UIColor textColor];
    return cell;
}

@end

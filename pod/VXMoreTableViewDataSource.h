//
//  VXMoreTableViewDataSource.h
//  iTheorie
//
//  Created by Graham Lancashire on 11.02.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VXMoreTableViewDataSource : NSObject <UITableViewDataSource> {}

@property (strong) id<UITableViewDataSource> originalDataSource;

-(VXMoreTableViewDataSource *) initWithDataSource:(id<UITableViewDataSource>) dataSource NS_DESIGNATED_INITIALIZER;

@end
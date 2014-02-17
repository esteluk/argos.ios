//
//  AREmbeddedTableView.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AREmbeddedTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *items;

- (void)sizeToFit;

@end
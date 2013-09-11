//
//  MasterViewController.h
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/19/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebViewController;

@interface MasterViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WebViewController *webViewController;
@property (strong, nonatomic) NSURL *feedUrl;
@end

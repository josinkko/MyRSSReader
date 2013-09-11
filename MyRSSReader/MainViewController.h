//
//  MainViewController.h
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/25/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedUrl.h"

@interface MainViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void) fetchNewFeed: (NSString *)feedURL;
- (void) addToFeed: (NSArray *)params;

@end

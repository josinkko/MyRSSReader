//
//  MasterViewController.m
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/19/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import "MasterViewController.h"
#import "WebViewController.h"
#import "TableHeaderView.h"
#import "RSSItem.h"
#import "RSSLoader.h"

@interface MasterViewController () {
    NSArray *_objects;
    UIRefreshControl *refreshControl;
}
@end

@implementation MasterViewController

@synthesize feedUrl, webViewController;

-(void) refreshFeed
{
    RSSLoader *rss = [[RSSLoader alloc] init];
    [rss fetchRssWithUrl:feedUrl complete:^(NSString *title, NSArray *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [(TableHeaderView *) self.tableView.tableHeaderView setText:title]; 
            _objects = results;
            [self.tableView reloadData];
            
            [refreshControl endRefreshing];
        });
    }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"myRSSreader";
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshInvoked:forState:) forControlEvents:UIControlEventValueChanged];
    
    NSString *fetchMessage = [NSString stringWithFormat:@"fetching: %@", feedUrl];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:fetchMessage attributes:
                                      @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    
    [self.tableView addSubview:refreshControl];
    self.tableView.tableHeaderView = [[TableHeaderView alloc] initWithText:@"fetching RSS feed"];
    
    [self refreshFeed];
}
-(void) refreshInvoked:(id) sender forState: (UIControlState)state
{
    [self refreshFeed];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    RSSItem *object = _objects[indexPath.row];
    cell.textLabel.attributedText = object.cellMessage;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSSItem *item = [_objects objectAtIndex:indexPath.row];
    CGRect cellMessageRect = [item.cellMessage boundingRectWithSize:CGSizeMake(200, 10000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return cellMessageRect.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    webViewController = [[WebViewController alloc] init];
    [self setWebViewController:webViewController];
    
    [[self navigationController] pushViewController:webViewController animated:YES];
    RSSItem *urlItem = [_objects objectAtIndex:[indexPath row]];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlItem.link];
    [[webViewController webView] loadRequest:request];
    [[webViewController navigationItem] setTitle:urlItem.title];
    
}

@end

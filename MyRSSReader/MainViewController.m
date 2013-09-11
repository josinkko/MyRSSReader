//
//  MainViewController.m
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/25/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import "MainViewController.h"
#import "RSSItem.h"
#import "MasterViewController.h"
#import "RSSLoader.h"
#import "FeedUrl.h"
#import "feedUrlStorage.h"


@interface MainViewController ()
{
    NSMutableArray *urlObjects;
    NSMutableArray *persistedUrls;
    feedUrlStorage *storage;
}


@end

@implementation MainViewController
@synthesize urlTextField;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        persistedUrls = [[NSMutableArray alloc] init];
        storage = [[feedUrlStorage alloc] init];

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{

    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    //[[self tableView] setBackgroundColor:[UIColor redColor]];
 
    self.urlTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
    self.navigationItem.titleView = self.urlTextField;
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
    self.urlTextField.placeholder = @"Enter a new URL";
    self.urlTextField.delegate = self;
    
    [super viewWillAppear:animated];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedUrl" inManagedObjectContext:[storage context]];
    [request setEntity:entity];
    NSError *error = nil;
    
    NSArray *results = [[storage context] executeFetchRequest:request error:&error];
    for (FeedUrl *f in results) {
        [persistedUrls addObject:f];
    }
    
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [persistedUrls removeAllObjects];
}

- (void) fetchNewFeed: (NSString *)feedURL
{
    RSSLoader *rss = [[RSSLoader alloc] init];
    NSURL *url = [NSURL URLWithString:feedURL];
    [rss fetchRssWithUrl:url complete:^(NSString *title, NSArray *results) {
        NSMutableArray *resultsArray = [[NSMutableArray alloc] initWithObjects:title, feedURL, nil];
        [self performSelectorOnMainThread:@selector(addToFeed:) withObject:resultsArray waitUntilDone:YES];
    }];
}

- (void) addToFeed: (NSArray *)params
{
    FeedUrl *urlItem = [NSEntityDescription insertNewObjectForEntityForName:@"FeedUrl" inManagedObjectContext:[storage context]];
    urlItem.title = [params objectAtIndex:0];
    urlItem.url = [params objectAtIndex:1];
    
    NSError *error = nil;

    if ([[storage context] save:&error]) {
        NSLog(@"Save was successfull");
    } else {
        NSLog(@"Couldn't save. Reason: %@", [error localizedDescription]);
    }
    [persistedUrls addObject:urlItem];
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [persistedUrls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    [[cell textLabel] setText:[[persistedUrls objectAtIndex:indexPath.row]title]];
    //[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    //[cell setBackgroundColor:[UIColor clearColor]];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSURL *feedUrl = [[NSURL alloc] init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedUrl" inManagedObjectContext:[storage context]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *result = [[storage context] executeFetchRequest:fetchRequest error:&error];
    for (FeedUrl *f in result) {
        if ([[persistedUrls objectAtIndex:indexPath.row]title] == f.title) {
            feedUrl = [NSURL URLWithString:f.url];
        }
    }

    MasterViewController *mvc = [[MasterViewController alloc] init];
    [mvc setFeedUrl:feedUrl];
    [[self navigationController] pushViewController:mvc animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int ip = indexPath.row;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FeedUrl"];
        request.predicate = [NSPredicate predicateWithFormat:@"title == %@" , [[persistedUrls objectAtIndex:ip] title]];
        
        NSError *error = nil;
        FeedUrl *urlItem = [[[storage context] executeFetchRequest:request error:nil] lastObject];
        [[storage context] deleteObject:urlItem];
        
        if ([[storage context] save:&error]) {
            NSLog(@"Successfully deleted feedURl from Core Data!");
            [persistedUrls removeObjectAtIndex:ip];
            [[self tableView] reloadData];
        } else {
            NSLog(@"Couldn't delete from Core Data. Reason: %@", [error localizedDescription]);
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *urlString = [textField text];
    [self fetchNewFeed:urlString];
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}




@end

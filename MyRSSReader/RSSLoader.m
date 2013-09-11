//
//  RSSLoader.m
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/19/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import "RSSLoader.h"
#import "RSSItem.h"
#import "RXMLElement.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation RSSLoader
-(void)fetchRssWithUrl:(NSURL *)url complete:(RSSLoaderCompleteBlock)c
{
    dispatch_async(kBgQueue, ^{
        
        RXMLElement *rss = [RXMLElement elementFromURL:url];
        RXMLElement *title = [[rss child:@"channel"] child:@"title"];
        NSArray *items = [[rss child:@"channel"] children:@"item"];
        
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:items.count];
        
        for(RXMLElement *e in items) {
            RSSItem *item = [[RSSItem alloc] init];
            item.title = [[e child:@"title"] text];
            item.description = [[e child:@"description"] text];
            item.link = [NSURL URLWithString:[[e child:@"link"] text]];
            [result addObject:item];
        }
        
        c([title text], result);
    });
}

@end

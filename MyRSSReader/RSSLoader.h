//
//  RSSLoader.h
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/19/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RSSLoaderCompleteBlock) (NSString *title, NSArray *results);

@interface RSSLoader : NSObject

- (void)fetchRssWithUrl:(NSURL *)url complete: (RSSLoaderCompleteBlock)c;
@end

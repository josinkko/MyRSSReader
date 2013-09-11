//
//  RSSItem.h
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/19/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSAttributedString *cellMessage;

@end

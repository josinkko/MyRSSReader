//
//  feedUrlStorage.h
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/27/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface feedUrlStorage : NSObject

@property (nonatomic, readonly, strong) NSManagedObjectContext *context;

+(feedUrlStorage*) sharedStorage;

@end
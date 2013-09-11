//
//  feedUrlStorage.m
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/27/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import "feedUrlStorage.h"

@interface feedUrlStorage ()

@property (nonatomic, readwrite, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation feedUrlStorage

+(feedUrlStorage *)sharedStorage
{
    static feedUrlStorage *sharedInstance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[feedUrlStorage alloc] init];
    });
    
    return sharedInstance;
}

-(NSManagedObjectContext *)context
{
    if(!_context)
    {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = [self persistentStoreCoordinator];
    }
    
    return _context;
}

-(NSManagedObjectModel *)model
{
    if(!_model)
    {
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelPath]];
    }
    
    return _model;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(!_persistentStoreCoordinator)
    {
        NSLog(@"%@", [self storeURL]);
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        NSError *error;
        
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error])
        {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Could not create persistent store."
                                         userInfo:error.userInfo];
        }
        
        _persistentStoreCoordinator = psc;
    }
    
    return _persistentStoreCoordinator;
}

-(NSString*) modelName
{
    return @"MyRSSReader";
}

-(NSURL*) modelPath
{
    return [[NSBundle mainBundle] URLForResource:[self modelName] withExtension:@"momd"];
}

-(NSString*) storeFileName
{
    NSLog(@"%@", [[self modelName]stringByAppendingPathExtension:@"sqlite"]);
    return [[self modelName]stringByAppendingPathExtension:@"sqlite"];
}

-(NSURL*) storeURL
{
    
    return[[self documentDirectory] URLByAppendingPathComponent:[self storeFileName]];
}

-(NSURL*) documentDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    return documentDirectoryURL;
}

@end

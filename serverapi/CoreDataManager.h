//
//  CoreDataManager.h
//  serverapi
//
//  Created by Vladimir Opanasenko on 12.04.2018.
//  Copyright © 2018 Vladimir Opanasenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
- (NSManagedObjectContext *)context;

+ (CoreDataManager *)sharedManager;


@end

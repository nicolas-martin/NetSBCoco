//
//  iCloudHelper.h
//  TowerWars
//
//  Created by Henri Lapierre on 3/22/14.
//  Copyright (c) 2014 Henri Lapierre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Player;

@interface iCloudHelper : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator ;
@property (nonatomic, strong) NSPersistentStore* iCloudStore;
@property (nonatomic, strong) Player* player;

+ (iCloudHelper*)sharedInstance;
- (void)loadiCloudStore;


@end

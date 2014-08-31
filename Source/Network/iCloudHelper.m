 //
//  iCloudHelper.m
//  TowerWars
//
//  Created by Henri Lapierre on 3/22/14.
//  Copyright (c) 2014 Henri Lapierre. All rights reserved.
//

#import "iCloudHelper.h"
#import <CoreData/CoreData.h>
#import "Player.h"
#import "GameCenterHelper.h"

@implementation iCloudHelper

+(id)sharedInstance {
    static iCloudHelper *sharediCloudHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharediCloudHelper =
		[[iCloudHelper alloc] init];
    });
    return sharediCloudHelper;
}

- (id)init {
    if (self = [super init]) {
        //NSFileManager* fileManager = [NSFileManager defaultManager];
        //id currentToken = [fileManager ubiquityIdentityToken];
        //BOOL isSignedIntoICloud= (currentToken!=nil);
    }
    return self;
}

- (void)loadiCloudStore {
    _player = [[NSUbiquitousKeyValueStore defaultStore] valueForKey:@"player"];
    
    if (_player == nil) {
        NSLog(@"No user found - creating a new one.");
        _player = [self createNewPlayer];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    }
    NSLog(@"%@", [_player playerName]);
    
}

- (Player*)createNewPlayer {
    Player* player = [[Player alloc] init];
    player.playerName = [[[GameCenterHelper sharedInstance] localPlayer] displayName];
    player.playerId = [[[GameCenterHelper sharedInstance] localPlayer] playerID];
    player.rating = 1500;
    player.unlockedTower = 3;
    player.playerType = kPlayerLocal;
    
    return player;
}



// Subscribe to NSPersistentStoreCoordinatorStoresDidChangeNotification
- (void)storesDidChange:(NSNotification *)note {
    NSString* name = [[NSUbiquitousKeyValueStore defaultStore] stringForKey:@"name"];
    
    NSLog(@"%@", name);
    // here is when you can refresh your UI and
    // load new data from the new store
}


@end

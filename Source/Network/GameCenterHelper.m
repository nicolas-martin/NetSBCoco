//
//  GameCenterHelp.m
//  TowerWars
//
//  Created by Henri Lapierre on 3/22/14.
//  Copyright (c) 2014 Henri Lapierre. All rights reserved.
//

#import "GameCenterHelper.h"
#import "iCloudHelper.h"
#import "Player.h"

@interface GameCenterHelper () {
    BOOL _gameCenterFeaturesEnabled;
}
@end


@implementation GameCenterHelper

+(id)sharedInstance {
    static GameCenterHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
		[[GameCenterHelper alloc] init];
    });
    return sharedGameKitHelper;
}

-(id)init {
    if (self = [super init]) {
        _listObservers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UIViewController*)viewController {
    if (_viewController == nil) {
        _viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return _viewController;
}

- (void) authenticateLocalPlayer {
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if ([GKLocalPlayer localPlayer].authenticated) {
            _localPlayer = [GKLocalPlayer localPlayer];
            [[iCloudHelper sharedInstance] loadiCloudStore];
            NSLog(@"Authenticated");
        } else if(viewController) {
            NSLog(@"Shoud authenticate");
            [[self viewController] presentViewController:viewController animated:YES completion:nil];
        } else {
            NSLog(@"Disabled?");
        }
    };
}

- (void)findOpponent {
    PlayerType playerType = kPlayerLocal;
    Player* player = [self readPlayer];
    [player setPlayerType:playerType];
    
    //[reader readStatsForPlayer:player];
    
    [self notifyReceivedPlayer:player];
    
    GKMatchRequest* request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc]
                                         initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
   /* [[[GKMatchmaker alloc] init] findMatchForRequest:request withCompletionHandler:^(GKMatch *match, NSError *error) {
           NSLog(@"Error finding match: %@", error.localizedDescription);
    }];*/
    [[self viewController] presentViewController:mmvc animated:YES completion:nil];
}


- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    NSLog(@"Matchrequest cancelled");
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
}


- (Player*)readPlayer {
    NSString *playerId = @"0000";
    NSString *playerName = @"Yianks";
    int rating = 1500;
    int level = 1;
    int xp = 100;
    int unlockedTower = 11;
    
    Player *player = [[Player alloc] initWithPlayerId:playerId playerName:playerName rating:rating];
    [player setLevel:level];
    [player setXp:xp];
    
    return player;
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [[self viewController] dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    NSLog(@"he");
    [[self viewController] dismissViewControllerAnimated:NO completion:nil];
    _match = theMatch;
    [_match setDelegate:self];
    NSLog(@"Ready to start match!");
    
    [self notifyMatchFound:nil];
    

    
    PlayerType new_playerType = kPlayerDistant;
    Player* new_player = [self readPlayer];
    [new_player setPlayerType:new_playerType];
    
    //[reader readStatsForPlayer:player];
    
    [self notifyReceivedPlayer:new_player];
}

- (void)sendCreepSpawned:(int)creepType time:(double)time {
    NSLog(@"AAAH");
}
- (void)sendFindMatch {
    NSLog(@"AAAH");
}
- (void)sendGetLadder {
    NSLog(@"AAAH");
}
- (void)sendMatchOverWithWinner:(NSString *)winner {
    NSLog(@"AAAH");
}
- (void) sendTowerBuilt:(int)towerType position:(CGPoint)position time:(double)time {
    NSLog(@"AAAH");
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindPlayers:(NSArray *)playerIDs {
    NSLog(@"Super he");
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didReceiveAcceptFromHostedPlayer:(NSString *)playerID {
    NSLog(@"Wow");
}

- (void)sendAction:(Action *)action {
    [_match sendDataToAllPlayers:[NSKeyedArchiver archivedDataWithRootObject:action] withDataMode:GKSendDataReliable error:nil];
    NSLog(@"Action sent");
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"Action received!");
    NSData* newData = data;
    Action* action =[NSKeyedUnarchiver unarchiveObjectWithData:newData];
    [self notifyReceivedAction:action];
}

#pragma mark - Notify observers
- (void)addNetworkObserver:(id<NetworkControllerDelegate>)observer {
    NSLog(@"Adding one observer");
    [_listObservers addObject:observer];
}

- (void)notifyMatchFound:(Match*)match {
    NSLog(@"About to notify observers");
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        NSLog(@"Found one..");
        if ([observer respondsToSelector:@selector(updateMatchFound:)]) {
            NSLog(@"Notification sent");
            [observer updateMatchFound:match];
        }
    }
}

- (void)notifyReceivedAction:(Action*)action {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateActionReceived:)]) {
            [observer updateActionReceived:action];
        }
    }
}

- (void)notifyMatchStarted {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateMatchStarted)]) {
            [observer updateMatchStarted];
        }
    }
}

- (void)notifyReceivedPlayer:(Player*)player {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateReceivedPlayer:)]) {
            NSLog(@"Notify new player");
            [observer updateReceivedPlayer:player];
        }
    }
}




@end

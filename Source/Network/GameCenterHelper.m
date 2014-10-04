//
//  GameCenterHelp.m
//  TowerWars
//
//  Created by Henri Lapierre on 3/22/14.
//  Copyright (c) 2014 Henri Lapierre. All rights reserved.
//

#import "GameCenterHelper.h"
#import "Board.h"

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
        _listPlayers = [[NSMutableArray alloc] init];
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

            //TODO Don't need to save anything for now.
            //[[iCloudHelper sharedInstance] loadiCloudStore];

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

    GKMatchRequest* request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 4;

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

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [[self viewController] dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [_listPlayers addObject:theMatch.players];

    [[self viewController] dismissViewControllerAnimated:NO completion:nil];
    _match = theMatch;
    [_match setDelegate:self];
    NSLog(@"Ready to start match!");

}

- (void) loadPlayerData: (NSArray *) identifiers {
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
        if (error != nil) {
            // Handle the error.
        }
        if (players != nil) {
            // Process the array of GKPlayer objects.
        }
    }];
}

// Players have been found for a server-hosted game, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindPlayers:(NSArray *)playerIDs {
    //TODO: save the player to the list - How to resolve then to names?

}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didReceiveAcceptFromHostedPlayer:(NSString *)playerID {
    NSLog(@"Wow");
}

- (void)sendAction:(Board *)board {
    [_match sendDataToAllPlayers:[NSKeyedArchiver archivedDataWithRootObject:board] withDataMode:GKSendDataReliable error:nil];
    NSLog(@"Action sent");
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"Action received!");
    NSData* newData = data;
    Board* action =[NSKeyedUnarchiver unarchiveObjectWithData:newData];
//    NSMutableArray *playerBoardBlocks;
//
//    targetBoardBlocks = targetBoard.getAllBlocksInBoard;
//
//    [senderField.board DeleteBlockFromBoardAndSprite:playerBoardBlocks];
//    [targetBoard DeleteBlockFromBoardAndSprite:targetBoardBlocks];
//
//    [senderField.board addBlocks:targetBoardBlocks];


}




@end

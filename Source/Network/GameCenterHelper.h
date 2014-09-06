//
//  GameCenterHelp.h
//  TowerWars
//
//  Created by Henri Lapierre on 3/22/14.
//  Copyright (c) 2014 Henri Lapierre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@class Player;
@class Board;

@interface GameCenterHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate>

@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) GKMatch *match;
@property (nonatomic, strong) NSMutableArray *listObservers;
@property (strong, nonatomic) GKPlayer* localPlayer;

+ (GameCenterHelper*)sharedInstance;
- (void) authenticateLocalPlayer;
- (void) findOpponent;
- (void) sendAction:(Board *)action;

@end

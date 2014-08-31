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
@class Match;
@class Action;

@protocol NetworkControllerDelegate <NSObject>
@optional
- (void)updateSetNotInMatch;
- (void)updateSearchingWithRatingMin:(int)ratingMin ratingMax:(int)ratingMax;
- (void)updateMatchFound:(Match*)match;
- (void)updateReceivedPlayer:(Player*)player;
- (void)updateMatchStarted;
- (void)updateOpponentCreepSent:(int)creepType time:(double)time;
- (void)updateOpponentTowerBuilt:(int)towerType position:(CGPoint)position time:(double)time;
- (void)updateMatchOverWithWinner:(NSString*)winner rating:(int)rating;
- (void)updateReceivedLadder:(NSMutableArray*)listPlayers ranking:(int)ranking;
- (void)updateActionReceived:(Action*)action;
@end

@interface GameCenterHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate>


@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) GKMatch *match;
@property (nonatomic, strong) NSMutableArray *listObservers;
@property (strong, nonatomic) GKPlayer* localPlayer;

+ (GameCenterHelper*)sharedInstance;
- (void) authenticateLocalPlayer;
- (void) findOpponent;
- (void) sendAction:(Action*)action;
- (void)addNetworkObserver:(id<NetworkControllerDelegate>)observer;

- (void)sendCreepSpawned:(int)creepType time:(double)time;
- (void)sendTowerBuilt:(int)towerType position:(CGPoint)position time:(double)time;
- (void)sendFindMatch;
- (void)sendMatchOverWithWinner:(NSString*)winner;
- (void)sendGetLadder;

@end

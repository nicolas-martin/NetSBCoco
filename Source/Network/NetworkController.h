//
//  NetworkController.h
//  TowerWars
//
//  Created by Henri Lapierre on 5/21/13.
//  Copyright (c) 2013 Henri Lapierre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@class Match;
@class Player;

typedef enum {
    NetworkStateNotAvailable,
    NetworkStatePendingAuthentication,
    NetworkStateAuthenticated,
    NetworkStateConnectingToServer,
    NetworkStateConnected,
    NetworkStatePendingMatchStatus,
    NetworkStateReceivedMatchStatus,
    NetworkStatePendingMatch,
    NetworkStatePendingMatchStart,
    NetworkStateMatchActive,
} NetworkState;

/*
@protocol NetworkControllerDelegate <NSObject>
@optional
- (void)updateStateChanged:(NetworkState)state;
- (void)updateSetNotInMatch;
- (void)updateSearchingWithRatingMin:(int)ratingMin ratingMax:(int)ratingMax;
- (void)updateMatchFound:(Match*)match;
- (void)updateReceivedPlayer:(Player*)player;
- (void)updateMatchStarted;
- (void)updateOpponentCreepSent:(int)creepType time:(double)time;
- (void)updateOpponentTowerBuilt:(int)towerType position:(CGPoint)position time:(double)time;
- (void)updateMatchOverWithWinner:(NSString*)winner rating:(int)rating;
- (void)updateReceivedLadder:(NSMutableArray*)listPlayers ranking:(int)ranking;
@end
 */

@interface NetworkController : NSObject <NSStreamDelegate>

@property (strong) NSInputStream *inputStream;
@property (strong) NSOutputStream *outputStream;
@property (assign) BOOL inputOpened;
@property (assign) BOOL outputOpened;

@property (strong) NSMutableData *outputBuffer;
@property (assign) BOOL okToWrite;

@property (assign, readonly) BOOL gameCenterAvailable;
@property (assign, readonly) BOOL userAuthenticated;
@property (assign, readonly) NetworkState state;

@property (strong) NSMutableData *inputBuffer;
@property (strong) UIViewController *presentingViewController;

@property (strong) NSString* playerId;
@property (strong) NSString* alias;

@property (assign) int messageId;

@property (nonatomic, strong) NSMutableArray *listObservers;

+ (NetworkController *)sharedInstance;
- (void)authenticateLocalUser;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController;
- (void)connect;

//- (void)addNetworkObserver:(id<NetworkControllerDelegate>)observer;

- (void)sendCreepSpawned:(int)creepType time:(double)time;
- (void)sendTowerBuilt:(int)towerType position:(CGPoint)position time:(double)time;
- (void)sendFindMatch;
- (void)sendMatchOverWithWinner:(NSString*)winner;
- (void)sendGetLadder;

@end
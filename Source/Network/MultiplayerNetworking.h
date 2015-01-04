//
//  MultiplayerNetworking.h
//  CatRaceStarter
//
//  Created by Kauserali on 06/01/14.
//  Copyright (c) 2014 Raywenderlich. All rights reserved.
//

#import "GameKitHelper.h"
#import "CCControl.h"
#import "ICastable.h"

@class Field;
@class Block;

@protocol MultiplayerNetworkingProtocol <NSObject>
- (void)matchEnded;
- (void)setCurrentPlayerIndex:(NSUInteger)index;
- (void)moveFromPlayerAtIndex:(NSUInteger)index BlockX:(uint32_t)x BlockY:(uint32_t)y BlockType:(uint16_t)type Spell:(uint16_t)spell Target:(uint32_t)target;
- (void)deleteBlock:(NSUInteger)id X:(uint32_t)x Y:(uint32_t)y target:(uint32_t)target;
- (void)gameOver:(BOOL)player1Won;
- (void)setPlayerAliases:(NSArray*)playerAliases;

@end

@interface MultiplayerNetworking : NSObject<GameKitHelperDelegate>
@property (nonatomic, assign) id<MultiplayerNetworkingProtocol> delegate;

- (void)sendMove:(Block *)field target:(NSUInteger)target;
- (void)sendGameEnd:(BOOL)player1Won;
- (void)sendSpell:(spellsType)type target:(NSUInteger)target from:(NSUInteger)from;

- (void)sendDelete:(Block *)block targetId:(NSUInteger)id1;
@end

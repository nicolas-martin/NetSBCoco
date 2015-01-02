//
//  MultiplayerNetworking.h
//  CatRaceStarter
//
//  Created by Kauserali on 06/01/14.
//  Copyright (c) 2014 Raywenderlich. All rights reserved.
//

#import "GameKitHelper.h"
#import "CCControl.h"

@class Field;
@class Block;

@protocol MultiplayerNetworkingProtocol <NSObject>
- (void)matchEnded;
- (void)setCurrentPlayerIndex:(NSUInteger)index;
- (void)moveFromPlayerAtIndex:(NSUInteger)index BlockX:(uint32_t)x BlockY:(uint32_t)y BlockType:(uint16_t)type Spell:(uint16_t)spell;
- (void)gameOver:(BOOL)player1Won;
- (void)setPlayerAliases:(NSArray*)playerAliases;
@end

@interface MultiplayerNetworking : NSObject<GameKitHelperDelegate>
@property (nonatomic, assign) id<MultiplayerNetworkingProtocol> delegate;
- (void)sendMove:(Block *)field;
- (void)sendGameEnd:(BOOL)player1Won;
@end

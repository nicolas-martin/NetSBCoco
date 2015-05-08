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
#import "CCBSequenceProperty.h"
#import "CCRendererBasicTypes_Private.h"
#import "CCTMXXMLParser.h"

@class Field;
@class Block;

@protocol MultiplayerNetworkingProtocol <NSObject>
- (void)matchEnded;
- (void)setCurrentPlayerIndex:(NSUInteger)index;
- (void)addFromPlayerAtIndex:(NSUInteger)index BlockX:(uint32_t)x BlockY:(uint32_t)y BlockType:(uint16_t)type Spell:(uint16_t)spell Target:(uint32_t)target;
- (void)deleteBlock:(NSUInteger)id X:(uint32_t)x Y:(uint32_t)y target:(uint32_t)target;
- (void)addSpell:(NSUInteger)id X:(uint32_t)x Y:(uint32_t)y target:(uint32_t)target spell:(int32_t)spell;
- (void)moveBlock:(NSUInteger)id X:(uint32_t)x Y:(uint32_t)y target:(uint32_t)target step:(int32_t)step;
- (void)gameOver:(NSUInteger)player1Won didWin:(BOOL)didwin;
- (void)setPlayerAliases:(NSArray*)playerAliases;
- (void)updateInventory:(NSUInteger)id target:(uint32_t)target spell:(int32_t)spell;

@end

@interface MultiplayerNetworking : NSObject<GameKitHelperDelegate>
@property (nonatomic, assign) id<MultiplayerNetworkingProtocol> delegate;


- (void)sendGameEnd:(BOOL)player1Won;

- (void)sendAdd:(Block *)field target:(NSUInteger)target;
- (void)sendDelete:(Block *)block targetId:(NSUInteger)id1;
- (void)sendMove:(CGPoint)key by:(NSInteger)by targetId:(NSUInteger)id;
- (void)sendAddSpell:(Block *)block targetId:(NSUInteger)id;
- (void)sendUpdateInventory:(spellsType)type targetId:(NSUInteger)id;

@end

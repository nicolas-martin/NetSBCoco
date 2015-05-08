//
//  MultiplayerNetworking.m
//  CatRaceStarter
//
//  Created by Kauserali on 06/01/14.
//  Copyright (c) 2014 Raywenderlich. All rights reserved.
//

#import "MultiplayerNetworking.h"
#import "Block.h"
#import "CCControl.h"
#import "CCBSequenceProperty.h"
#import "CCEffect_Private.h"

#define playerIdKey @"PlayerId"
#define randomNumberKey @"randomNumber"

typedef NS_ENUM(NSUInteger, GameState) {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
};

typedef NS_ENUM(NSUInteger, MessageType) {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    kMessageTypeAddBlock,
    kMessageTypeGameOver,
    kMessageTypeDeleteBlock,
    kMessageTypeMoveBlock,
    kMessageTypeSpellAdd,
    kMessageTypeUpdateInventory
};

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
    uint32_t blockX;
    uint32_t blockY;
    uint16_t blockType;
    uint16_t spell;
    uint32_t target;
} MessageAddBlock;

typedef struct {
    Message message;
    uint32_t blockX;
    uint32_t blockY;
    uint32_t target;
} MessageDeleteBlock;

typedef struct {
    Message message;
    uint32_t blockX;
    uint32_t blockY;
    uint32_t target;
    int32_t spell;
} MessageAddSpell;

typedef struct {
    Message message;
    uint32_t target;
    int32_t spell;
} MessageUpdateInventory;

typedef struct {
    Message message;
    uint32_t blockX;
    uint32_t blockY;
    uint32_t target;
    int32_t step;
} MessageMoveBlock;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

@implementation MultiplayerNetworking {
    uint32_t _ourRandomNumber;
    GameState _gameState;
    BOOL _isPlayer1, _receivedAllRandomNumbers;
    NSMutableArray *_orderOfPlayers;
}

- (id)init
{
    if (self = [super init]) {
        _ourRandomNumber = arc4random();
        _gameState = kGameStateWaitingForMatch;
        _orderOfPlayers = [NSMutableArray array];
        [_orderOfPlayers addObject:@{playerIdKey : [GKLocalPlayer localPlayer].playerID,
                randomNumberKey : @(_ourRandomNumber)}];
    }
    return self;
}

- (void)sendData:(NSData*)data
{
    NSError *error;
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];

    BOOL success = [gameKitHelper.match
            sendDataToAllPlayers:data
                    withDataMode:GKMatchSendDataReliable
                           error:&error];

    if (!success) {
        NSLog(@"Error sending data:%@", error.localizedDescription);
        [self matchEnded];
    }

}

- (void)sendUpdateInventory:(spellsType)type targetId:(NSUInteger)id {
    MessageUpdateInventory messageUpdateInventory;
    messageUpdateInventory.message.messageType = kMessageTypeUpdateInventory;
    messageUpdateInventory.spell = type;
    messageUpdateInventory.target = id;

    NSData *data = [NSData dataWithBytes:&messageUpdateInventory length:sizeof(MessageUpdateInventory)];

    [self sendData:data];

}

- (void)sendAddSpell:(Block *)block targetId:(NSUInteger)id {
    MessageAddSpell messageAddSpell;
    messageAddSpell.message.messageType = kMessageTypeSpellAdd;
    messageAddSpell.blockX = block.boardX;
    messageAddSpell.blockY = block.boardY;
    if(block.spell == nil){
        messageAddSpell.spell = -1;
    } else
    {
        messageAddSpell.spell = block.spell.spellType;
    }

    messageAddSpell.target = id;

    NSData *data = [NSData dataWithBytes:&messageAddSpell length:sizeof(MessageAddSpell)];

    [self sendData:data];

}

- (void)sendAdd:(Block *)block target:(NSUInteger)target {
    MessageAddBlock messageAdd;
    messageAdd.message.messageType = kMessageTypeAddBlock;
    messageAdd.blockX = block.boardX;
    messageAdd.blockY = block.boardY;
    messageAdd.blockType = block.type;


    messageAdd.spell = [(id <ICastable>)block.spell spellType];

    messageAdd.target = target;
    NSData *data = [NSData dataWithBytes:&messageAdd length:sizeof(MessageAddBlock)];

    [self sendData:data];

}

- (void)sendDelete:(Block *)block targetId:(NSUInteger)id1 {
    MessageDeleteBlock messageDeleteBlock;
    messageDeleteBlock.message.messageType = kMessageTypeDeleteBlock;
    messageDeleteBlock.blockX = block.boardX;
    messageDeleteBlock.blockY = block.boardY;
    messageDeleteBlock.target = id1;

    NSData *data = [NSData dataWithBytes:&messageDeleteBlock length:sizeof(messageDeleteBlock)];

    [self sendData:data];
}
- (void)sendMove:(CGPoint)key by:(NSInteger)by targetId:(NSUInteger)id {

    MessageMoveBlock messageMoveBlock;
    messageMoveBlock.message.messageType = kMessageTypeMoveBlock;
    messageMoveBlock.blockX = (uint32_t) key.x;
    messageMoveBlock.blockY = (uint32_t) key.y;
    messageMoveBlock.step = by;
    messageMoveBlock.target = id;

    NSData *data = [NSData dataWithBytes:&messageMoveBlock length:sizeof(messageMoveBlock)];

    [self sendData:data];
}

- (void)sendRandomNumber
{
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = _ourRandomNumber;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

- (void)sendGameBegin {

    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    [self sendData:data];

}

- (void)sendGameEnd:(BOOL)player1Won {
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    message.player1Won = player1Won;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
    [self sendData:data];
}

- (NSUInteger)indexForLocalPlayer
{
    NSString *playerId = [GKLocalPlayer localPlayer].playerID;

    return [self indexForPlayerWithId:playerId];
}

- (NSUInteger)indexForPlayerWithId:(NSString*)playerId
{
    __block NSUInteger index = -1;
    [_orderOfPlayers enumerateObjectsUsingBlock:^(NSDictionary
    *obj, NSUInteger idx, BOOL *stop){
        NSString *pId = obj[playerIdKey];
        if ([pId isEqualToString:playerId]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (void)tryStartGame
{
    if (_isPlayer1 && _gameState == kGameStateWaitingForStart) {
        _gameState = kGameStateActive;
        [self sendGameBegin];

        //first player
        [self.delegate setCurrentPlayerIndex:0];
        [self processPlayerAliases];
    }
}

- (BOOL)allRandomNumbersAreReceived
{
    NSMutableArray *receivedRandomNumbers =
            [NSMutableArray array];

    for (NSDictionary *dict in _orderOfPlayers) {
        [receivedRandomNumbers addObject:dict[randomNumberKey]];
    }

    NSArray *arrayOfUniqueRandomNumbers = [[NSSet setWithArray:receivedRandomNumbers] allObjects];

    return arrayOfUniqueRandomNumbers.count ==
        [GameKitHelper sharedGameKitHelper].match.players.count + 1;
}

-(void)processReceivedRandomNumber:(NSDictionary*)randomNumberDetails {
    //1
    if([_orderOfPlayers containsObject:randomNumberDetails]) {
        [_orderOfPlayers removeObjectAtIndex:
                [_orderOfPlayers indexOfObject:randomNumberDetails]];
    }
    //2
    [_orderOfPlayers addObject:randomNumberDetails];

    //3
    NSSortDescriptor *sortByRandomNumber =
            [NSSortDescriptor sortDescriptorWithKey:randomNumberKey
                                          ascending:NO];
    NSArray *sortDescriptors = @[sortByRandomNumber];
    [_orderOfPlayers sortUsingDescriptors:sortDescriptors];

    //4
    if ([self allRandomNumbersAreReceived]) {
        _receivedAllRandomNumbers = YES;
    }
}

- (void)processPlayerAliases {
    if ([self allRandomNumbersAreReceived]) {
        NSMutableArray *playerAliases = [NSMutableArray arrayWithCapacity:_orderOfPlayers.count];
        for (NSDictionary *playerDetails in _orderOfPlayers) {
            NSString *playerId = playerDetails[playerIdKey];
            [playerAliases addObject:((GKPlayer*)[GameKitHelper sharedGameKitHelper].playersDict[playerId]).alias];
        }
        if (playerAliases.count > 0) {
            [self.delegate setPlayerAliases:playerAliases];
        }
    }
}

- (BOOL)isLocalPlayerPlayer1
{
    NSDictionary *dictionary = _orderOfPlayers[0];
    return [dictionary[playerIdKey]
        isEqualToString:[GKLocalPlayer localPlayer].playerID];
    //    if ([dictionary[playerIdKey]
//            isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
//        NSLog(@"I'm player 1");
//        return YES;
//    }
//    return NO;
}

#pragma mark GameKitHelper delegate methods

- (void)matchStarted {
    NSLog(@"Match has started successfully");
    if (_receivedAllRandomNumbers) {
        _gameState = kGameStateWaitingForStart;
    } else {
        _gameState = kGameStateWaitingForRandomNumber;
    }
    [self sendRandomNumber];
    [self tryStartGame];
}

- (void)matchEnded {
    NSLog(@"Match has ended");
    [_delegate matchEnded];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data
   fromPlayer:(NSString *)playerID {
    //1
    Message *message = (Message*)[data bytes];
    if (message->messageType == kMessageTypeRandomNumber) {
        MessageRandomNumber *messageRandomNumber = (MessageRandomNumber*)[data bytes];

        NSLog(@"Received random number:%d", messageRandomNumber->randomNumber);

        BOOL tie = NO;
        if (messageRandomNumber->randomNumber == _ourRandomNumber) {
            //2
            NSLog(@"Tie");
            tie = YES;
            _ourRandomNumber = arc4random();
            [self sendRandomNumber];
        }
        else {
            NSDictionary *dictionary = @{playerIdKey : playerID,
                    randomNumberKey : @(messageRandomNumber->randomNumber)};
            [self processReceivedRandomNumber:dictionary];
        }

        if (_receivedAllRandomNumbers) {
            _isPlayer1 = [self isLocalPlayerPlayer1];

        }

        if (!tie && _receivedAllRandomNumbers) {
            if (_gameState == kGameStateWaitingForRandomNumber) {
                _gameState = kGameStateWaitingForStart;
            }
            [self tryStartGame];
        }
    } else if (message->messageType == kMessageTypeGameBegin) {
        NSLog(@"Begin game message received");
        NSLog(@"===========================");
        _gameState = kGameStateActive;
        [self.delegate setCurrentPlayerIndex:[self indexForLocalPlayer]];
        [self processPlayerAliases];

    } else if (message->messageType == kMessageTypeAddBlock) {

        MessageAddBlock *messageAdd = (MessageAddBlock *)[data bytes];
        [self.delegate addFromPlayerAtIndex:[self indexForPlayerWithId:playerID]
                                     BlockX:messageAdd->blockX
                                     BlockY:messageAdd->blockY
                                  BlockType:messageAdd->blockType
                                      Spell:messageAdd->spell
                                     Target:messageAdd->target];

    } else if (message->messageType == kMessageTypeDeleteBlock) {

        MessageDeleteBlock *messageDeleteBlock = (MessageDeleteBlock *) [data bytes];
        [self.delegate deleteBlock:[self indexForPlayerWithId:playerID]
                                 X:messageDeleteBlock->blockX
                                 Y:messageDeleteBlock->blockY
                            target:messageDeleteBlock->target];

    } else if (message->messageType == kMessageTypeMoveBlock) {

        MessageMoveBlock *messageMoveBlock = (MessageMoveBlock *) [data bytes];
        [self.delegate moveBlock:[self indexForPlayerWithId:playerID]
                               X:messageMoveBlock->blockX
                               Y:messageMoveBlock->blockY
                          target:messageMoveBlock->target
                            step:messageMoveBlock->step];

    } else if (message->messageType == kMessageTypeSpellAdd) {

        MessageAddSpell *messageAddSpell = (MessageAddSpell *) [data bytes];
        [self.delegate addSpell:[self indexForPlayerWithId:playerID]
                               X:messageAddSpell->blockX
                               Y:messageAddSpell->blockY
                          target:messageAddSpell->target
                            spell:messageAddSpell->spell];

    } else if (message->messageType == kMessageTypeUpdateInventory) {

        MessageUpdateInventory *messageUpdateInventory = (MessageUpdateInventory *) [data bytes];
        [self.delegate updateInventory:[self indexForPlayerWithId:playerID]
                         target:messageUpdateInventory->target
                          spell:messageUpdateInventory->spell];


    } else if(message->messageType == kMessageTypeGameOver) {
        NSLog(@"Game over message received");
        MessageGameOver * messageGameOver = (MessageGameOver *) [data bytes];
        [self.delegate gameOver:[self indexForPlayerWithId:playerID]
                         didWin:messageGameOver->player1Won];
    }
}



@end

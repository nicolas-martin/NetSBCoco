//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Field.h"
#import "FieldCollisionHelper.h"
#import "Board.h"
#import "Block.h"
#import "SpellFactory.h"

@implementation MainScene {
    CCNode *_scene;
    Field *_p1;
    Field *_p2;
    Field *_p3;
    NSMutableArray *bg;
    NSMutableArray *_players;
    NSUInteger _currentPlayerIndex;
    NSMutableArray *_playersOut;
}

- (id)init {
    if (self = [super init]) {
        self.userInteractionEnabled = TRUE;
        bg = [@[@"Gold", @"Orange", @"Purple", @"Silver", @"Teal"] mutableCopy];
        _players = [[NSMutableArray alloc] init];
        _playersOut = [[NSMutableArray alloc]init];

        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];


    }

    return self;
}

- (CCSprite *) getRandomBackground{

    NSUInteger random = 0;
    NSString *key = nil;

    while(key == nil){
        random = arc4random() % (bg.count - 1);
        key = bg[random];
    }

    CCSprite *bgSprite = (CCSprite *) [CCBReader load:[NSString stringWithFormat:@"Background/%@",key]];

    [bg removeObjectAtIndex:random];

    return bgSprite;

}

- (void)didLoadFromCCB {

    [_players addObject:_p1];
    [_players addObject:_p2];
    [_players addObject:_p3];

    [_p1.board addChild:self.getRandomBackground];
    [_p2.board addChild:self.getRandomBackground];
    [_p3.board addChild:self.getRandomBackground];


    FieldCollisionHelper *fch = [FieldCollisionHelper sharedMySingleton];
    [fch AddFieldBox:_p1];
    [fch AddFieldBox:_p2];
    [fch AddFieldBox:_p3];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BlocksToAdd:) name:BlocksToAdd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BlocksToDelete:) name:BlocksToDelete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BlocksToMove:) name:BlocksToMove object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SpellsToAdd:) name:SpellsToAdd object:nil];

}

- (void)SpellsToAdd:(NSNotification *)notification {
    NSMutableDictionary * blocks = [[notification userInfo] valueForKey:@"Blocks"];
    NSUInteger targetId = [[[notification userInfo] valueForKey:@"Target"] unsignedIntegerValue];

    for (Block *block in blocks){
        [_networkingEngine sendAddSpell:block targetId:targetId];
    }
}

- (void)BlocksToMove:(NSNotification *)notification {
    NSMutableDictionary * dictionary = [[notification userInfo] valueForKey:@"Blocks"];
    NSUInteger targetId = [[[notification userInfo] valueForKey:@"Target"] unsignedIntegerValue];

    for (NSString* key in dictionary) {
        NSInteger value = [dictionary[key] integerValue];
        [_networkingEngine sendMove:CGPointFromString(key) by:value targetId:targetId];
    }

}

- (void)BlocksToDelete:(NSNotification *)notification {
    NSMutableArray * array = [[notification userInfo] valueForKey:@"Blocks"];
    NSUInteger targetId = [[[notification userInfo] valueForKey:@"Target"] unsignedIntegerValue];

    for (Block *block in array){
        [_networkingEngine sendDelete:block targetId:targetId];
    }

}

- (void)BlocksToAdd:(NSNotification *)notification {
    NSMutableArray * blocks = [[notification userInfo] valueForKey:@"Blocks"];
    NSUInteger target = [[[notification userInfo] valueForKey:@"Target"] unsignedIntegerValue];

    for (Block *block in blocks){
        [_networkingEngine sendAdd:block target:target];
    }

}

- (void)onEnter {

    [super onEnter];

}

- (void)update:(CFTimeInterval)currentTime {
    if (self.paused && _currentPlayerIndex == -1) {
        return;
    }

    self.lastSpawnTimeInterval += currentTime;
    if (self.lastSpawnTimeInterval > 0.5) {
        self.lastSpawnTimeInterval = 0;

        NSMutableArray *playersOut = [NSMutableArray array];

        [_players enumerateObjectsUsingBlock:^(Field *field, NSUInteger idx, BOOL *stop){

            if (idx == _currentPlayerIndex && !*stop){

                *stop = [field updateStatus];

                if(*stop){
                    NSLog(@"Lost %d", idx);
                    [_networkingEngine sendGameEnd:NO];
                    [playersOut addObject:@(idx)];
                    _currentPlayerIndex = -1;
                }


            }else if (_players.count - 1 == _playersOut.count) {
                [_networkingEngine sendGameEnd:YES];
                NSLog(@"Win %d", idx);
                *stop = YES;
                _currentPlayerIndex = -1;

            }else{
                [field deleteRowAddSpellAndUpdateScore];

            }

        }];

    }
}

- (void)matchEnded {

}

- (void)setCurrentPlayerIndex:(NSUInteger)index {
    _currentPlayerIndex = index;

    //TODO: Put in it's own delegate method
    [[CCDirector sharedDirector] replaceScene:self];

}

- (void)addFromPlayerAtIndex:(NSUInteger)index BlockX:(uint32_t)x BlockY:(uint32_t)y BlockType:(uint16_t)type Spell:(uint16_t)spell Target:(uint32_t)target{

    Board * targetBoard = [(Field *)_players[target] board];
    NSMutableArray *blocks = [NSMutableArray array];
    [blocks addObject:[Block Create:x boardY:y spell:(spellsType)spell type:(blockType)type]];
    [targetBoard addBlocks:blocks];

}

- (void)deleteBlock:(NSUInteger)id1 X:(uint32_t)x Y:(uint32_t)y target:(uint32_t)target {
    Board * board = [(Field *)_players[target] board];
    [board removeBlockAtPosition:ccp(x,y)];
}

- (void)addSpell:(NSUInteger)id1 X:(uint32_t)x Y:(uint32_t)y target:(uint32_t)target spell:(int32_t)spell {
    Board * board = [(Field *)_players[target] board];

    if (spell == -1){
        Block *block =  [board getBlockAt:ccp(x, y)];
        [block removeSpell];

    }else{
        Block * block = [board getBlockAt:ccp(x, y)];
        [block addSpellToBlock:[SpellFactory getSpellFromType:(spellsType)spell]];

    }

}

- (void)moveBlock:(NSUInteger)id1 X:(uint32_t)x Y:(uint32_t)y target:(uint32_t)target step:(int32_t)step {
    Board * board = [(Field *)_players[target] board];
    NSMutableArray *blockToSet = [NSMutableArray array];

    if (step == -1){


        for (NSUInteger xx = 0; xx < Nbx; xx++){
            [board moveColumnUp:xx];
        }

    }
    else
    {

        [board MoveBlock:[board getBlockAt:ccp(x, y)] to:ccp(0, step)];
        [blockToSet addObject:[board getBlockAt:ccp(x, y+step)]];
        [board setPositionUsingFieldValue:blockToSet];

    }

}

- (void)gameOver:(BOOL)player1Won {
    BOOL didLocalPlayerWin = YES;
    if (player1Won) {
        didLocalPlayerWin = NO;
    }
//    if (self.gameOverBlock) {
//        self.gameOverBlock(didLocalPlayerWin);
//    }

}

- (void)setPlayerAliases:(NSArray *)playerAliases {
    [playerAliases enumerateObjectsUsingBlock:^(NSString *playerAlias, NSUInteger idx, BOOL *stop) {
        [(Field *)_players[idx] setName:playerAlias andId:idx];

    }];
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {

    if (_currentPlayerIndex == -1) {
        return;
    }

    Field *p1Field = (Field *)_players[_currentPlayerIndex];
    [[p1Field board] touchMoved:touch];

}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {

    if (_currentPlayerIndex == -1) {
        return;
    }

    Field *p1Field = (Field *)_players[_currentPlayerIndex];
    [[p1Field board] touchBegan:touch];


}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {

    if (_currentPlayerIndex == -1) {
        return;
    }

    Field *p1Field = (Field *)_players[_currentPlayerIndex];
    [[p1Field board] touchEnded:touch];

}

@end

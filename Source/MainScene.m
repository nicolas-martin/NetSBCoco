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
#import "CCControl.h"

//Had to use node point size instead of 100% for the touch to work..
//Might give trouble on other devices.
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
    [fch AddFieldBox:_p1.board];
    [fch AddFieldBox:_p2.board];
    [fch AddFieldBox:_p3.board];
}

- (void)onEnter {

    [super onEnter];

}

//TODO: Levels speed for each players
-(void)update:(CFTimeInterval)currentTime {
    if (self.paused && _currentPlayerIndex == -1) {
        return;
    }

    self.lastSpawnTimeInterval += currentTime;
    if (self.lastSpawnTimeInterval > 0.3) {
        self.lastSpawnTimeInterval = 0;


        Field *curr = (Field *)_players[_currentPlayerIndex];
        BOOL isGameOver = curr.updateStatus;
        if (!isGameOver)
        {
            for (Block *block in curr.board.getAllBlocksInBoard)
            {
                [_networkingEngine sendMove:block];
            }
            
            [_players enumerateObjectsUsingBlock:^(Field *field, NSUInteger idx, BOOL *stop){
                if (idx != _currentPlayerIndex){

                    NSMutableArray *rowsToDelete = field.board.checkForRowsToClear;

                    if (rowsToDelete.count > 0){
                        [field.board deleteRowsAndReturnSpells:rowsToDelete];

                    }
                }

            }];

        };

        ////Only Player 1 will check for game over condition
//        if (_currentPlayerIndex == 0) {
//            [_players enumerateObjectsUsingBlock:^(Field *field, NSUInteger idx, BOOL *stop) {
//
//                //Skip the players who are already dead.
//                if([_playersOut containsObject:field]){
//                    return;
//                }
//
//
//                if(!isGameOver) {
//
//                    if (_players.count - 1 == _playersOut.count)
//                    {
//                        [_networkingEngine sendGameEnd:YES];
//                        NSLog(@"Win %d", idx);
//                        *stop = YES;
//                        _currentPlayerIndex = -1;
//                    }
//
//                    if (idx == _currentPlayerIndex) {
//                        //TODO: Use this to figure out if the human lost or if it's someone else
//                        //Do something special
//                    }
//
////                if (self.gameOverBlock) {
////                    self.gameOverBlock(didWin);
////                }
//
//
//
//                }
//                else{
//
//                    [_playersOut addObject:field];
//                    NSLog(@"Lost %d", idx);
//
//                    *stop = YES;
//                    [_networkingEngine sendGameEnd:NO];
//
//                }
//
//
//            }];
//        }
    }
}


#pragma mark MultiplayerNetworkingProtocol

- (void)matchEnded {

}

- (void)setCurrentPlayerIndex:(NSUInteger)index {
    _currentPlayerIndex = index;

    //TODO: Put in it's own delegate method
    [[CCDirector sharedDirector] replaceScene:self];

}

//HACK: This is clearly not the most optimal way to do it. But it's easy..
- (void)moveFromPlayerAtIndex:(NSUInteger)index BlockX:(uint32_t)x BlockY:(uint32_t)y BlockType:(uint16_t)type Spell:(uint16_t)spell {

    Board * targetBoard = [(Field *)_players[index] board];
    NSMutableArray *blocks = [NSMutableArray array];
    [blocks addObject:[Block Create:x boardY:y spell:(spellsType)spell type:(blockType)type]];
    [targetBoard addBlocks:blocks];

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

//FIXME: Not working
- (void)setPlayerAliases:(NSArray *)playerAliases {
    [playerAliases enumerateObjectsUsingBlock:^(NSString *playerAlias, NSUInteger idx, BOOL *stop) {
        [(Field *)_players[idx] setName:playerAlias];
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

//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainScene.h"
#import "Field.h"
#import "FieldCollisionHelper.h"
#import "Board.h"

//TODO: Maybe move the board touch handling here?

@implementation MainScene {
    CCNode *_scene;
    Field *_p1;
    Field *_p2;
    Field *_p3;
    NSMutableArray *bg;
    NSMutableArray *_players;
    NSUInteger _currentPlayerIndex;
}
- (id)init {
    if (self = [super init]) {
        self.userInteractionEnabled = TRUE;
        bg = [@[@"Gold", @"Orange", @"Purple", @"Silver", @"Teal"] mutableCopy];

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

    //TODO: Levels speed for each players
    //[self schedule:@selector(gameLoop) interval:1];

    [super onEnter];

}


-(void)update:(CFTimeInterval)currentTime {
    if (self.paused && _currentPlayerIndex == -1) {
        return;
    }

    NSMutableArray *playersOut;

    //Only Player 1 will check for game over condition
    if (_currentPlayerIndex == 0) {
        [_players enumerateObjectsUsingBlock:^(Field *field, NSUInteger idx, BOOL *stop) {

            //Skip the players who are already dead.
            if([playersOut containsObject:field]){
                return;
            }

            if(field.updateStatus) {

                if (_players.count == playersOut.count - 1)
                {
                    [_networkingEngine sendGameEnd:YES];
                }

                if (idx == _currentPlayerIndex) {
                    //TODO: Use this to figure out if the human lost or if it's someone else
                    //Do something special
                }

//                if (self.gameOverBlock) {
//                    self.gameOverBlock(didWin);
//                }
            }
            else{

                [playersOut addObject:field];
                NSLog(@"Lost");
                _currentPlayerIndex = -1;
                *stop = YES;
                [_networkingEngine sendGameEnd:NO];

            }


        }];
    }
}

//
//- (void)gameLoop {
//
//    if ([_p1 updateStatus]) {
//
//        //Bug with cocos2d.. will be fixed in 3.1
//        //[self unschedule:@selector(gameLoop)];
//        ([_p1 displayGameOver]);
//
//    }
//
//    //[_players[_currentPlayerIndex] moveForward];
//    [_networkingEngine sendMove:_p1];
//
//}

#pragma mark MultiplayerNetworkingProtocol

- (void)matchEnded {

}

- (void)setCurrentPlayerIndex:(NSUInteger)index {
    _currentPlayerIndex = index;

}

//TODO: Exact this metho and the SwitchBoard spell into one.
//HACK: This is clearly not the most optimal way to do it. But it's easy..
- (void)movePlayerAtIndex:(NSUInteger)index field:(Field *)field {

    NSMutableArray *targetBoardBlocks;
    NSMutableArray *playerBoardBlocks;
    Board * targetBoard = [(Field *)_players[index] board];

    if (targetBoard == field.board)
        return;
    playerBoardBlocks = field.board.getAllBlocksInBoard;
    targetBoardBlocks = targetBoard.getAllBlocksInBoard;

    [field.board DeleteBlockFromBoardAndSprite:playerBoardBlocks];
    [targetBoard DeleteBlockFromBoardAndSprite:targetBoardBlocks];

    [field.board addBlocks:targetBoardBlocks];
    [targetBoard addBlocks:playerBoardBlocks];

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
        [(Field *)_players[idx] setName:playerAlias];
    }];
}


@end

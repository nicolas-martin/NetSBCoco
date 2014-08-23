//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Field.h"
#import "Tetromino.h"
#import "FieldCollisionHelper.h"
#import "Board.h"
#import "CCNode_Private.h"

@implementation MainScene {
    CCNode *_scene;
    Field *_p1;
    Field *_p2;
    Field *_p3;
}
- (id)init {
    if (self = [super init]) {
        // activate touches on this scene
        self.userInteractionEnabled = TRUE;

    }
    return self;
}

- (void)didLoadFromCCB {

    _p1.board.Name = @"Player1";
    _p2.board.Name = @"Player2";
    _p3.board.Name = @"Player3";

    FieldCollisionHelper *fch = [FieldCollisionHelper sharedMySingleton];
    [fch AddFieldBox:_p1.board];
    [fch AddFieldBox:_p2.board];
    [fch AddFieldBox:_p3.board];

}

- (void)onEnter {
    //[self schedule:@selector(gameLoop) interval:1];
    [self gameLoop];
//    [super onEnter];

}

- (void)gameLoop {

    for (int i =0; i < 5; i++) {

        if ([_p1 updateStatus]) {

            //Bug with cocos2d.. will be fixed in 3.1
            //[self unschedule:@selector(gameLoop)];
            ([_p1 displayGameOver]);

        }
    }

}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
}

@end

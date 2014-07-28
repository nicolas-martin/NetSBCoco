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

@implementation MainScene{
    CCNode *_scene;
    Field *_p1;
    Field *_p2;
    Field *_p3;
}
- (id)init
{
    if (self = [super init])
    {
        // activate touches on this scene
        self.userInteractionEnabled = TRUE;
    }
    return self;
}
- (void)didLoadFromCCB {
    [FieldCollisionHelper AddFieldBox:_p1.board];
    [FieldCollisionHelper AddFieldBox:_p2.board];
    [FieldCollisionHelper AddFieldBox:_p3.board];


    // Use the gamescene as the collision delegate.
    // See the ccPhysicsCollision* methods below.
}



- (void)onEnter {
    [self schedule:@selector(gameLoop:) interval:1];
    [super onEnter];
}

- (void)gameLoop:(CCTime)delta {
    [_p1 moveDownOrCreate];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end

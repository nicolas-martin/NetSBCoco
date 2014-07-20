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

    //[_p1 createNewTetromino];
}

- (void)onEnter {
    [self schedule:@selector(scrollBackground:) interval:1];
}

- (void)scrollBackground:(CCTime)delta {
    [_p1 moveDownOrCreate];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end

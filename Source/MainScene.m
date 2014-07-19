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
#import "GameController.h"

@implementation MainScene{
    CCNode *_scene;
    Field *_p1;
    Field *_p2;
    Field *_p3;
}

- (void)didLoadFromCCB {
    GameController *gc1 = [GameController initWithField _p1];


}

@end

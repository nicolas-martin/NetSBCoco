//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene{
    CCNode *_scene;
    CCNode *_p1;
    CCNode *_p2;
    CCNode *_p3;
}

- (void)didLoadFromCCB {
    CCNode *square = [CCBReader load:@"Shapes/Square"];
    [_p1 addChild:square];

}

@end

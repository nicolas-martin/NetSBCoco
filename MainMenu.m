//
// Created by Nicolas Martin on 2014-09-07.
// Copyright (c) 2014 hero. All rights reserved.
//

#import "MainMenu.h"
#import "GameKitHelper.h"


@implementation MainMenu {

}

- (void)didLoadFromCCB {
    //[[GameCenterHelper sharedInstance] authenticateLocalPlayer];

}

- (void)play {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}
@end
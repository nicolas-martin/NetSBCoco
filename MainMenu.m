//
// Created by Nicolas Martin on 2014-09-07.
// Copyright (c) 2014 hero. All rights reserved.
//

#import "MainMenu.h"
#import "GameKitHelper.h"
#import "MultiplayerNetworking.h"
#import "MainScene.h"


@implementation MainMenu {
    MultiplayerNetworking *_networkingEngine;
}

- (void)didLoadFromCCB {
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAuthenticated) name:LocalPlayerIsAuthenticated object:nil];

}

- (void)playerAuthenticated{
    MainScene *mainScene = (MainScene *) [CCBReader loadAsScene:@"MainScene"];
    _networkingEngine = [[MultiplayerNetworking alloc]init];
    _networkingEngine.delegate = mainScene;
    mainScene.networkingEngine = _networkingEngine;

    [[GameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:2 viewController:nil delegate:_networkingEngine];

}

- (void)play {

//    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
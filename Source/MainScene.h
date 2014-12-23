//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "MultiplayerNetworking.h"

@interface MainScene : CCScene <MultiplayerNetworkingProtocol>
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine;
@property(nonatomic) CFTimeInterval lastSpawnTimeInterval;
@end

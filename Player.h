//
// Created by Nicolas Martin on 2014-08-30.
// Copyright (c) 2014 hero. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Player : NSObject

typedef enum {
    kPlayerDistant = 0,
    kPlayerLocal = 0
} PlayerType;

@property(nonatomic) int xp;
@property(nonatomic) PlayerType playerType;
@property(nonatomic, strong) NSObject *playerName;
@property(nonatomic, copy) NSString *playerId;
@property(nonatomic) int rating;



- (id)initWithPlayerId:(NSString *)id playerName:(NSString *)name rating:(int)rating;

- (void)setLevel:(int)level;
@end
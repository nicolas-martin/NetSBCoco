//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Board;
@class Tetromino;


@interface Field : CCNode

- (void)addSpellsToInventory:(NSMutableArray *)spellsToAdd;

- (void)moveDownOrCreate;

@end
//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Board;
@class Tetromino;


@interface Field : CCNode

@property Board *board;


- (void)displayGameOver;

- (void)addSpellsToInventory:(NSMutableArray *)spellsToAdd;

- (BOOL)updateStatus;

@end
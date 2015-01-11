//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCControl.h"

@class Board;
@class Tetromino;

extern NSString *const SpellsToAdd;

@interface Field : CCNode

@property Board *board;
@property(nonatomic) NSString *Name;
@property(nonatomic) NSUInteger Idx;

- (void)setName:(NSString *)Name andId:(NSUInteger)id1;

- (void)displayGameOver;

- (void)addSpellsToInventory:(NSMutableArray *)spellsToAdd;

- (BOOL)updateStatus;

- (NSUInteger)deleteRowAddSpellAndUpdateScore;
@end
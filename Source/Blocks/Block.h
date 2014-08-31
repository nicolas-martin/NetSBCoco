//
// Created by Nicolas Martin on 2014-07-19.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ICastable;


@interface Block : CCSprite
@property NSUInteger boardX;
@property NSUInteger boardY;
@property id <ICastable> spell;
@property BOOL stuck;
@property BOOL disappearing;
@property NSUInteger blockType;

+ (Block *)CreateRandomBlock;

- (void)addSpellToBlock:(id <ICastable>)spell;

- (void)removeSpell;

- (void)moveUp;

- (void)moveDown;

- (void)moveLeft;

- (void)moveRight;

- (void)moveByX:(NSUInteger)offsetX;

- (NSComparisonResult)compareWithBlock:(Block *)block;

- (void)MoveTo:(Block *)block;

- (NSString *)description;

@end
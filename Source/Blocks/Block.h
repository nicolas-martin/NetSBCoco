//
// Created by Nicolas Martin on 2014-07-19.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCControl.h"
#import "ICastable.h"

@protocol ICastable;

typedef enum {
    Blue = 0,
    Cyan = 1,
    Green = 2,
    Magenta = 3,
    Orange = 4,
    Red = 5,
    Yellow = 6
} blockType;


@interface Block : CCSprite
@property NSUInteger boardX;
@property NSUInteger boardY;
@property id <ICastable> spell;
@property BOOL stuck;
@property blockType type;

- (instancetype)initWithBoardX:(NSUInteger)boardX boardY:(NSUInteger)boardY spell:(spellsType)spell type:(blockType)type;

+ (instancetype)blockWithBoardX:(NSUInteger)boardX boardY:(NSUInteger)boardY spell:(enum spellsType)spell type:(blockType)type;


+ (Block *)CreateRandomBlock;

+ (Block *)CreateRandomBlockWithPosition:(CGPoint)blockPosition;

- (void)addSpellToBlock:(id <ICastable>)spell;

- (void)removeSpell;

- (void)moveUp;

- (void)moveDown;

- (void)moveLeft;

- (void)moveRight;

- (void)moveByX:(NSUInteger)offsetX;

- (void)MoveTo:(Block *)block;

@end
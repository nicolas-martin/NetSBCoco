//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Board;
@class Field;

@protocol ICastable <NSObject>

@property NSString *spellName;

@property CCSpriteFrame *spriteFrame;

- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField;

//TODO: Could be taken out and logged by the inventory instead.
- (NSString *)LogSpell:(Board *)targetBoard;

@end
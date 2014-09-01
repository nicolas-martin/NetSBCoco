//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Board;
@class Field;

typedef enum spellsType{
    kAddLine = 0,
    kClearSpecial = 1,
    kGravity = 2,
    kNuke = 3,
    kRandomRemove = 4,
    kSwitchBoard = 5,
} spellsType;


@protocol ICastable <NSObject>

@property NSString *spellName;
@property spellsType spellType;

@property CCSpriteFrame *spriteFrame;

- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField;

@end
//
// Created by Nicolas Martin on 2014-08-30.
// Copyright (c) 2014 hero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICastable.h"

@protocol ICastable;
@class Board;
@class Field;


@interface SwitchBoard : CCNode <ICastable>

@property spellsType spellType;
@property CCSpriteFrame *spriteFrame;
@property NSString *spellName;

- (NSString *)LogSpell:(Board *)targetBoard;

- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField;

@end

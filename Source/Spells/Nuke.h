//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Board;
@class Field;


@interface Nuke : CCNode <ICastable>


@property CCSpriteFrame *spriteFrame;
@property spellsType spellType;
@property NSString *spellName;

- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField;
@end
//
// Created by Nicolas Martin on 2014-08-31.
// Copyright (c) 2014 hero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Board;


@interface ClearSpecial : CCNode <ICastable>


@property CCSpriteFrame *spriteFrame;
@property spellsType spellType;
@property NSString *spellName;

- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField;

- (NSString *)LogSpell:(Board *)targetBoard;
@end
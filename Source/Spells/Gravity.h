//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Board;
@class Field;


@interface Gravity : CCNode <ICastable>


@property CCSpriteFrame *spriteFrame;

- (id)init;

- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField;

- (NSString *)LogSpell:(Board *)targetBoard;
@end
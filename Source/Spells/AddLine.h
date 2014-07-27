//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Field;
@class Board;


@interface AddLine : NSObject <ICastable>


@property CCSpriteFrame *spriteFrame;

- (void)CastSpell:(Board *)targetBoard;

- (NSString *)LogSpell:(Board *)targetBoard;
@end
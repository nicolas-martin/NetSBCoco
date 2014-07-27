//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Field;
@class Board;


@interface RandomRemove : NSObject <ICastable>


@property CCSpriteFrame *spriteFrame;

- (NSString *)LogSpell:(Board *)targetBoard;

- (void)CastSpell:(Board *)targetBoard;
@end
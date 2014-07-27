//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Board;


@interface Gravity : NSObject <ICastable>


@property CCSpriteFrame *spriteFrame;

- (id)init;

- (void)CastSpell:(Board *)targetBoard;

- (NSString *)LogSpell:(Board *)targetBoard;
@end
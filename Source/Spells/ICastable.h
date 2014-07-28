//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Board;

@protocol ICastable <NSObject>

@property NSString *spellName;

@property CCSpriteFrame *spriteFrame;

- (void)CastSpell:(Board *)targetBoard;
- (NSString *)LogSpell:(Board *)targetBoard;

@end
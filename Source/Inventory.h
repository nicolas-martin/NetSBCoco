//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ICastable;

extern NSString *const SpellCasted;

@interface Inventory : CCNode

@property NSUInteger MaxNbSpells;
- (void)addSpell:(<ICastable>)spell;
- (void)removeSpell:(<ICastable>)spell;
@end
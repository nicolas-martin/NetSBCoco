//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ICastable;


@interface Inventory : CCNode
- (void)addSpell:(<ICastable>)spell;

- (void)removeSpell:(<ICastable>)spell;
@end
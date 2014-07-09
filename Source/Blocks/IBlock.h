//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ICastable;

@protocol IBlock <NSObject>
@property NSUInteger boardX;
@property NSUInteger boardY;
@property id <ICastable> spell;
@property BOOL stuck;
- (void)addSpellToBlock:(<ICastable>) spell;
- (NSString *)description;
@end
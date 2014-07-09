//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Field;

@protocol ICastable <NSObject>

@property NSString *spellName;
@property NSString *spriteFileName;

- (void)CastSpell:(Field *)targetField;
- (NSString *)LogSpell:(Field *)targetField;

@end
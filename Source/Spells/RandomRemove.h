//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICastable.h"

@class Field;


@interface RandomRemove : NSObject <ICastable>

- (void)CastSpell:(Field *)targetField;
- (NSString *)LogSpell:(Field *)targetField;

@end
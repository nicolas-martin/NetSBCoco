//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICastable.h"


@interface Nuke : NSObject <ICastable>

- (NSString *)LogSpell:(Field *)targetField;
- (void)CastSpell:(Field *)targetField;

@end
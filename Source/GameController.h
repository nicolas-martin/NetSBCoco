//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Field;


@interface GameController : NSObject {

}
- (instancetype)initWithField:(Field *)field;

+ (instancetype)controllerWithField:(Field *)field;


@end
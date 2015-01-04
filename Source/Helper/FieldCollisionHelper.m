//
// Created by Nicolas Martin on 2014-07-27.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "FieldCollisionHelper.h"
#import "Board.h"
#import "Field.h"

NSMutableArray *fieldsArray;
static FieldCollisionHelper *_sharedMySingleton = nil;

@implementation FieldCollisionHelper {

}

+ (FieldCollisionHelper *)sharedMySingleton {
    if (_sharedMySingleton == nil) {
        _sharedMySingleton = (FieldCollisionHelper *) [[super allocWithZone:NULL] init];
    }
    return _sharedMySingleton;
}

- (id)init {
    self = [super init];
    if (self) {
        fieldsArray = [[NSMutableArray alloc] init];

    }

    return self;
}

- (void)AddFieldBox:(Field *)field {
    [fieldsArray addObject:field];
}

//TODO: Find a better way.. with collision detection.
- (Field *)GetFieldFromPosition:(CGPoint)point {
    Field *found = nil;
    for (Field *currentField in fieldsArray) {
        //[node.parent convertToWorldSpace:node.position]
        CGPoint absolutePosition = [currentField.board.parent convertToWorldSpace:currentField.board.position];
        CGRect rect = CGRectMake(absolutePosition.x, absolutePosition.y, currentField.board.contentSize.width, currentField.board.contentSize.height);
        if (CGRectContainsPoint(rect, point)) {
            found = currentField;
        }
    }

    return found;
}

@end
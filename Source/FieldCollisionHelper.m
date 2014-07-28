//
// Created by Nicolas Martin on 2014-07-27.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "FieldCollisionHelper.h"
#import "Field.h"
#import "Board.h"

NSMutableArray *fieldsArray;
static FieldCollisionHelper* _sharedMySingleton = nil;
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

- (void)AddFieldBox:(Board *)field {
    [fieldsArray addObject:field];
}

- (Board *)GetFieldFromPosition:(CGPoint)point {
    Board *found = nil;
    for(Board *currentField in fieldsArray){
        //[node.parent convertToWorldSpace:node.position]
        CGPoint absolutePosition = [currentField.parent convertToWorldSpace:currentField.position];
        CGRect rect = CGRectMake(absolutePosition.x, absolutePosition.y, currentField.contentSize.width, currentField.contentSize.height);
        if (CGRectContainsPoint(rect, point)) {
            found = currentField;
        }
    }

    return found;
}

@end
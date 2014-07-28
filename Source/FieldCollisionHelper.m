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

+(FieldCollisionHelper*)sharedMySingleton
{
    @synchronized([FieldCollisionHelper class])
    {
        if (!_sharedMySingleton)
            [[self alloc] init];

        return _sharedMySingleton;
    }

    return nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        fieldsArray = [[NSMutableArray alloc] init];

    }

    return self;
}


+ (void)AddFieldBox:(Board *)field {
    [fieldsArray addObject:field];
}

+ (Board *)GetFieldFromPosition:(CGPoint)point {
    Board *found = nil;
    for(Board *currentField in fieldsArray){
        if (CGRectContainsPoint(currentField.boundingBox, point)) {
            found = currentField;
        }
    }

    return found;
}

@end
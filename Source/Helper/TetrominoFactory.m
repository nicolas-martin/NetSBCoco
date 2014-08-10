//
// Created by Nicolas Martin on 2014-08-10.
// Copyright (c) 2014 hero. All rights reserved.
//

#import "TetrominoFactory.h"
#import "Tetromino.h"

static TetrominoFactory *_sharedMySingleton = nil;
@implementation TetrominoFactory {

}

+ (TetrominoFactory *)sharedMySingleton {
    if (_sharedMySingleton == nil) {
        _sharedMySingleton = (TetrominoFactory *) [[super allocWithZone:NULL] init];
    }
    return _sharedMySingleton;
}

- (id)init {
    self = [super init];
    if (self) {


    }

    return self;
}

+ (Tetromino *) getTetrominoUsingFrequency
{
    NSMutableDictionary *shapes = [NSMutableDictionary dictionary];
    [shapes setValue:@"T" forKey:@"0"];
    [shapes setValue:@"L" forKey:@"1"];
    [shapes setValue:@"J" forKey:@"2"];
    [shapes setValue:@"Z" forKey:@"3"];
    [shapes setValue:@"S" forKey:@"4"];
    [shapes setValue:@"O" forKey:@"5"];
    [shapes setValue:@"I" forKey:@"6"];

    Tetromino * tetromino = nil;

    NSUInteger random = arc4random() % 7;

    NSString *key = [shapes valueForKey:[NSString stringWithFormat:@"%d",random]];

    tetromino = (Tetromino *) [CCBReader load:[NSString stringWithFormat:@"Shapes/%@",key]];

    return tetromino;

}


@end
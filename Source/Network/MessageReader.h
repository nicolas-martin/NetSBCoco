//
//  MessageReader.h
//  TowerWars
//
//  Created by Henri Lapierre on 5/24/13.
//  Copyright (c) 2013 Henri Lapierre. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;

@interface MessageReader : NSObject {
    NSData * _data;
    int _offset;
}

- (id)initWithData:(NSData *)data;

- (unsigned char)readByte;
- (int)readInt;
- (NSString *)readString;
- (Player*)readPlayer;
- (void)readStatsForPlayer:(Player*)player;

@end

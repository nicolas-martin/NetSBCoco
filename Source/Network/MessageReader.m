//
//  MessageReader.m
//  TowerWars
//
//  Created by Henri Lapierre on 5/24/13.
//  Copyright (c) 2013 Henri Lapierre. All rights reserved.
//

#import "MessageReader.h"
#import "Player.h"

@implementation MessageReader

- (id)initWithData:(NSData *)data {
    if ((self = [super init])) {
        _data = data;
        _offset = 0;
    }
    return self;
}

- (unsigned char)readByte {
    unsigned char retval = *((unsigned char *) (_data.bytes + _offset));
    _offset += sizeof(unsigned char);
    return retval;
}

- (int)readInt {
    int retval = *((unsigned int *) (_data.bytes + _offset));
    retval = ntohl(retval);
    _offset += sizeof(unsigned int);
    return retval;
}

- (NSString *)readString {
    int strLen = [self readInt];
    NSString *retval = [NSString stringWithCString:_data.bytes+_offset encoding:NSUTF8StringEncoding];
    _offset += strLen;
    return retval;
}

- (Player*)readPlayer {
    NSString *playerId = [self readString];
    NSString *playerName = [self readString];
    int rating = [self readInt];
    int level = [self readInt];
    int xp = [self readInt];

    Player *player = [[Player alloc] initWithPlayerId:playerId playerName:playerName rating:rating];
    [player setLevel:level];
    [player setXp:xp];
    
    return player;
}

//- (void)readStatsForPlayer:(Player*)player {
//    [player setCreepHp:[self readInt]];
//    [player setCreepSpeed:[self readInt]];
//    [player setTowerDamage:[self readInt]];
//    [player setTowerRange:[self readInt]];
//    [player setTowerSpeed:[self readInt]];
//}

@end
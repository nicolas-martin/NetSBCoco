//
//  MessageWriter.h
//  TowerWars
//
//  Created by Henri Lapierre on 5/23/13.
//  Copyright (c) 2013 Henri Lapierre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageWriter : NSObject

@property (strong, readonly) NSMutableData * data;

- (void)writeByte:(unsigned char)value;
- (void)writeInt:(int)value;
- (void)writeString:(NSString *)value;

@end
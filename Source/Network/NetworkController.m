//
//  NetworkController.m
//  TowerWars
//
//  Created by Henri Lapierre on 5/21/13.
//  Copyright (c) 2013 Henri Lapierre. All rights reserved.
//

#import "NetworkController.h"
#import "MessageWriter.h"
#import "MessageReader.h"

#import "Match.h"
#import "Player.h"

@interface NetworkController ()
- (bool)writeChunk;
@end

typedef enum {
    MessagePlayerConnected = 0,
    MessageMatchStatus,
    MessageFindMatch,
    MessageMatchSearching,
    MessageMatchFound,
    MessageMatchReady,
    MessageMatchStarted,
    MessagePlayerInformation,
    MessageCreepSent,
    MessageTowerBuilt,
    MessageMatchOver = 10,
    MessageLadder
} MessageType;

@implementation NetworkController

#pragma mark - Helpers

static NetworkController *sharedController = nil;
+ (NetworkController *) sharedInstance {
    if (!sharedController) {
        sharedController = [[NetworkController alloc] init];
    }
    return sharedController;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (void)setState:(NetworkState)state {
    _state = state;
    //[self notifyStateChanged:_state];
}

- (void)dismissMatchmaker {
    //[_presentingViewController dismissModalViewControllerAnimated:YES];
    //self.mmvc = nil;
    self.presentingViewController = nil;
}


#pragma mark - Init

- (id)init {
    if ((self = [super init])) {
        [self setState:_state];
        _messageId = 1;
        _gameCenterAvailable = NO; //[self isGameCenterAvailable];
        _listObservers = [NSMutableArray arrayWithCapacity:2];
        if (_gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
        else {
            _alias = @"Legendery";
            _playerId = @"11111111";
        }
    }
    return self;
}

#pragma mark - Authentication

- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !_userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        [self setState:NetworkStateAuthenticated];
        _userAuthenticated = TRUE;
        [self connect]; 
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && _userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        _userAuthenticated = FALSE;
        [self setState:NetworkStateNotAvailable];
        [self disconnect];
    }
    
}

- (void)authenticateLocalUser {
    
    if (!_gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [self setState:NetworkStatePendingAuthentication];
        [[GKLocalPlayer localPlayer] authenticateHandler];
    } else {
        NSLog(@"Already authenticated!");
    }
}

#pragma mark - Server communication

- (void)connect {
    self.inputBuffer = [NSMutableData data];
    self.outputBuffer = [NSMutableData data];
    [self setState:NetworkStateConnectingToServer];
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 1955, &readStream, &writeStream);
    _inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    _outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    [_outputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
}

- (void)disconnect {
    
    [self setState:NetworkStateConnectingToServer];
    
    if (_inputStream != nil) {
        self.inputStream.delegate = nil;
        [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_inputStream close];
        self.inputStream = nil;
        self.inputBuffer = nil;
    }
    if (_outputStream != nil) {
        self.outputStream.delegate = nil;
        [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream close];
        self.outputStream = nil;
        self.outputBuffer = nil;
    }
}

- (void)reconnect {
    [self disconnect];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self connect];
    });
}

#pragma mark - Streams

- (void)inputStreamHandleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"Opened input stream");
            _inputOpened = YES;
            if (_inputOpened && _outputOpened && _state == NetworkStateConnectingToServer) {
                [self setState:NetworkStateConnected];
                [self sendPlayerConnected:true];
            }
        }
        case NSStreamEventHasBytesAvailable: {
            if ([_inputStream hasBytesAvailable]) {
                //NSLog(@"Input stream has bytes...");
                NSInteger       bytesRead;
                uint8_t         buffer[32768];
                
                bytesRead = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                if (bytesRead == -1) {
                    //NSLog(@"Network read error");
                } else if (bytesRead == 0) {
                    //NSLog(@"No data read, reconnecting");
                    [self reconnect];
                } else {
                    //NSLog(@"Read %d bytes", bytesRead);
                    [_inputBuffer appendData:[NSData dataWithBytes:buffer length:bytesRead]];
                    [self checkForMessages];
                }
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO); // should never happen for the input stream
        } break;
        case NSStreamEventErrorOccurred: {
            NSLog(@"Stream open error, reconnecting");
            [self reconnect];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (void)outputStreamHandleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            //NSLog(@"Opened output stream");
            _outputOpened = YES;
            if (_inputOpened && _outputOpened && _state == NetworkStateConnectingToServer) {
                [self setState:NetworkStateConnected];
                [self sendPlayerConnected:true];
            }
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            //NSLog(@"Ok to send");
            BOOL wroteChunk = [self writeChunk];
            if (!wroteChunk) {
                _okToWrite = TRUE;
            }
        } break;
        case NSStreamEventErrorOccurred: {
            //NSLog(@"Stream open error, reconnecting");
            [self reconnect];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (aStream == _inputStream) {
            [self inputStreamHandleEvent:eventCode];
        } else if (aStream == _outputStream) {
            [self outputStreamHandleEvent:eventCode];
        }
    });
}

#pragma mark - Message sending / receiving

- (void)sendData:(NSData *)data {
    
    if (_outputBuffer == nil) return;
    
    int dataLength = data.length;
    dataLength = htonl(dataLength);
    [_outputBuffer appendBytes:&dataLength length:sizeof(dataLength)];
    [_outputBuffer appendData:data];
    if (_okToWrite) {
        [self writeChunk];
        //NSLog(@"Wrote message");
    } else {
        //NSLog(@"Queued message");
    }
}

- (void)sendPlayerConnected:(BOOL)continueMatch {
    [self setState:NetworkStatePendingMatchStatus];
    
    MessageWriter * writer = [[MessageWriter alloc] init];
    [writer writeByte:MessagePlayerConnected];
    //[writer writeString:[GKLocalPlayer localPlayer].playerID];
    //[writer writeString:[GKLocalPlayer localPlayer].alias];
    [writer writeString:_playerId];
    [writer writeString:_alias];
    //[writer writeByte:continueMatch];
    [self sendData:writer.data];
    
    NSLog(@"Sent PLAYER_CONNECTED");
}

- (void)sendStartMatch:(NSArray *)players {
    [self setState:NetworkStatePendingMatchStart];
    
    MessageWriter * writer = [[MessageWriter alloc] init];
    [writer writeByte:MessageMatchStarted];
    [writer writeByte:players.count];
    for(NSString *playerId in players) {
        [writer writeString:playerId];
    }
    [self sendData:writer.data];
}

- (void)sendFindMatch {
    [self setState:NetworkStatePendingMatchStart];
    
    MessageWriter * writer = [[MessageWriter alloc] init];
    [writer writeByte:MessageFindMatch];
    [writer writeString:_playerId];
    [self sendData:writer.data];
    
    NSLog(@"Sent FIND_MATCH");
}

- (void)sendCreepSpawned:(int)creepType time:(double)time {
    MessageWriter* writer = [[MessageWriter alloc] init];
    [writer writeByte:MessageCreepSent];
    [writer writeString:_playerId];
    [writer writeInt:creepType];
    
    NSString* stringTime = [NSString stringWithFormat:@"%f", time];
    [writer writeInt:(int)(time*1000)];
    
    [self sendData:writer.data];
    
    NSLog(@"Sent CREEP_SPAWNED %d %@", creepType, stringTime);
}

- (void)sendTowerBuilt:(int)towerType position:(CGPoint)position time:(double)time {
    MessageWriter* writer = [[MessageWriter alloc] init];
    [writer writeByte:MessageTowerBuilt];
    [writer writeString:_playerId];
    [writer writeInt:towerType];
    [writer writeInt:(int)position.x];
    [writer writeInt:(int)position.y];
    
    NSString* stringTime = [NSString stringWithFormat:@"%f", time];
    [writer writeInt:(int)(time*1000)];

    [self sendData:writer.data];
    
    NSLog(@"Sent TOWER_BUILT %d [%d,%d] - %@", towerType, (int)position.x, (int)position.y, stringTime);
}

- (void)sendMatchOverWithWinner:(NSString*)winner {
    MessageWriter* writer = [[MessageWriter alloc] init];
    [writer writeByte:MessageMatchOver];
    [writer writeString:winner];
    [self sendData:writer.data];
}

- (void)sendGetLadder; {
    MessageWriter *writer = [[MessageWriter alloc] init];
    [writer writeByte:MessageLadder];
    [self sendData:writer.data];
}

- (bool)writeChunk {
    int amtToWrite = MIN((int)_outputBuffer.length, 1024);
    if (amtToWrite == 0) return FALSE;
    
    //NSLog(@"Amt to write: %d/%d", amtToWrite, _outputBuffer.length);
    
    int amtWritten = [self.outputStream write:_outputBuffer.bytes maxLength:amtToWrite];
    if (amtWritten < 0) {
        [self reconnect];
    }
    int amtRemaining = (int)_outputBuffer.length - amtWritten;
    if (amtRemaining == 0) {
        self.outputBuffer = [NSMutableData data];
    } else {
        //NSLog(@"Creating output buffer of length %d", amtRemaining);
        self.outputBuffer = [NSMutableData dataWithBytes:_outputBuffer.bytes+amtWritten length:amtRemaining];
    }
    //NSLog(@"Wrote %d bytes, %d remaining.", amtWritten, amtRemaining);
    _okToWrite = FALSE;
    return TRUE;
}

- (void)processMessage:(NSData *)data {
   // MessageReader * reader = [[MessageReader alloc] initWithData:data];
    
   // unsigned char msgType = [reader readByte];
    /*
    switch (msgType) {
        case MessageCreepSent:
        {
            int creepType = [reader readInt];
            double time = ((double)[reader readInt])/1000;
            //[_delegate opponentCreepSent:creepType time:time];
            [self notifyCreepSent:creepType time:time];
            break;
        }
        case MessageMatchSearching:
        {
            NSLog(@"Received MESSAGE_SEARCHING");
            int ratingMin = [reader readInt];
            int ratingMax = [reader readInt];
            [self notifySearchingWithRatingMin:ratingMin ratingMax:ratingMax];
            break;
        }
        case MessageTowerBuilt:
        {
            int towerType = [reader readInt];
            CGPoint position = CGPointMake([reader readInt], [reader readInt]);
            double time = ((double)[reader readInt])/1000;
            //[_delegate opponentTowerBuilt:towerType position:position time:time];
            [self notifyTowerBuilt:towerType position:position time:time];
            break;
        }
        case MessageMatchStatus:
        {
            NSLog(@"Received NOT_IN_MATCH");
            [self setState:NetworkStateReceivedMatchStatus];
            [self notifyNotInMatch];
            //[self sendFindMatch];
            break;
        }
        case MessageMatchFound:
        {
            NSLog(@"Received MESSAGE_MATCH_FOUND");
            Match* match;
            [self notifyMatchFound:match];
            break;
        }
        case MessageMatchStarted:
        {
            NSLog(@"Received MESSAGE_MATCH_STARTED");

            [self notifyMatchStarted];
            break;
        }
        case MessagePlayerInformation:
        {
            NSLog(@"Received MESSAGE_PLAYER_INFORMATION");
            PlayerType playerType = [reader readInt];
            Player* player = [reader readPlayer];
            [player setPlayerType:playerType];
            
            [reader readStatsForPlayer:player];
            
            [self notifyReceivedPlayer:player];
            
            break;
        }
        case MessageMatchOver:
        {
            NSString* winner = [reader readString];
            int rating = [reader readInt];
            
            NSLog(@"Received MESSAGE_MATCH_OVER - Winner %@ - Rating: %d", winner, rating);
            
            [self notifyMatchOverWithWinner: winner rating:rating];
            break;
        }
        case MessageLadder:
        {
            int nbResult = [reader readInt];
            
            NSMutableArray* listPlayers = [NSMutableArray arrayWithCapacity:nbResult];
            
            for (int i = 0; i < nbResult; i++) {
                Player* player = [[Player alloc] init];
                player.playerName = [reader readString];
                player.rating = [reader readInt];
                
                [listPlayers addObject:player];
            }
            
            int myRanking = [reader readInt];
            
            NSLog(@"Received MESSAGE_LADDER with %d results.", nbResult);
            [self notifyReceivedLadder:listPlayers ranking:myRanking];
            break;
        }


        default:
            NSLog(@"Received unknown message of type %d", msgType);
            break;
            
    }*/
}

- (void)checkForMessages {
    while (true) {
        if (_inputBuffer.length < sizeof(int)) {
            return;
        }
        
        int msgLength = *((int *) _inputBuffer.bytes);
        msgLength = ntohl(msgLength);
        if (_inputBuffer.length < msgLength) {
            return;
        }
        
        NSData * message = [_inputBuffer subdataWithRange:NSMakeRange(4, msgLength)];
        [self processMessage:message];
        
        int amtRemaining = (int)_inputBuffer.length - msgLength - sizeof(int);
        if (amtRemaining == 0) {
            self.inputBuffer = [[NSMutableData alloc] init];
        } else {
            //NSLog(@"Creating input buffer of length %d", amtRemaining);
            self.inputBuffer = [[NSMutableData alloc] initWithBytes:_inputBuffer.bytes+4+msgLength length:amtRemaining];
        }
        
    }
}


#pragma mark - Matchmaking

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController {
    
   /* if (!_gameCenterAvailable) return;
    
    [self setState:NetworkStatePendingMatch];
    
    self.presentingViewController = viewController;
    [_presentingViewController dismissModalViewControllerAnimated:NO];
    
    if (FALSE) {
        
        // TODO: Will add code here later!
        
    } else {
        GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
        request.minPlayers = minPlayers;
        request.maxPlayers = maxPlayers;
        
        self.mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
        _mmvc.hosted = YES;
        _mmvc.matchmakerDelegate = self;
        
        [_presentingViewController presentModalViewController:_mmvc animated:YES];
    }*/
    
    NSLog(@"findMatchWinMinPLayers called");
}
/*
#pragma mark - Notify observers
- (void)addNetworkObserver:(id<NetworkControllerDelegate>)observer {
    [_listObservers addObject:observer];
}

- (void)notifyStateChanged:(NetworkState)state {

}

- (void)notifyNotInMatch {

}

- (void)notifySearchingWithRatingMin:(int)ratingMin ratingMax:(int)ratingMax {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateSearchingWithRatingMin:ratingMax:)]) {
            [observer updateSearchingWithRatingMin:ratingMin ratingMax:ratingMax];
        }
    }
}

- (void)notifyMatchFound:(Match*)match {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateMatchFound:)]) {
            [observer updateMatchFound:match];
        }
    }
}

- (void)notifyMatchStarted {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateMatchStarted)]) {
            [observer updateMatchStarted];
        }
    }
}


- (void)notifyReceivedPlayer:(Player*)player {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateReceivedPlayer:)]) {
            [observer updateReceivedPlayer:player];
        }
    }
}


- (void)notifyTowerBuilt:(int)towerType position:(CGPoint)position time:(double)time {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateOpponentTowerBuilt:position:time:)]) {
            [observer updateOpponentTowerBuilt:towerType position:position time:time];
        }
    }
}

- (void)notifyCreepSent:(int)creepType time:(double)time {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateOpponentCreepSent:time:)]) {
            [observer updateOpponentCreepSent:creepType time:time];
        }
    }
}

- (void)notifyMatchOverWithWinner:(NSString*)winner rating:(int)rating {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateMatchOverWithWinner:rating:)]) {
            [observer updateMatchOverWithWinner:winner rating:rating];
        }
    }
}

- (void)notifyReceivedLadder:(NSMutableArray*)listPlayers ranking:(int)ranking {
    for (id<NetworkControllerDelegate> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateReceivedLadder:ranking:)]) {
            [observer updateReceivedLadder:listPlayers ranking:ranking];
        }
    }
}*/

@end
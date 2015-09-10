//
//  GCHelper.h
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCHelperDelegate  <NSObject>
@optional
- (void) scoreReported: (NSError*) error;
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
- (void) achievementResetResult: (NSError*) error;
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
@end

@interface GCHelper : NSObject {
    BOOL isAvailable;
    BOOL isAuthenticated;
    
    NSMutableDictionary* earnedAchievementCache;
	
    id <GCHelperDelegate> __unsafe_unretained delegate;
}

@property (assign, readonly) BOOL isAvailable;
@property (assign, readonly) BOOL isAuthenticated;
@property (unsafe_unretained) id <GCHelperDelegate> delegate;
@property (strong) NSMutableDictionary* earnedAchievementCache;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;

- (void) reportScore: (int64_t) score forCategory: (NSString*) category;
- (void) reloadHighScoresForCategory: (NSString*) category;

- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete;
- (void) resetAchievements;

- (void) mapPlayerIDtoPlayer: (NSString*) playerID;
@end

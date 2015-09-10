//
//  GCHelper.m
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper
@synthesize isAuthenticated, isAvailable;
@synthesize delegate;
@synthesize earnedAchievementCache;

#pragma mark Initialization

static GCHelper *sharedHelper = nil;
+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
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

- (instancetype)init {
    if ((self = [super init])) {
        isAvailable = [self isGameCenterAvailable];
        if (isAvailable) {
            NSNotificationCenter *nc = 
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self 
                   selector:@selector(authenticationChanged) 
                       name:GKPlayerAuthenticationDidChangeNotificationName 
                     object:nil];
        }
    }
    return self;
}

#pragma mark Internal functions

- (void)authenticationChanged {    
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !isAuthenticated) {
       NSLog(@"Authentication changed: player authenticated.");
       isAuthenticated = TRUE;           
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && isAuthenticated) {
       NSLog(@"Authentication changed: player not authenticated");
       isAuthenticated = FALSE;
    }
                   
}


- (void) callDelegate: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	assert([NSThread isMainThread]);
	if([delegate respondsToSelector: selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

		if(arg != nil)	{
			[delegate performSelector: selector withObject: arg withObject: err];
		} else {
			[delegate performSelector: selector withObject: err];
		}
#pragma clang diagnostic pop
	} else {
		NSLog(@"Missed Method");
	}
}


- (void) callDelegateOnMainThread: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self callDelegate: selector withArg: arg error: err];
    });
}

#pragma mark User functions
- (void)authenticateLocalUser {
    if (!isAvailable) return;
    if ([GKLocalPlayer localPlayer].authenticated == YES) return;
    NSLog(@"Authenticating local user...");

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
        // Gamekit login for ios 6
        [[GKLocalPlayer localPlayer] setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
            if (viewcontroller != nil) {
                UIViewController *vc = (UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                [vc presentViewController:viewcontroller animated:YES completion:nil];
            } else if ([GKLocalPlayer localPlayer].authenticated) {
                //do some stuff
            }
        })];
#else
    [[GKLocalPlayer localPlayer]authenticateWithCompletionHandler:nil];
#endif

    
}
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error {
    NSLog(@"Leaderboard: %@ Error: %@", leaderBoard, error  );

}
- (void) reloadHighScoresForCategory: (NSString*) category {
	GKLeaderboard* leaderBoard= [[GKLeaderboard alloc] init];
	leaderBoard.identifier = category;
	leaderBoard.timeScope = GKLeaderboardTimeScopeAllTime;
	leaderBoard.range= NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:  ^(NSArray *scores, NSError *error) {
         [self callDelegateOnMainThread: @selector(reloadScoresComplete:error:) withArg: leaderBoard error: error];
     }];
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category {
    
	GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:[category length] != 0 ? category : @"Leaderboard"];

	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) {
		 [self callDelegateOnMainThread: @selector(scoreReported:) withArg: nil error: error];
	 }];
}

- (void) scoreReported: (NSError*) error {
    NSLog(@"Error: %@", error  );
}

- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete {
	//GameCenter check for duplicate achievements when the achievement is submitted, but if you only want to report 
	// new achievements to the user, then you need to check if it's been earned 
	// before you submit.  Otherwise you'll end up with a race condition between loadAchievementsWithCompletionHandler
	// and reportAchievementWithCompletionHandler.  To avoid this, we fetch the current achievement list once,
	// then cache it and keep it updated with any new achievements.
	if(self.earnedAchievementCache == nil) {
		[GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error) {
             if(error == nil) {
                 NSMutableDictionary* tempCache= [NSMutableDictionary dictionaryWithCapacity: [scores count]];
                 for (GKAchievement* score in scores) {
                     tempCache[score.identifier] = score;
                 }
                 self.earnedAchievementCache= tempCache;
                 [self submitAchievement: identifier percentComplete: percentComplete];
             } else {
                 //Something broke loading the achievement list.  Error out, and we'll try again the next time achievements submit.
                 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: nil error: error];
             }
             
         }];
	} else {
        //Search the list for the ID we're using...
		GKAchievement* achievement= (self.earnedAchievementCache)[identifier];
		if(achievement != nil) {
			if((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete)) {
				//Achievement has already been earned so we're done.
				achievement= nil;
			}
			achievement.percentComplete= percentComplete;
		} else {
			achievement= [[GKAchievement alloc] initWithIdentifier: identifier];
			achievement.percentComplete= percentComplete;
			//Add achievement to achievement cache...
			(self.earnedAchievementCache)[achievement.identifier] = achievement;
		}
		if(achievement!= nil)	{
			//Submit the Achievement...
			[achievement reportAchievementWithCompletionHandler: ^(NSError *error) {
				 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: achievement error: error];
             }];
		}
	}
}
/*
- (void) synchronizeAchievements {
  	if(self.earnedAchievementCache == nil) {
		[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *scores, NSError *error) {
            if(error == nil) {
                NSMutableDictionary* tempCache= [NSMutableDictionary dictionaryWithCapacity: [scores count]];
                for (GKAchievement* score in scores) {
                    [tempCache setObject: score forKey: score.identifier];
                    
                    // report to delegate
                    if( score.percentComplete >= 100.0 ) {
                        if(self.delegate && [delegate respondsToSelector:@selector(achievementCompleted:)]) {
                            [self.delegate achievementCompleted:score.identifier];
                        }
                    }
                }
                self.earnedAchievementCache= tempCache;
            }
        }];
	} else {
        //Search the list for the ID we're using...
        for (GKAchievement* score in self.earnedAchievementCache) {
            // report to delegate
            // report to delegate
            if( score.percentComplete >= 100.0 ) {
                if(self.delegate && [self.delegate respondsToSelector:@selector(achievementCompleted:)]) {
                    [self.delegate achievementCompleted:score.identifier];
                }
            }
        }            
    }
            
}
*/


- (void) resetAchievements
{
	self.earnedAchievementCache= nil;
	[GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error)  {
		 [self callDelegateOnMainThread: @selector(achievementResetResult:) withArg: nil error: error];
     }];
}

- (void) mapPlayerIDtoPlayer: (NSString*) playerID
{
	[GKPlayer loadPlayersForIdentifiers: @[playerID] withCompletionHandler:^(NSArray *playerArray, NSError *error)
     {
         GKPlayer* player= nil;
         for (GKPlayer* tempPlayer in playerArray)
         {
             if([tempPlayer.playerID isEqualToString: playerID])
             {
                 player= tempPlayer;
                 break;
             }
         }
         [self callDelegateOnMainThread: @selector(mappedPlayerIDToPlayer:error:) withArg: player error: error];
     }];
	
}


@end

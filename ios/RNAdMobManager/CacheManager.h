//
//  CacheManager.h
//  Pods
//
//  Created by Ali on 8/25/21.
//

#ifndef CacheManager_h
#define CacheManager_h
#import "AdListener.h"
#import "RNAdMobUnifiedAdContainer.h"

@interface CacheManager:NSObject
extern NSString* const EVENT_AD_PRELOAD_LOADED;
extern NSString* const EVENT_AD_PRELOAD_ERROR;
+ (CacheManager*)sharedInstance;

-(BOOL) isLoading:(NSString*) id;
-(int)  numberOfAds:(NSString*) id;
-(void) attachAdListener:(NSString*) id listener:(AdListener*)listener;
-(void) detachAdListener:(NSString*) id;
-(NSDictionary*)registerRepo:(NSDictionary*) config;//MARK:TODO!
-(void) unRegisterRepo:(NSString*) repo;
-(void) resetCache;
-(void) requestAds:(NSString*) repo;
-(void) requestAd:(NSString*) repo;

-(BOOL) isRegistered:(NSString*) repo;
-(RNAdMobUnifiedAdContainer*) getNativeAd:(NSString*) repo;
-(NSDictionary*) hasAd:(NSString*) repo;

@end
#endif /* CacheManager_h */

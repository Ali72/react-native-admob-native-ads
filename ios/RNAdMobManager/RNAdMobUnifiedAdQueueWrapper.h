//
//  RNAdMobUnifiedAdQueueWrapper.h
//  Pods
//
//  Created by Ali on 8/25/21.
//

#ifndef RNAdMobUnifiedAdQueueWrapper_h
#define RNAdMobUnifiedAdQueueWrapper_h
#import "PriorityQueue.h"
#import "RNAdMobUnifiedAdContainer.h"
#import "AdListener.h"

@interface RNAdMobUnifiedAdQueueWrapper:NSObject<GADNativeAdLoaderDelegate,GADNativeAdDelegate>

-(instancetype)initWithConfig:(NSDictionary *)config repo:(NSString *)repo rootVC:(UIViewController*)rootVC;

@property(nonatomic, readwrite) NSString* adUnitId;
@property(nonatomic, readwrite) NSString* name;
@property(nonatomic, readwrite) BOOL npa;
@property(nonatomic, readwrite) int totalAds;
@property(nonatomic, readwrite) long expirationInterval; // in ms
@property(nonatomic, readwrite) BOOL muted;
@property(nonatomic, readwrite) BOOL mediation;
@property(nonatomic, readwrite) UIViewController* rootVC;
 
//   private final AdLoader adLoader;
//   private AdRequest adRequest;
//   AdListener attachedAdListener;
//   private final onUnifiedNativeAdLoadedListener unifiedNativeAdLoadedListener;
@property(nonatomic, readwrite) PriorityQueue* nativeAds;

-(void) attachAdListener:(id<AdListener>) listener;
-(void) detachAdListener;
-(void) loadAds;
-(void) loadAd;
-(void) fillAd;
-(RNAdMobUnifiedAdContainer*) getAd;
-(BOOL) isLoading;
-(NSDictionary*) hasAd;


@end

#endif /* RNAdMobUnifiedAdQueueWrapper_h */

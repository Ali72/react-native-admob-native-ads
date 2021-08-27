//
//  OnUnifiedNativeAdLoadedListener.m
//  react-native-admob-native-ads
//
//  Created by Ali on 8/25/21.
//

#import <Foundation/Foundation.h>
#import "OnUnifiedNativeAdLoadedListener.h"
#import "RNAdMobUnifiedAdContainer.h"
#import "EventEmitter.h"
#import "CacheManager.h"
@implementation OnUnifiedNativeAdLoadedListener
-(instancetype) initWithRepo:(NSString *)repo nativeAds:(PriorityQueue *)nativeAds tAds:(int)tAds{
    _repo = repo;
    _nativeAds = nativeAds;
    _totalAds = tAds;
    return self;
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveNativeAd:(nonnull GADNativeAd *)nativeAd {
    long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    if (self.nativeAds.size > _totalAds){
               // remove oldest ad if it is full
               RNAdMobUnifiedAdContainer *toBeRemoved = nil;

        for (RNAdMobUnifiedAdContainer *ad in [_nativeAds toArray])
        {
            if (ad.loadTime < time && ad.references <=0){
                time = ad.loadTime;
                toBeRemoved = ad;
            }
        }
        if (toBeRemoved !=  nil){
            toBeRemoved.unifiedNativeAd = nil;//insted of destory
            [self.nativeAds remove:toBeRemoved];
        }
    }
    RNAdMobUnifiedAdContainer *coniner = [[RNAdMobUnifiedAdContainer alloc] initWithAd:nativeAd loadTime:time showCount:0];
    [self.nativeAds add: coniner];

    NSMutableDictionary*  args = [[NSMutableDictionary alloc] init];
    [args setObject:[NSNumber numberWithInt:_nativeAds.size] forKey:_repo];
    [EventEmitter.sharedInstance sendEvent:CacheManager.EVENT_AD_PRELOAD_LOADED dict:args];
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull NSError *)error {

}

@end

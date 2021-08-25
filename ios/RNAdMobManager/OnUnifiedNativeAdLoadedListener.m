//
//  OnUnifiedNativeAdLoadedListener.m
//  react-native-admob-native-ads
//
//  Created by Ali on 8/25/21.
//

#import <Foundation/Foundation.h>
#import "OnUnifiedNativeAdLoadedListener.h"

@implementation OnUnifiedNativeAdLoadedListener
-(instancetype) initWithRepo:(NSString *)repo nativeAds:(PriorityQueue *)nativeAds tAds:(int)tAds{
    _repo = repo;
    _nativeAds = nativeAds;
    _totalAds = tAds;
    return self;
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull NSError *)error {
    
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveNativeAd:(nonnull GADNativeAd *)nativeAd {
    
}

@end

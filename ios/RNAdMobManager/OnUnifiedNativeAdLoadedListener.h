//
//  OnUnifiedNativeAdLoadedListener.h
//  Pods
//
//  Created by Ali on 8/25/21.
//

#ifndef OnUnifiedNativeAdLoadedListener_h
#define OnUnifiedNativeAdLoadedListener_h
#import "PriorityQueue.h"
@import GoogleMobileAds;

@interface OnUnifiedNativeAdLoadedListener : NSObject<GADNativeAdLoaderDelegate>

- (instancetype)initWithRepo:(NSString *)repo nativeAds:(PriorityQueue*) nativeAds  tAds:(int)tAds;
@property(nonatomic, readwrite) NSString* repo;
@property(nonatomic, readwrite) PriorityQueue* nativeAds;
//   Context mContext;
@property(nonatomic, readwrite) int totalAds;
@end
#endif /* OnUnifiedNativeAdLoadedListener_h */

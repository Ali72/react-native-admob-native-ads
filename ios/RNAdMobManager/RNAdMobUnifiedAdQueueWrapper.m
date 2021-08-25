//
//  RNAdMobUnifiedAdQueueWrapper.m
//  react-native-admob-native-ads
//
//  Created by Ali on 8/25/21.
//

#import <Foundation/Foundation.h>
#import "RNAdMobUnifiedAdQueueWrapper.h"
#import "OnUnifiedNativeAdLoadedListener.h"
#import "RNAdMobUnifiedAdContainer.h"
@import GoogleMobileAds;

@implementation RNAdMobUnifiedAdQueueWrapper{
    GADAdLoader* adLoader;
    GADRequest* adRequest;
    AdListener* attachedAdListener;
    OnUnifiedNativeAdLoadedListener* unifiedNativeAdLoadedListener;
}

-(instancetype)init:(NSDictionary *)config repo:(NSString *)repo rootVC:(UIViewController*)rootVC{
    if (self = [super init])  {
        self.npa = true;
        self.totalAds = 5;
        self.expirationInterval = 3600000; // in ms
        self.muted = true;
        self.mediation = false;
    }
    _adUnitId = [config objectForKey:@"adUnitId"] ;
    _name = repo;
    if ([config objectForKey:@"numOfAds"]){
        _totalAds = ((NSNumber *)[config objectForKey:@"numOfAds"]).intValue;
    }
    
    _nativeAds = [[PriorityQueue alloc] initWithCapacity:_totalAds andType:[RNAdMobUnifiedAdContainer class]];
    
    
    if ([config objectForKey:@"mute"]){
        _muted = ((NSNumber *)[config objectForKey:@"mute"]).boolValue;
    }
    if ([config objectForKey:@"expirationPeriod"]){
        _expirationInterval = ((NSNumber *)[config objectForKey:@"expirationPeriod"]).intValue;
    }
    if ([config objectForKey:@"mediationEnabled"]){
        _mediation = ((NSNumber *)[config objectForKey:@"mediationEnabled"]).boolValue;
    }
    if ([config objectForKey:@"nonPersonalizedAdsOnly"]){
        _npa = ((NSNumber *)[config objectForKey:@"nonPersonalizedAdsOnly"]).boolValue;
        
        adRequest = [GADRequest request];
        GADCustomEventExtras *extras = [[GADCustomEventExtras alloc] init];
        //MARK:TODO require test!
        [extras setExtras:@{@"npa": @([NSNumber numberWithInt:_npa].intValue)} forLabel:@"npa"];
        [adRequest registerAdNetworkExtras:extras];
  
    }else{
        adRequest = [GADRequest request];
    }
    
    unifiedNativeAdLoadedListener = [[OnUnifiedNativeAdLoadedListener alloc]initWithRepo:repo nativeAds:_nativeAds tAds:_totalAds];
    adRequest = [GADRequest request];
    
    GADVideoOptions* vOption = [[GADVideoOptions alloc]init];
    [vOption setStartMuted:_muted];
  
    adLoader = [[GADAdLoader alloc] initWithAdUnitID:_adUnitId rootViewController:rootVC adTypes:@[kGADAdLoaderAdTypeNative] options:@[vOption]];
    [adLoader setDelegate:self];
//MARK:TODO not found for ios
//https://developers.google.com/admob/ios/native/options#objective-c_1
//          NativeAdOptions adOptions = new NativeAdOptions.Builder()
//                  .setVideoOptions(videoOptions)
//                  .setAdChoicesPlacement(NativeAdOptions.ADCHOICES_TOP_RIGHT) // todo:: get from config
//                  .build();
//          builder.withNativeAdOptions(adOptions);
    
    
    
    return self;
}

-(void) attachAdListener:(AdListener*) listener {
    attachedAdListener = listener;
}
-(void) detachAdListener{
    attachedAdListener = nil;
}
-(void) loadAds{
    if (_mediation){
        for (int i = 0; i<_totalAds; i++){
            [adLoader loadRequest:adRequest];
        }
    } else {
        //MARK:TODO require more work!
        //https://ads-developers.googleblog.com/2017/12/loading-multiple-native-ads-in-google.html
        //https://developers.google.com/admob/ios/api/reference/Classes/GADMultipleAdsAdLoaderOptions
        GADMultipleAdsAdLoaderOptions* multipleAdsOptions = [[GADMultipleAdsAdLoaderOptions alloc] init];
        multipleAdsOptions.numberOfAds = _totalAds;
        
        //
        //              [adLoader loadRequest:adRequest]
        //              adLoader.loadAds(adRequest, totalAds);
    }
}
-(void) loadAd{
    
    [adLoader loadRequest:adRequest];
    [self fillAd];
}
-(void) fillAd{
    if ( [self isLoading]){
        [adLoader loadRequest:adRequest];
    }
}
-(RNAdMobUnifiedAdContainer*) getAd{
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    RNAdMobUnifiedAdContainer *ad;
    while (true){
        if (![_nativeAds isEmpty]){
            
            ad = [_nativeAds peek];
            if (ad != nil && ([ad loadTime] - now) < _expirationInterval) {
                break;
            } else {
                if (ad.references <=0){
                    //MARK:TODO no destory func
                    // [ad.unifiedNativeAd removeFromSuperview] ;
                    // ad.unifiedNativeAd.destroy();
                    [_nativeAds remove:ad];
                }
            }
        }else{
            return nil;
        }
    }
    [self fillAd];
    ad.showCount += 1;
    ad.references += 1;
    return ad;
}
-(BOOL) isLoading{
    if (adLoader != nil){
        return [adLoader isLoading];
    }
    return false;
}
-(NSDictionary*) hasAd{
    NSMutableDictionary*  args = [[NSMutableDictionary alloc] init];
    [args setObject:[NSNumber numberWithInt:_nativeAds.size] forKey:_name];
    return args;
}


- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull NSError *)error {
    
}
- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader{
    
}

@end

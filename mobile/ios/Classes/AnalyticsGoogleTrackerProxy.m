/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "AnalyticsGoogleTrackerProxy.h"
#import "AnalyticsGoogleTransactionProxy.h"

#import <GAIDictionaryBuilder.h>
#import <GAIFields.h>


@implementation AnalyticsGoogleTrackerProxy


-(id)initWithTrackingId:(NSString*)value
{
    if (self = [super init])
    {
        trackingId = [[NSString alloc] initWithString:value];
        if (![NSThread isMainThread])
        {
            TiThreadPerformOnMainThread(^{
                tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingId];
            }, NO);
        }
    }
    return self;
}

-(void)dealloc
{
    RELEASE_TO_NIL(tracker);
    RELEASE_TO_NIL(trackingId);
    [super dealloc];
}

#pragma mark Public APIs

-(void)trackEvent:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *category;
    NSString *action;
    NSString *label;
    NSNumber *value;

    ENSURE_ARG_OR_NIL_FOR_KEY(category, args, @"category", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(action, args, @"action", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(label, args, @"label", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(value, args, @"value", NSNumber);
    


    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:value] build]];
}

-(void)trackSocial:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *network;
    NSString *action;
    NSString *target;

    ENSURE_ARG_FOR_KEY(network, args, @"network", NSString);
    ENSURE_ARG_FOR_KEY(action, args, @"action", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(target, args, @"target", NSString);

    [tracker send:[[GAIDictionaryBuilder createSocialWithNetwork:network          // Social network (required)
                                                          action:action            // Social action (required)
                                                          target:target] build]];  // Social target
}

-(void)trackTiming:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *category;
    NSNumber *time;
    NSString *name;
    NSString *label;

    ENSURE_ARG_FOR_KEY(category, args, @"category", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(name, args, @"name", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(label, args, @"label", NSString);
    ENSURE_ARG_FOR_KEY(time, args, @"time", NSNumber);

    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:category    // Timing category (required)
                                                        interval:time        // Timing interval (required)
                                                            name:name  // Timing name
                                                           label:label] build]];    // Timing label
}

-(void)trackScreen:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_SINGLE_ARG(value, NSString);
    
    [tracker set:kGAIScreenName
             value:value];
    

    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)trackTransaction:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_SINGLE_ARG(value, AnalyticsGoogleTransactionProxy);

    AnalyticsGoogleTransactionProxy *proxy = (AnalyticsGoogleTransactionProxy*)value;
    [tracker send:[proxy transaction]];
    
    for (NSMutableDictionary *i in [proxy items]) {
            [tracker send:i];
    }
}


-(id)trackingId
{
    return trackingId;
}

-(id<GAITracker>)tracker
{
    return tracker;
}

@end

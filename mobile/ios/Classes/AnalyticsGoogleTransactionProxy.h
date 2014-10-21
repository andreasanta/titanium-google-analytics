/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"

#import "GAI.h"

@interface AnalyticsGoogleTransactionProxy : TiProxy{
    NSString *_transactionID;
	NSMutableDictionary *_transaction;
    NSMutableArray *_items;
}

-(NSMutableDictionary*)transaction;
-(NSMutableArray*)items;
-(id)initWithArgs:(NSDictionary*)args;

@end

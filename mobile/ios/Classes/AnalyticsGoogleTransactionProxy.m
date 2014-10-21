/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "AnalyticsGoogleTransactionProxy.h"
#import "TiBase.h"

#import <GAIDictionaryBuilder.h>

@implementation AnalyticsGoogleTransactionProxy

-(void)dealloc
{
    RELEASE_TO_NIL(_transaction);
    [super dealloc];
}

-(void)InitTransaction:(id)args
{
    NSString *transactionId;
    NSString *affiliation;
    NSNumber *tax;
    NSNumber *shipping;
    NSNumber *revenue;

    ENSURE_ARG_FOR_KEY(transactionId, args, @"id", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(affiliation, args, @"affiliation", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(tax, args, @"tax", NSNumber);
    ENSURE_ARG_OR_NIL_FOR_KEY(shipping, args, @"shipping", NSNumber);
    ENSURE_ARG_OR_NIL_FOR_KEY(revenue, args, @"revenue", NSNumber);
    
    _transactionID = transactionId;
    _items = [NSMutableArray array];
    _transaction = [[GAIDictionaryBuilder createTransactionWithId:transactionId             // (NSString) Transaction ID
                                                     affiliation:affiliation         // (NSString) Affiliation
                                                         revenue:[self toMicros:[revenue doubleValue]]                  // (NSNumber) Order revenue (including tax and shipping)
                                                             tax:[self toMicros:[tax doubleValue]]                 // (NSNumber) Tax
                                                        shipping:[self toMicros:[shipping doubleValue]]                    // (NSNumber) Shipping
                                                    currencyCode:@"EUR"] build];        // (NSString) Currency code
}

-(id)initWithArgs:(NSDictionary*)args
{
    if (self = [super init])
    {
        _transaction = nil;
        ENSURE_UI_THREAD(InitTransaction, args);
    }
    return self;
}

-(int64_t)toMicros:(double)value
{
    return (int64_t) (value * 1000000);
}

#pragma mark Public APIs

-(void)addItem:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *productCode;
    NSString *productName;
    NSString *productCategory;
    NSNumber *price;
    NSNumber *quantity;

    ENSURE_ARG_FOR_KEY(productCode, args, @"sku", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(productName, args, @"name", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(productCategory, args, @"category", NSString);
    ENSURE_ARG_FOR_KEY(price, args, @"price", NSNumber);
    ENSURE_ARG_FOR_KEY(quantity, args, @"quantity", NSNumber);

    NSMutableDictionary *i = [[GAIDictionaryBuilder createItemWithTransactionId:_transactionID        // (NSString) Transaction ID
                                                                name:productName  // (NSString) Product Name
                                                                 sku:productCode            // (NSString) Product SKU
                                                            category:productCategory  // (NSString) Product category
                                                               price:[self toMicros:[price doubleValue]]              // (NSNumber)  Product price
                                                            quantity:quantity                  // (NSInteger)  Product quantity
                                                        currencyCode:@"EUR"] build];    // (NSString) Currency code
    
    [_items addObject:i];
}

-(NSMutableDictionary*)transaction
{
    return _transaction;
}

-(NSMutableArray*)items
{
    return _items;
}

@end

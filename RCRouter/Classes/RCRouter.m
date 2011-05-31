//
//  RCRouter.m
//  RCRouter
//
//  Created by Ross Cairns on 31/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCRouter.h"

#define kESTIMATED_NUMBER_OF_ROUTES 10

static RCRouter *sharedRouter = nil;

@interface RCRouter ()

// private
- (void)setup;
- (void)map:(NSString*)route to:(id)reciever with:(SEL)selector;
- (void)dispatch:(NSString*)route;
- (void)remove:(NSString*)route;
- (void)removeAllRoutesToReceiver:(id)receiver;
- (void)addDelegate:(id<RCRouterDelegate>)delegate;

@end

@implementation RCRouter

#pragma mark -
#pragma mark Class/Router Methods

+ (void)map:(NSString*)route to:(id)reciever with:(SEL)selector {
    
    [[RCRouter sharedRouter] map:route to:reciever with:selector];
    
}

+ (void)dispatch:(NSString*)route {
    
    [[RCRouter sharedRouter] dispatch:route];
    
}

+ (void)remove:(NSString*)route {
    
    [[RCRouter sharedRouter] remove:route];
    
}

+ (void)removeAllRoutesToReceiver:(id)receiver {
    
    [[RCRouter sharedRouter] removeAllRoutesToReceiver:receiver];
    
}

+ (void)addDelegate:(id<RCRouterDelegate>)delegate {
    
    [[RCRouter sharedRouter] addDelegate:delegate];
    
}

#pragma mark -
#pragma mark Instance Methods

/// initialisation
- (void)setup {
    
    _routes = [[NSMutableDictionary alloc] initWithCapacity:kESTIMATED_NUMBER_OF_ROUTES];
    
}

///////
///// router methods called from Class methods
///
//

/// using the route as a key, add a dictionary with keys "selector" & "reciever" to the _routes dictionary
- (void)map:(NSString*)route to:(id)reciever with:(SEL)selector {
    
    NSDictionary *selectorAndRecieverInfo = [[NSDictionary alloc] initWithObjectsAndKeys:NSStringFromSelector(selector), 
                                                                         @"selector", 
                                                                         reciever, 
                                                                         @"reciever", nil];
    
    [_routes setObject:selectorAndRecieverInfo forKey:route];
   
    [selectorAndRecieverInfo release];
    
}

- (void)dispatch:(NSString*)route {
    
    // say we have params
    NSDictionary *params; 
     
    // say we have matched a route, we would do
    NSDictionary *validRoute; // this is the route
    
    [self performSelector:NSSelectorFromString([validRoute objectForKey:@"selector"]) withObject:[validRoute objectForKey:@"reciever"] withObject:params];
    
}

- (void)remove:(NSString*)route {
 
    [_routes removeObjectForKey:route];
    
}

/// must be called on a recivers deallocation. removes all routes stored in the _routes dictionary for a specific reciever
- (void)removeAllRoutesToReceiver:(id)receive {
    
    NSLog(@"stub: removeAllRoutesForReciever - not going to remove anything yet, try remove:");
    
}

- (void)addDelegate:(id<RCRouterDelegate>)delegate {
    
    if (_delegate) {
        [_delegate release];
    }
    
    _delegate = [delegate retain];

}

#pragma mark -
#pragma mark Singleton methods

+ (RCRouter*)sharedRouter
{
    @synchronized(self)
    {
        if (sharedRouter == nil) {
            sharedRouter = [[RCRouter alloc] init];
            [sharedRouter setup];
        }
    }
    return sharedRouter;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedRouter == nil) {
            sharedRouter = [super allocWithZone:zone];
            return sharedRouter;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


@end

//
//  RCRouter.m
//  RCRouter
//
//  Created by Ross Cairns on 31/05/2011.
//  RossCairns.com | TheWorkers.net
//

#import "RCRouter.h"

#define kESTIMATED_NUMBER_OF_ROUTES 10

static RCRouter *sharedRouter = nil;

@interface RCRouter ()

// private (called by class methods)
- (void)map:(NSString*)route to:(id)reciever with:(SEL)selector;
- (void)dispatch:(NSString*)path;
- (void)remove:(NSString*)route;
- (void)removeAllRoutesToReceiver:(id)receiver;
- (void)addDelegate:(id<RCRouterDelegate>)delegate;

// private
- (void)setup;

// utils
// Delegate methods
- (BOOL)isValidDelegateForSelector:(SEL)selector;

@end

@implementation RCRouter

#pragma mark -
#pragma mark Class/Router Methods

+ (void)map:(NSString*)route to:(id)reciever with:(SEL)selector {
    
    [[RCRouter sharedRouter] map:route to:reciever with:selector];
    
}

+ (void)dispatch:(NSString*)path {
    
    [[RCRouter sharedRouter] dispatch:path];
    
}

+ (void)remove:(NSString*)route {
    
    [[RCRouter sharedRouter] remove:route];
    
}

+ (void)removeAllRoutesToReceiver:(id)receiver {
    
    [[RCRouter sharedRouter] removeAllRoutesToReceiver:receiver];
    
}

+ (BOOL)canRespondToRoute:(NSString*)route {
    [[RCRouter sharedRouter] canRespondToRoute:route];
}

+ (void)addDelegate:(id<RCRouterDelegate>)delegate {
    
    [[RCRouter sharedRouter] addDelegate:delegate];
    
}

#pragma mark utils

- (BOOL)isValidDelegateForSelector:(SEL)selector
{
	return ((_delegate != nil) && [_delegate respondsToSelector:selector]);
}


#pragma mark -
#pragma mark Instance Methods

///////
///// private instance methods
///
//

/// initialisation
- (void)setup {
    
    _routes = [[NSMutableArray alloc] initWithCapacity:kESTIMATED_NUMBER_OF_ROUTES];
    
}

///////
///// router methods called from Class methods
///
//

- (void)map:(NSString*)route to:(id)reciever with:(SEL)selector {
    
    RCRoute *routeObj = [[RCRoute alloc] initWithRoute:route to:reciever with:selector];
    
    [_routes addObject:routeObj];
    
    [routeObj release];
    
}

- (BOOL)canRespondToRoute:(NSString*)route {
    NSEnumerator *routeEnumerator = [_routes objectEnumerator];
    RCRoute *routeObj;

    while ((routeObj = [routeEnumerator nextObject])) {

        // found a match
        if ( [routeObj matches:route] ) {
            return YES;
        }

    }

    return NO;

}

- (void)dispatch:(NSString*)path {
    
    // check with delegate if this is a vaild path
    if ([self isValidDelegateForSelector:@selector(allow:)]) {
        
        BOOL allowedToPreform = ((BOOL)[_delegate performSelector:@selector(allow:) withObject:path]);
        
        if (!allowedToPreform) {
            
            return;
        }
    }
    
    NSEnumerator *routeEnumerator = [_routes objectEnumerator];
    RCRoute *routeObj;
    
    while ((routeObj = [routeEnumerator nextObject])) {
        
        // found a match
        if ( [routeObj matches:path] ) {
            
            NSDictionary *params = [routeObj paramsForPath:path];
            
            // inform delegate of intention
            if ([self isValidDelegateForSelector:@selector(willDispatchRoute:to:)]) {
                
                [_delegate performSelector:@selector(willDispatchRoute:to:) withObject:path withObject:routeObj.receiver];
            }
            
            // dispatch the route
            [routeObj.receiver performSelector:routeObj.selector withObject:params];
            
            // inform delegate of intention
            if ([self isValidDelegateForSelector:@selector(didDispatchRoute:to:)]) {
                
                [_delegate performSelector:@selector(didDispatchRoute:to:) withObject:path withObject:routeObj.receiver];
            }
            
            return;
        }
    }
    
    // no match found
    if ([self isValidDelegateForSelector:@selector(noRouteFor:)]) {
        
        [_delegate performSelector:@selector(noRouteFor:) withObject:path];
    }
    
    return;
    
}

- (void)remove:(NSString*)route {
 
    NSEnumerator *routesEnumerator = [_routes objectEnumerator];
    RCRoute *routeObj;
    
    while ((routeObj = [routesEnumerator nextObject])) {
        if ([routeObj.route compare:route] == NSOrderedSame) {
            [_routes removeObject:routeObj];
            break;
        }
    }
}

/// must be called on a recivers deallocation. removes all routes stored in the _routes dictionary for a specific reciever
- (void)removeAllRoutesToReceiver:(id)receiver {
    
    NSEnumerator *routesEnumerator = [_routes objectEnumerator];
    RCRoute *routeObj;
    
    while ((routeObj = [routesEnumerator nextObject])) {
        if (routeObj.receiver == receiver) {
            [_routes removeObject:routeObj];
        }
    }
    
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

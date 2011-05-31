//
//  RCRouter.h
//  RCRouter
//
//  Created by Ross Cairns on 31/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCRouterDelegate <NSObject>

@optional
// not yet implemented
- (BOOL)allowDispatchTo:(NSString*)route;
- (void)didDispatchRoute:(NSString*)route to:(id)object;
- (void)noRouteFor:(NSString*)route;

@end

@interface RCRouter : NSObject {
    
@private 
    NSMutableDictionary *_routes;
    id <RCRouterDelegate> _delegate;
    
}

// Class Methods 
+ (void)map:(NSString*)route to:(id)reciever with:(SEL)selector;
+ (void)dispatch:(NSString*)route;
+ (void)remove:(NSString*)route;
+ (void)removeAllRoutesToReceiver:(id)receiver;

// To Do
+ (void)addDelegate:(id<RCRouterDelegate>)delegate;

// Singleton Methods
+(RCRouter*)sharedRouter;
@end

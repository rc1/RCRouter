//
//  RCRouter.h
//  RCRouter
//
//  Created by Ross Cairns on 31/05/2011.
//  RossCairns.com | TheWorkers.net
//

#import <Foundation/Foundation.h>
#import "RCRoute.h"

@protocol RCRouterDelegate <NSObject>

@optional
- (BOOL)allow:(NSString*)route;
- (void)willDispatchRoute:(NSString*)route to:(id)object;
- (void)didDispatchRoute:(NSString*)route to:(id)object;
- (void)noRouteFor:(NSString*)route;

@end

@interface RCRouter : NSObject {
    
@private 
    NSMutableArray *_routes;
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
+ (RCRouter*)sharedRouter;
@end

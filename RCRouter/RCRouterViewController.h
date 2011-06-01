//
//  RCRouterViewController.h
//  RCRouter
//
//  Created by Ross Cairns on 31/05/2011.
//  RossCairns.com | TheWorkers.net
//

#import <UIKit/UIKit.h>
#import "RCRouter.h"

@interface RCRouterViewController : UIViewController<RCRouterDelegate> {
    
}

// set up example
- (void)createRoutes;
- (void)callRoutes;

// mapped routes
- (void)hello:(NSDictionary*)params;

// Router delegate methods
- (BOOL)allow:(NSString*)route;
- (void)willDispatchRoute:(NSString*)route to:(id)object;
- (void)didDispatchRoute:(NSString*)route to:(id)object;
- (void)noRouteFor:(NSString*)route;

@end

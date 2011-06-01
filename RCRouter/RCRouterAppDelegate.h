//
//  RCRouterAppDelegate.h
//  RCRouter
//
//  Created by Ross Cairns on 31/05/2011.
//  RossCairns.com | TheWorkers.net
//

#import <UIKit/UIKit.h>

@class RCRouterViewController;

@interface RCRouterAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet RCRouterViewController *viewController;

@end

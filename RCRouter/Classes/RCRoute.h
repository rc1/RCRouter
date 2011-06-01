//
//  RCRoute.h
//  RCRouter
//
//  Created by Ross Cairns on 01/06/2011.
//  RossCairns.com | TheWorkers.net
//

#import <Foundation/Foundation.h>


@interface RCRoute : NSObject {
    
    NSRegularExpression *_checkForMatchRegEx;
    NSRegularExpression *_extractParamValuesRegEx;
    NSArray *_parameterNames;
    id _receiver;
    SEL _selector;
    NSString *_route;
    
}

@property (nonatomic, retain) id receiver;
@property (nonatomic) SEL selector;
@property (nonatomic, readonly) NSString *route;

// init
- (id)initWithRoute:(NSString*)route to:(id)receiver with:(SEL)selector;

- (BOOL)matches:(NSString*)path;
- (NSDictionary*)paramsForPath:(NSString*)path;

@end

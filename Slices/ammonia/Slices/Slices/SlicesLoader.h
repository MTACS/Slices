//
//  SlicesLoader.h
//  Slices
//
//  Created by DF on 10/13/25.
//

#import <Foundation/Foundation.h>
#import "ZKSwizzle.h"
#include <dlfcn.h>

@import AppKit;

@interface SlicesLoader : NSObject
@end

@interface SlicesInfoWindowController : NSWindowController
@end

@interface Slices : NSObject
@property (nonatomic, retain) SlicesInfoWindowController *infoWindowController;
+ (void)load;
- (void)loadSlices;
+ (id)sharedInstance;
- (void)showSliceInspector:(id)sender;
@end

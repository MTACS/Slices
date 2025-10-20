//
//  Slices.h
//  Slices
//
//  Created by DF on 11/4/24.
//
//

#import <Foundation/Foundation.h>
#import <OSLog/OSLog.h>
#import "Classes/SlicesInfoWindowController.h"

@interface Slices : NSObject
@property (nonatomic, retain) SlicesInfoWindowController *infoWindowController;
- (void)loadSlices;
+ (instancetype)sharedInstance;
- (void)showSliceInspector:(id)sender;
@end

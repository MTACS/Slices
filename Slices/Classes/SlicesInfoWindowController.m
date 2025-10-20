//
//  SlicesInfoWindowController.m
//  Slices
//
//  Created by DF on 2/5/25.
//

#import "SlicesInfoWindowController.h"

@interface SlicesInfoWindowController ()
@end

@implementation SlicesInfoWindowController
- (id)init {
    self = [super initWithWindowNibName:@"SlicesInfoWindowController"];
    return self;
}
- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
/* - (void)newWindowForTab:(id)sender {
    // SlicesInfoWindowController *infoWindowController = [[SlicesInfoWindowController alloc] initWithWindowNibName:@"SlicesInfoWindowController"];
    SlicesInfoWindow *window = (SlicesInfoWindow *)self.window;
    [self.window addTabbedWindow:window ordered:NSWindowAbove];
    
    [window orderFront:self.window];
    [window makeKeyWindow];
} */
@end

//
//  Slices.m
//  Slices
//
//  Created by DF on 11/4/24.
//
//

#import "Slices.h"
#import "SlicesWindowController.h"

Slices *plugin;

@interface Slices()
@end

@implementation Slices
+ (instancetype)sharedInstance {
    static Slices *plugin = nil;
    @synchronized(self) {
        if (!plugin) {
            plugin = [[self alloc] init];
        }
    }
    return plugin;
}
+ (void)load {
    [plugin loadSlices];
}
- (void)loadSlices {
    plugin = [Slices sharedInstance];
    
    plugin.infoWindowController = [[SlicesInfoWindowController alloc] init];
    
    NSLog(@"[SLICES] Loading into -> %@", [NSBundle mainBundle].bundleIdentifier);
    
    NSMenu *mainMenu = [[[[NSApp mainMenu] itemArray] firstObject] submenu];
    for (NSMenuItem *menuItem in mainMenu.itemArray) {
        if ([menuItem.title isEqualToString:@"Slices"]) {
            [mainMenu removeItem:menuItem];
        }
    }
    
    NSMenu *slicesMenu = [[NSMenu alloc] initWithTitle:@"Slices"];
    [slicesMenu addItem:[plugin hierarchyItem]];
    
    NSMenuItem *slicesItem = [[NSMenuItem alloc] init];
    [slicesItem setTitle:@"Slices"];
    
    [mainMenu insertItem:[NSMenuItem separatorItem] atIndex:mainMenu.itemArray.count - 2];
    [mainMenu insertItem:slicesItem atIndex:mainMenu.itemArray.count - 2];
    
    [mainMenu setSubmenu:slicesMenu forItem:slicesItem];
}
- (NSMenuItem *)hierarchyItem {
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Show View Hierarchy" action:@selector(showSliceInspector:) keyEquivalent:@""];
    item.enabled = YES;
    item.hidden = NO;
    item.target = plugin;
    return item;
}
- (void)showSliceInspector:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        SlicesWindowController *windowController = [[SlicesWindowController alloc] init];
        [windowController showWindow:plugin];
    });
}
@end

ZKSwizzleInterface(sl_NSView, NSView, NSObject)
@implementation sl_NSView
- (id)init {
    self = ZKOrig(id);
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slices_deselect) name:@"SlicesDeselect" object:nil];
    }
    return self;
}
- (void)slices_select {
    ((NSView *)self).layer.backgroundColor = [[NSColor systemCyanColor] colorWithAlphaComponent:0.5].CGColor;
    ((NSView *)self).wantsLayer = YES;
}
- (void)slices_deselect {
    ((NSView *)self).layer.backgroundColor = [NSColor clearColor].CGColor;
    ((NSView *)self).wantsLayer = NO;
}
@end

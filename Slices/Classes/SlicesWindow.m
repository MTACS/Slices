//
//  SlicesWindow.m
//  Slices
//
//  Created by DF on 1/26/25.
//

#import "SlicesWindow.h"

NSView *selectedView;

@implementation SlicesWindow
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)makeKeyWindow {
    [super makeKeyWindow];
    
    NSDictionary *finderDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.mtac.refinder"];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadOutline) name:NSWindowDidBecomeKeyNotification object:nil];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadOutline) name:NSWindowWillCloseNotification object:nil];
    
    [self setStyleMask:self.styleMask|NSWindowStyleMaskFullSizeContentView];
    NSVisualEffectView *vibrant = [[NSClassFromString(@"NSVisualEffectView") alloc] initWithFrame:[[self contentView] bounds]];
    [vibrant setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [vibrant setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
    [vibrant setMaterial:(NSVisualEffectMaterial)[[finderDefaults objectForKey:@"selectedBlurStyle"] integerValue]];
    [[self contentView] addSubview:vibrant positioned:NSWindowBelow relativeTo:nil];
    
    [self refresh:nil];
}
- (void)reloadOutline {
    [self.outlineView reloadData];
    [self.outlineView setNeedsDisplay:YES];
}
- (void)windowWillClose:(NSNotification *)notification {
    self.tree = nil;
    [selectedView performSelector:@selector(slices_deselect)];
    selectedView = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SlicesDeselect" object:nil];
}
- (void)outlineViewItemWillCollapse:(NSNotification *)notification {
    NSLog(@"[SLICES] Collapse");
}
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(SlicesTreeNode *)item {
    if (item == nil) {
        return self.tree.windows.count;
    } else if ([item isKindOfClass:[SlicesTreeNode class]]) {
        SlicesTreeNode *node = item;
        return node.subviews.count;
    } else {
        return 0;
    }
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(SlicesTreeNode *)item {
    if (item == nil) {
        return (self.tree.windows)[index];
    } else if ([item isKindOfClass:[SlicesTreeNode class]]) {
        SlicesTreeNode *node = item;
        return node.subviews[index];
    } else {
        return nil;
    }
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(SlicesTreeNode *)item {
    if ([item isKindOfClass:[SlicesTreeNode class]]) {
        SlicesTreeNode *node = item;
        return (node.subviews.count != 0) ? YES : NO;
    }
    return NO;
}
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    if (selectedView != nil) {
        [selectedView performSelector:@selector(slices_deselect)];
    }
    SlicesTreeNode *item = [self.outlineView itemAtRow:self.outlineView.selectedRow];
    [item.view performSelector:@selector(slices_select)];
    selectedView = item.view;
    // [self.outlineView expandItem:item expandChildren:YES];
}
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(SlicesTreeNode *)item {
    
    return item;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    return NO;
}
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    if ([item isKindOfClass:[SlicesTreeNode class]]) {
        SlicesTreeNode *node = item;
        if ([node.view isKindOfClass:[NSWindow class]]) {
            SlicesTableCellView *cellView = [outlineView makeViewWithIdentifier:@"window" owner:self];
            cellView.node = node;
            return cellView;
        } else {
            SlicesTableCellView *cellView = [outlineView makeViewWithIdentifier:@"main" owner:self];
            cellView.view = node.view;
            cellView.node = node;
            return cellView;
        }
    }
    return nil;
}
- (IBAction)doubleClick:(NSOutlineView *)sender {
    SlicesTreeNode *item = [self.outlineView itemAtRow:self.outlineView.selectedRow];
    
    SlicesInfoWindowController *infoWindowController = [[Slices sharedInstance] infoWindowController];
    
    if (![infoWindowController.window isVisible]) {
        [infoWindowController showWindow:self];
    }
    
    // SlicesInfoWindow *infoWindow = (SlicesInfoWindow *)infoWindowController.window;
    
    // [infoWindow makeKeyAndOrderFront:self];
    
    // [infoWindowController showWindow:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SlicesAddObjectInfo" object:item.view];
}
- (IBAction)refresh:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SlicesDeselect" object:nil];
    
    NSArray<NSWindow*> *windows = [self appWindows];
    
    if (self.tree != nil) {
        self.tree = nil;
    }
    
    self.tree = [[SlicesTree alloc] init];
    self.tree.windows = [[NSMutableArray alloc] init];
    for (NSWindow *window in windows) {
        window.canBecomeVisibleWithoutLogin = YES;
        if (![window isKindOfClass:objc_getClass("NSPopupMenuWindow")]) {
            [self.tree.windows addObject:[[SlicesTreeNode alloc] initWithView:(NSView *)window]];
        }
    }
    for (SlicesTreeNode *node in self.tree.windows) {
        [SlicesViewHierarchy childNodes:node skipPrivateClasses:NO screenshots:NO recursive:YES];
    }
    [self reloadOutline];
}
- (NSArray<NSWindow *>*)appWindows {
    NSMutableArray *windows = [NSMutableArray array];
    
    for (NSWindow *window in [NSApplication sharedApplication].windows) {
        if (![window.identifier isEqualToString:@"com.mtac.slices"]) {
            [windows addObject:window];
        }
    }
    return windows;
}
@end

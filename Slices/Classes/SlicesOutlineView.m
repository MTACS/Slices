//
//  SlicesOutlineView.m
//  Slices
//
//  Created by DF on 2/6/25.
//

#import "SlicesOutlineView.h"
#import "SlicesTreeNode.h"

@implementation SlicesOutlineView
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
- (NSMenu *)menuForEvent:(NSEvent *)event {
    NSPoint pt = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:pt];
    
    SlicesTreeNode *node = (SlicesTreeNode *)[self itemAtRow:row];
    
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *copyClass = [[NSMenuItem alloc] init];
    [copyClass setTitle:@"Copy Class Name"];
    [copyClass setTarget:node];
    [copyClass setAction:@selector(copyClassName)];
    [menu addItem:copyClass];
    
    return menu;
}
@end

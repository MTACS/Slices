//
//  SlicesTextView.m
//  Slices
//
//  Created by DF on 2/18/25.
//

#import "SlicesTextView.h"

@implementation SlicesTextView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textFinder = [[NSTextFinder alloc] init];
    [self.textFinder setClient:self];
    [self.textFinder setFindBarContainer:self.enclosingScrollView];
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
- (NSMenu *)menu {
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Info"];
    [menu addItemWithTitle:@"View Object Info" action:@selector(viewInfo) keyEquivalent:@""];
    menu.allowsContextMenuPlugIns = NO;
    return menu;
}
- (NSMenu *)menuForEvent:(NSEvent *)event {
    return [self menu];
}
- (void)viewInfo {
    NSString *selected = [[self string] substringWithRange:[self selectedRange]];
    unsigned long long hexAddress;
    [[NSScanner scannerWithString:selected] scanHexLongLong:&hexAddress];
    NSObject *object = (__bridge id)(void *)hexAddress;
    
    if (object != NULL) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SlicesAddObjectInfo" object:object];
    }
}
@end

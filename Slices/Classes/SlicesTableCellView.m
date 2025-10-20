//
//  SlicesTableCellView.m
//  Slices
//
//  Created by DF on 1/24/25.
//

#import "SlicesTableCellView.h"

@interface SlicesTableCellView ()
@property (assign) BOOL isSmallSize;
@end

@implementation SlicesTableCellView
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)copyClassName:(NSMenuItem *)sender {
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:self.node.title forType:NSPasteboardTypeString];
}
@end

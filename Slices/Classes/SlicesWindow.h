//
//  SlicesWindow.h
//  Slices
//
//  Created by DF on 1/26/25.
//

#import <Cocoa/Cocoa.h>
#import "SlicesTreeNode.h"
#import "SlicesTree.h"
#import "SlicesViewHierarchy.h"
#import "SlicesTableCellView.h"
#import "SlicesOutlineView.h"
#import "SlicesInfoWindowController.h"
#import "../Slices.h"

@interface SlicesWindow : NSWindow <NSOutlineViewDelegate, NSOutlineViewDataSource, NSWindowDelegate>
@property (strong) IBOutlet SlicesOutlineView *outlineView;
@property (strong) SlicesTree *tree;
@end

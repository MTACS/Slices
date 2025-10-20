//
//  SlicesTableCellView.h
//  Slices
//
//  Created by DF on 1/24/25.
//

#import <Cocoa/Cocoa.h>
#import "SlicesTreeNode.h"
// #import "SlicesInfoWindowController.h"

@interface SlicesTableCellView : NSTableCellView
@property (weak) IBOutlet NSTextField *subTitleTextField;
@property (nonatomic, retain) NSMutableDictionary *ivarDictionary;
@property (nonatomic, retain) NSMutableDictionary *propertyDictionary;
@property (nonatomic, retain) NSView *view;
@property (nonatomic, retain) SlicesTreeNode *node;
@end

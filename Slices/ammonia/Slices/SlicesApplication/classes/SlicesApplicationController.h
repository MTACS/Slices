//
//  SlicesApplicationController.h
//  SlicesApplication
//
//  Created by DF on 10/13/25.
//

#import <Cocoa/Cocoa.h>
#import "SlicesApplicationTableCellView.h"
#import "../libMAList/MAList.h"

@interface SlicesApplicationController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>
@property (strong) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSMutableArray *whiteListArray;
@end

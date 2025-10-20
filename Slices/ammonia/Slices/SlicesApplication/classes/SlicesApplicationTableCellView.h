//
//  SlicesApplicationTableCellView.h
//  SlicesApplication
//
//  Created by DF on 10/13/25.
//

#import <Cocoa/Cocoa.h>

#define WHITELIST @"/private/var/ammonia/core/tweaks/libSlices.dylib.whitelist"

@interface SlicesApplicationTableCellView : NSTableCellView
@property (strong) IBOutlet NSImageView *iconView;
@property (strong) IBOutlet NSTextField *titleLabel;
@property (strong) IBOutlet NSTextField *subtitleLabel;
@property (strong) IBOutlet NSSwitch *enableSwitch;
@property (strong) NSString *identifier;
@end

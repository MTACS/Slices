//
//  SlicesApplicationTableCellView.m
//  SlicesApplication
//
//  Created by DF on 10/13/25.
//

#import "SlicesApplicationTableCellView.h"

@implementation SlicesApplicationTableCellView
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
}
- (IBAction)switchStateChanged:(NSSwitch *)sender {
    NSMutableArray *whiteListArray = [NSMutableArray new];
    if ([[NSFileManager defaultManager] fileExistsAtPath:WHITELIST]) {
        NSString *contents = [NSString stringWithContentsOfFile:WHITELIST encoding:NSUTF8StringEncoding error:nil];
        whiteListArray = [[contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    }
    if (sender.state == NSControlStateValueOff) {
        if ([whiteListArray containsObject:self.titleLabel.stringValue]) {
            [whiteListArray removeObject:self.titleLabel.stringValue];
        }
    } else if (sender.state == NSControlStateValueOn) {
        if (![whiteListArray containsObject:self.titleLabel.stringValue]) {
            [whiteListArray addObject:self.titleLabel.stringValue];
        }
    }
    NSString *joinedString = [whiteListArray componentsJoinedByString:@"\n"];
    NSError *error = nil;
    BOOL success = [joinedString writeToFile:WHITELIST atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!success) {
        NSLog(@"[SLICES] Error writing file: %@", error.localizedDescription);
    } else {
        NSLog(@"[SLICES] File written successfully!");
    }
}
@end

//
//  SlicesApplicationController.m
//  SlicesApplication
//
//  Created by DF on 10/13/25.
//

#import "SlicesApplicationController.h"

@interface SlicesApplicationController ()
@end

@implementation SlicesApplicationController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWhitelist];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"SlicesApplicationTableCellView" bundle:nil] forIdentifier:@"slicesApplicationTableCellView"];
}
- (void)loadWhitelist {
    if (!self.whiteListArray) self.whiteListArray = [NSMutableArray new];
    if ([[NSFileManager defaultManager] fileExistsAtPath:WHITELIST]) {
        NSString *contents = [NSString stringWithContentsOfFile:WHITELIST encoding:NSUTF8StringEncoding error:nil];
        self.whiteListArray = [[contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
        NSLog(@"[SLICES] Whitelist -> %@", self.whiteListArray);
    }
}
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    SlicesApplicationTableCellView *applicationCell = (SlicesApplicationTableCellView *)cell;
    [applicationCell.enableSwitch setState:[self.whiteListArray containsObject:applicationCell.titleLabel.stringValue]];
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    SlicesApplicationTableCellView *cell = [tableView makeViewWithIdentifier:@"slicesApplicationTableCellView" owner:self];
    MALApp *app = [[MAList apps] objectAtIndex:row];
    cell.titleLabel.stringValue = app.title;
    cell.subtitleLabel.stringValue = app.bundleId;
    cell.iconView.image = app.icon;
    cell.identifier = app.bundleId;
    if ([self.whiteListArray containsObject:app.title]) {
        [cell.enableSwitch setState:NSControlStateValueOn];
    } else {
        [cell.enableSwitch setState:NSControlStateValueOff];
    }
    return cell;
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [MAList apps].count;
}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return NO;
}
@end

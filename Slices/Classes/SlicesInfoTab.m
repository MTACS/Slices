//
//  SlicesInfoTab.m
//  Slices
//
//  Created by DF on 2/18/25.
//

#import "SlicesInfoTab.h"

@interface SlicesInfoTab ()
@end

@implementation SlicesInfoTab
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)close:(NSButton *)sender {
    NSInteger index = [self.collectionView indexPathForItem:self].item;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SlicesCloseTab" object:nil userInfo:@{@"index": [NSNumber numberWithInteger:index]}];
}
@end

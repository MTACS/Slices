//
//  SlicesInfoWindow.h
//  Slices
//
//  Created by DF on 2/5/25.
//

#import <Cocoa/Cocoa.h>
#import "SlicesTreeNode.h"
#import "SlicesInfoTab.h"
#import "NSObject+Slices.h"
#import "SlicesTextView.h"
#import "SlicesTextStorage.h"
#import "SlicesLayoutManager.h"

@interface SlicesInfoWindow : NSWindow <NSCollectionViewDelegate, NSCollectionViewDataSource>
@property IBOutlet NSCollectionView *tabCollection;
@property (strong) IBOutlet SlicesTextView *textView;
@property (strong) IBOutlet NSButton *viewControllerButton;
@property (nonatomic, strong, retain) NSObject *object;
@property (nonatomic, retain) NSMutableArray *tabs;
@property (nonatomic) NSInteger selectedTab;
@property (nonatomic, retain) SlicesCodeString *codeString;
- (void)reloadTabs;
@end

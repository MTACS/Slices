//
//  SlicesInfoWindow.m
//  Slices
//
//  Created by DF on 2/5/25.
//

#import "SlicesInfoWindow.h"
#import "SlicesInfoWindowController.h"

@interface Slices : NSObject
// @property (nonatomic, retain) SlicesInfoWindowController *infoWindowController;
+ (id)sharedInstance;
@end

@implementation SlicesInfoWindow {
    SlicesTextStorage *_textStorage;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSDictionary *finderDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.mtac.refinder"];
    
    [self setStyleMask:self.styleMask|NSWindowStyleMaskFullSizeContentView];
    NSVisualEffectView *vibrant = [[NSClassFromString(@"NSVisualEffectView") alloc] initWithFrame:[[self contentView] bounds]];
    [vibrant setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [vibrant setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
    [vibrant setMaterial:(NSVisualEffectMaterial)[[finderDefaults objectForKey:@"selectedBlurStyle"] integerValue]];
    [[self contentView] addSubview:vibrant positioned:NSWindowBelow relativeTo:nil];
    
    self.selectedTab = 0;
    self.tabs = [NSMutableArray new];
    self.codeString = [SlicesCodeString new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTabs) name:@"SlicesReloadTabs" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusTab:) name:@"SlicesFocusTab" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTab:) name:@"SlicesCloseTab" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addItem:) name:@"SlicesAddObjectInfo" object:nil];
    
    NSCollectionViewFlowLayout *layout = [[NSCollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = NSCollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    [self.tabCollection setDelegate:self];
    [self.tabCollection setDataSource:self];
    [self.tabCollection setSelectable:YES];
    [self.tabCollection setCollectionViewLayout:layout];
    [self.tabCollection registerNib:[[NSNib alloc] initWithNibNamed:@"SlicesInfoTab" bundle:[NSBundle bundleForClass:self.class]] forItemWithIdentifier:@"SlicesInfoTab"];
    [[self.tabCollection enclosingScrollView] setScrollerInsets:NSEdgeInsetsMake(0, 0, 80, 0)];

    [self.textView checkTextInDocument:nil];
    
    _textStorage = [[SlicesTextStorage alloc] init];
    _textStorage.content = self.codeString;
    [_textStorage setFont:[NSFont systemFontOfSize:16]];
    [_textStorage addLayoutManager:self.textView.layoutManager];
    
}
- (void)makeKeyWindow {
    [super makeKeyWindow];
    
    [self reloadTabs];
}
- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSIndexPath *indexPath = [[indexPaths allObjects] firstObject];
    NSInteger index = indexPath.item;
    self.selectedTab = index;
    
    id object = [self.tabs objectAtIndex:index];
    
    NSString *methodString = [object fp_shortMethodDescription];
    
    NSString *ivarString = [object fp_ivarDescription];
    
    self.codeString.string = [NSString stringWithFormat:@"%@\n\n%@", methodString, ivarString];
    [_textStorage setContent:self.codeString];
    
    if ([object isKindOfClass:[NSView class]]) {
        [self.viewControllerButton setTitle:@"Show Parent View Controller"];
    } else if ([object isKindOfClass:[NSWindow class]]) {
        [self.viewControllerButton setTitle:@"Show Content View Controller"];
    }
    
    [self reloadTabs];
}
- (nonnull NSCollectionViewItem *)collectionView:(nonnull NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SlicesInfoTab *item = [collectionView makeItemWithIdentifier:@"SlicesInfoTab" forIndexPath:indexPath];
    
    id object = [self.tabs objectAtIndex:indexPath.item];
    NSString *title = [object description];
    item.titleLabel.stringValue = title;
    return item;
}
- (void)collectionView:(NSCollectionView *)collectionView willDisplayItem:(NSCollectionViewItem *)item forRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.selectedTab) {
        ((SlicesInfoTab *)item).separatorLine.hidden = NO;
    } else {
        ((SlicesInfoTab *)item).separatorLine.hidden = YES;
    }
}
- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSSize returnSize;
    if (self.tabs.count == 0) {
        returnSize = NSZeroSize;
    } else {
        NSString *descriptionString = [[self.tabs objectAtIndex:indexPath.item] description];
        CGFloat textWidth = [NSTextField labelWithString:descriptionString].intrinsicContentSize.width;
        returnSize = NSMakeSize(textWidth + 90, 60);
    }
    return returnSize;
}
- (NSInteger)collectionView:(nonnull NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.tabs count];
}
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return 1;
}
- (void)reloadTabs {
    [self.tabCollection reloadSections:[NSIndexSet indexSetWithIndex:0]];
}
- (void)addItem:(NSNotification *)notification {
    id object = notification.object;
    if (![self.tabs containsObject:object]) {
        [self.tabs addObject:object];
    }
    [self reloadTabs];
    
    NSInteger index = [self.tabs indexOfObject:self.tabs.lastObject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SlicesFocusTab" object:nil userInfo:@{@"selectedTab": [NSNumber numberWithInteger:index]}];
}
- (void)focusTab:(NSNotification *)notification {
    if (self.tabs.count > 0) {
        NSDictionary *infoDict = [notification userInfo];
        NSInteger index = [[infoDict objectForKey:@"selectedTab"] integerValue];
        [self selectTabAtIndex:index];
    }
}
- (void)closeTab:(NSNotification *)notification {
    if (self.tabs.count > 0) {
        NSDictionary *infoDict = [notification userInfo];
        NSInteger index = [[infoDict objectForKey:@"index"] integerValue];
        
        NSArray *reversedArray = [[self.tabs reverseObjectEnumerator] allObjects];
        
        id object = [reversedArray objectAtIndex:index];
        
        [self.tabs removeObjectAtIndex:[self.tabs indexOfObject:object]];
        [self reloadTabs];
        
        if ((index - 1) <= self.tabs.count) {
            [self selectTabAtIndex:index - 1];
        }
    }
}
- (void)selectTabAtIndex:(NSInteger)index {
    NSRect selectionRect = [self.tabCollection frameForItemAtIndex:index];
    [self.tabCollection scrollRectToVisible:selectionRect];
    
    if (index < self.tabs.count) {
        NSIndexPath *focusedIndex = [NSIndexPath indexPathForItem:index inSection:0];
        NSSet *indexSet = [NSSet setWithObject:focusedIndex];
        [self.tabCollection selectItemsAtIndexPaths:indexSet scrollPosition:NSCollectionViewScrollPositionCenteredHorizontally];
        SlicesInfoTab *tabItem = (SlicesInfoTab *)[self.tabCollection itemAtIndex:0];
        [tabItem becomeFirstResponder];
        
        id object = [self.tabs objectAtIndex:self.selectedTab];
        
        if ([object isKindOfClass:[NSView class]]) {
            [self.viewControllerButton setTitle:@"Show Parent View Controller"];
        } else if ([object isKindOfClass:[NSWindow class]]) {
            [self.viewControllerButton setTitle:@"Show Content View Controller"];
        }
    }
    
    self.selectedTab = index;
    [self reloadTabs];
    
    [self collectionView:self.tabCollection didSelectItemsAtIndexPaths:[NSSet setWithObject:[NSIndexPath indexPathForItem:index inSection:0]]];
}
- (IBAction)viewControllerClicked:(NSButton *)sender {
    id object = [self.tabs objectAtIndex:self.selectedTab];
    
    NSViewController *infoController;
    if ([object isKindOfClass:[NSView class]]) {
        infoController = [(NSView *)object parentViewController];
    } else if ([object isKindOfClass:[NSWindow class]]) {
        infoController = [(NSWindow *)object contentViewController];
    }
    
    if (infoController) {
        if (![self.tabs containsObject:infoController]) {
            [self.tabs addObject:infoController];
            [self reloadTabs];
            [self selectTabAtIndex:[self.tabs indexOfObject:infoController]];
        }
    }
}
/* - (IBAction)viewControllerInfo:(NSButton *)sender {
    NSViewController *infoController;
    if ([self.object isKindOfClass:[NSView class]]) {
        infoController = [(NSView *)self.object parentViewController];
    } else if ([self.object isKindOfClass:[NSWindow class]]) {
        infoController = [(NSWindow *)self.object contentViewController];
    }
    
    SlicesInfoWindowController *infoWindowController = [[SlicesInfoWindowController alloc] initWithWindowNibName:@"SlicesInfoWindowController"];
    
    SlicesInfoWindow *infoWindow = (SlicesInfoWindow *)infoWindowController.window;
    
    [infoWindow makeKeyAndOrderFront:nil];
}
- (void)updateInfoWithObject:(id)object {
    [self setObject:object];
    
    NSLog(@"[SLICES] -> Methods -> %@, Ivars -> %@", [object fp_methodDescription], [object fp_ivarDescription]);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([object isKindOfClass:[NSView class]]) {
        if ([object parentViewController] != nil) {
            [self.viewControllerButton setTitle:[NSString stringWithFormat:@"%@", [object parentViewController]]];
        } else {
            self.viewControllerButton.hidden = YES;
        }
    } else if ([object isKindOfClass:[NSWindow class]]) {
        [self.viewControllerButton setTitle:[NSString stringWithFormat:@"%@", [object contentViewController]]];
    }
    
    self.propertiesDict = [NSDictionary dictionaryWithDictionary:[(NSObject *)object properties]];
    self.ivarDict = [NSDictionary dictionaryWithDictionary:[object ivars]];
    self.methodArray = [NSArray arrayWithArray:[object methods]];
    
    NSMutableDictionary *methodDict = [NSMutableDictionary new];
    for (NSString *method in self.methodArray) {
        [methodDict setObject:@"-" forKey:method];
    }
    
    NSMutableArray *keysDict = [NSMutableArray new];
    if (self.propertiesDict.allKeys.count != 0) {
        [keysDict addObject:@"slices_propertyHeader"];
    }
    for (NSString *key in self.propertiesDict.allKeys) {
        [keysDict addObject:key];
    }
    if (self.ivarDict.allKeys.count != 0) {
        [keysDict addObject:@"slices_ivarHeader"];
    }
    for (NSString *key in self.ivarDict.allKeys) {
        [keysDict addObject:key];
    }
    if (methodDict.allKeys.count != 0) {
        [keysDict addObject:@"slices_methodHeader"];
    }
    for (NSString *key in methodDict.allKeys) {
        [keysDict addObject:key];
    }
    
    self.keysArray = keysDict;
    
    NSMutableDictionary *finalDict = [NSMutableDictionary new];
    [finalDict addEntriesFromDictionary:methodDict];
    [finalDict addEntriesFromDictionary:self.ivarDict];
    [finalDict addEntriesFromDictionary:self.propertiesDict];
    
    self.objectDict = finalDict;
    
    self.rowCount = [[finalDict allKeys] count];
    
    [self setTitle:[object description]];
    
    [self.tableView reloadData];
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.rowCount;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    
    NSString *key = [self.keysArray objectAtIndex:row];
    
    if ([key isEqualToString:@"slices_propertyHeader"]) {
        NSTableCellView *cell = [tableView makeViewWithIdentifier:@"headerCell" owner:self];
        cell.textField.stringValue = @"Properties";
        return cell;
    } else if ([key isEqualToString:@"slices_ivarHeader"]) {
        NSTableCellView *cell = [tableView makeViewWithIdentifier:@"headerCell" owner:self];
        cell.textField.stringValue = @"Ivars";
        return cell;
    } else if ([key isEqualToString:@"slices_methodHeader"]) {
        NSTableCellView *cell = [tableView makeViewWithIdentifier:@"headerCell" owner:self];
        cell.textField.stringValue = @"Methods";
        return cell;
    } else {
        SlicesObjectCell *cell = [tableView makeViewWithIdentifier:@"descriptionCell" owner:self];
        cell.textField.stringValue = key;
        id targetObject = [self.objectDict objectForKey:key];
        if (targetObject) {
            cell.object = targetObject;
        }
        if ([targetObject description]) {
            if (![[targetObject description] isEqualToString:@"-"]) {
                cell.objectButton.title = [targetObject description];
                if ([key containsString:@"@"]) {
                    cell.objectButton.object = targetObject;
                }
                [cell.objectButton setHidden:NO];
                [cell.objectButton setAlphaValue:1.0];
            } else {
                [cell.objectButton setHidden:YES];
                [cell.objectButton setAlphaValue:0.0];
            }
        }
        return cell;
    }
    return nil;
}
- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
    return NO;
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    NSString *key = [self.keysArray objectAtIndex:row];
    if ([key isEqualToString:@"slices_propertyHeader"] || [key isEqualToString:@"slices_ivarHeader"] || [key isEqualToString:@"slices_methodHeader"]) {
        return 44;
    }
    return 30;
}
- (void)reloadData {
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay:YES];
} */
@end

//
//  SlicesInfoTab.h
//  Slices
//
//  Created by DF on 2/18/25.
//

#import <Cocoa/Cocoa.h>

@interface SlicesInfoTab : NSCollectionViewItem
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSBox *separatorLine;
@property (weak) IBOutlet NSButton *closeButton;
@end

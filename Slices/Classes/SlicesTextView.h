//
//  SlicesTextView.h
//  Slices
//
//  Created by DF on 2/18/25.
//

#import <Cocoa/Cocoa.h>
#import "SlicesTextStorage.h"
#import "SlicesLayoutManager.h"

@interface SlicesTextView : NSTextView <NSTextFinderClient>
@property (nonatomic) NSTextFinder *textFinder;
@end

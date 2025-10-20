//
//  SlicesTextStorage.h
//  Slices
//
//  Created by DF on 2/24/25.
//

#import <Cocoa/Cocoa.h>
#import "SlicesCodeString.h"

@interface SlicesTextStorage : NSTextStorage
@property (nonatomic, retain) SlicesCodeString *content;
@property (nonatomic, retain) NSFont *font;
- (void)setContent:(SlicesCodeString *)content;
@end

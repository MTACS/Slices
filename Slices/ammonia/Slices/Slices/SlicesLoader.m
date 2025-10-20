//
//  SlicesLoader.m
//  Slices
//
//  Created by DF on 10/13/25.
//

#import "SlicesLoader.h"

NSUserDefaults *defaults;

@implementation SlicesLoader
+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *bundlePath = [[[[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:@"com.mtac.SlicesApplication"].absoluteString stringByAppendingString:@"/Contents/Resources/Slices.bundle/Contents/MacOS/Slices"] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        NSLog(@"[SLICES] Path -> %@", bundlePath);
        
        dlopen([bundlePath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_LAZY);
        
        Slices *slices = [objc_getClass("Slices") sharedInstance];
        [slices loadSlices];
        [slices showSliceInspector:nil];
    });
}
@end

ZKSwizzleInterface(SL_NSView, NSView, NSObject)
@implementation SL_NSView
- (id)init {
    self = ZKOrig(id);
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slices_deselect) name:@"SlicesDeselect" object:nil];
    }
    return self;
}
- (void)slices_select {
    ((NSView *)self).layer.backgroundColor = [[NSColor systemCyanColor] colorWithAlphaComponent:0.5].CGColor;
    ((NSView *)self).wantsLayer = YES;
}
- (void)slices_deselect {
    ((NSView *)self).layer.backgroundColor = [NSColor clearColor].CGColor;
    ((NSView *)self).wantsLayer = NO;
}
@end

__attribute__((constructor)) static void init(void) {
    @autoreleasepool {
        defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.mtac.slices"];
    }
}

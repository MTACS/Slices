//
//  SlicesTreeNode.m
//  Slices
//
//  Created by DF on 1/24/25.
//

#import "SlicesTreeNode.h"

@implementation NSView (Slices)
- (NSViewController *)parentViewController {
    NSResponder *responder = self.nextResponder;
    while (responder) {
        if ([responder isKindOfClass:[NSViewController class]]) {
            return (NSViewController *)responder;
        }
        responder = responder.nextResponder;
    }
    return nil;
}
@end

@implementation SlicesTreeNode
- (instancetype)initWithView:(nonnull NSView *)view {
    self = [super init];
    if (self) {
        self.view = view;
        self.subviews = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)copyClassName {
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:NSStringFromClass(self.view.class) forType:NSPasteboardTypeString];
}
- (NSString *)title {
    if ([self.view isKindOfClass:[NSWindow class]]) {
        NSWindow *window = (NSWindow*)self.view;
        return window.title;
    }
    return @"Unknown";
}
- (NSString *)description {
    /* NSString *descriptor = [[NSString alloc] initWithFormat:@"%@", NSStringFromClass(self.view.class)];
        return descriptor; */
    // NSString *viewDescription = self.view.description;
    
    NSString *debugDescription = [self.view description];
    NSString *className = NSStringFromClass(self.view.class);
    return [NSString stringWithFormat:@"%@ %@", (className != NULL) ? className : @"", (debugDescription != nil) ? debugDescription : @""];
}
- (NSDictionary *)ivars {
    return [self.view ivars];
}
- (NSDictionary *)properties {
    return [self.view properties];
}
- (NSImage *)image {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/Application Support/MacEnhance/Plugins/Slices.bundle/Contents/Resources"];
    NSString *imageName;
    if ([self.view isKindOfClass:[NSWindow class]]) {
        imageName = @"NSWindow_32_Normal";
    } else  if ([self.view isKindOfClass:[NSPopUpButton class]]) {
        imageName = @"NSPopUp-Push_32_Normal";
    } else if ([self.view isKindOfClass:[NSButton class]]) {
        imageName = @"NSButton-Push_32";
    } else  if ([self.view isKindOfClass:[NSTextField class]]) {
        imageName = @"NSTextField_32_Normal";
    } else  if ([self.view isKindOfClass:[NSSecureTextField class]]) {
        imageName = @"NSSecureTextField_32_Normal";
    } else  if ([self.view isKindOfClass:[NSSwitch class]]) {
        imageName = @"NSSwitch_32_Normal";
    } else  if ([self.view isKindOfClass:[NSStepper class]]) {
        imageName = @"NSStepper_32_Normal";
    } else  if ([self.view isKindOfClass:[NSDatePicker class]]) {
        imageName = @"NSDatePicker_32_Normal";
    } else  if ([self.view isKindOfClass:[NSSegmentedControl class]]) {
        imageName = @"NSSegmentedControl_32_Normal";
    } else  if ([self.view isKindOfClass:[NSColorWell class]]) {
        imageName = @"NSColorWell_32_Normal";
    } else  if ([self.view isKindOfClass:[NSPanel class]]) {
        imageName = @"NSPanel_32_Normal";
    } else  if ([self.view isKindOfClass:[NSPathControl class]]) {
        imageName = @"NSPathControl_32_Normal";
    } else  if ([self.view isKindOfClass:[NSLevelIndicator class]]) {
        imageName = @"NSLevelIndicator_32_Normal";
    } else  if ([self.view isKindOfClass:[NSSplitViewController class]]) {
        imageName = @"NSSplitViewControllerHorizontal_32_Normal";
    } else  if ([self.view isKindOfClass:[NSProgressIndicator class]]) {
        NSProgressIndicator *progress = (NSProgressIndicator*)self.view;
        switch (progress.style) {
            case NSProgressIndicatorStyleBar: {
                if (progress.indeterminate) {
                    imageName = @"NSProgressIndicator-Bar-Indeterminate_32_Normal";
                } else {
                    imageName = @"NSProgressIndicator-Bar-Determinate_32_Normal";
                }
            } break;
            case NSProgressIndicatorStyleSpinning: {
                if (progress.indeterminate) {
                    imageName = @"NSProgressIndicator-Circular-Indeterminate_32_Normal";
                } else {
                    imageName = @"NSProgressIndicator-Circular-Determinate_32_Normal";
                }
            } break;
        }
    } else if ([self.view isKindOfClass:[NSSlider class]]) {
        NSSlider *slider = (NSSlider*)self.view;
        switch (slider.sliderType) {
            case NSSliderTypeLinear: {
                if (slider.vertical) {
                    if (slider.numberOfTickMarks) {
                        imageName = @"NSSlider-Vertical-Ticks_32_Normal";
                    } else {
                        imageName = @"NSSlider-Vertical_32_Normal";
                    }
                } else {
                    if (slider.numberOfTickMarks) {
                        imageName = @"NSSlider-Horizontal-Ticks_32_Normal";
                    } else {
                        imageName = @"NSSlider-Horizontal_32_Normal";
                    }
                }
            } break;
            case NSSliderTypeCircular: {
                imageName = @"NSSlider-Circular_32_Normal";
            } break;
        }
    }
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:imageName ofType:@"png"]];
    return image;
}
@end

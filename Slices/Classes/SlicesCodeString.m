//
//  SlicesCodeString.m
//  Slices
//
//  Created by DF on 2/24/25.
//

#import "SlicesCodeString.h"

@implementation SlicesCodeString {
    NSMutableString *_string;
}
- (id)init {
    self = [super init];
    if (self) {
        _string = [NSMutableString new];
    }
    return self;
}
- (NSString *)string {
    return _string;
}
- (NSUInteger)length {
    return _string.length;
}
- (unichar)characterAtIndex:(NSUInteger)index {
    return [_string characterAtIndex:index];
}
- (void)getCharacters:(unichar *)buffer range:(NSRange)aRange {
    [_string getCharacters:buffer range:aRange];
}
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if (aString) {
        [_string replaceCharactersInRange:range withString:aString];
    }
}
- (void)enumerateCodeInRange:(NSRange)range usingBlock:(void (^)(NSRange range, SlicesCodeType type))block {

    block(range, SlicesCodeTypeText);

    NSDictionary *components = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"objective-c" ofType:@"plist"]][@"components"];
    
    for (NSString *key in components) {
        NSDictionary *dict = components[key];
        if (dict) {
              NSRegularExpressionOptions options = 0;
              if (dict[@"options"]) {
                options = [dict[@"options"] intValue];
              }
              NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:dict[@"regex"] options:0 error:nil];
              NSArray* matches = [regex matchesInString:self options:0 range:range];
              for (NSTextCheckingResult *match in matches) {
                    NSRange finalRange = match.range;
                    /* if (dict[@"group"]) {
                        finalRange = [match rangeAtIndex:[dict[@"group"] intValue]];
                    } */
                    if ([key isEqual:@"keywords"]) {
                        block(finalRange, SlicesCodeTypeKeyword);
                    } else if ([key isEqual:@"classes"]) {
                        block(finalRange, SlicesCodeTypeClass);
                    } else if ([key isEqual:@"logos"]) {
                        block(finalRange, SlicesCodeTypeLogos);
                    } else if ([key isEqual:@"preprocessors"]) {
                        block(finalRange, SlicesCodeTypePragma);
                    } else if ([key isEqual:@"imports"]) {
                        block(finalRange, SlicesCodeTypeImport);
                    } else if ([key isEqual:@"numbers"]) {
                        block(finalRange, SlicesCodeTypeNumber);
                    } else if ([key isEqual:@"urls"]) {
                        block(finalRange, SlicesCodeTypeURL);
                    } else if ([key isEqual:@"uikit"]) {
                        block(finalRange, SlicesCodeTypeUIKit);
                    } else if ([key isEqual:@"attributes"]) {
                        block(finalRange, SlicesCodeTypeAttribute);
                    } else if ([key isEqual:@"foundation"]) {
                        block(finalRange, SlicesCodeTypeFoundation);
                    } else if ([key isEqual:@"strings"]) {
                        block(finalRange, SlicesCodeTypeString);
                    } else if ([key isEqual:@"characters"]) {
                        block(finalRange, SlicesCodeTypeCharacter);
                    } else if ([key isEqual:@"literals"]) {
                        block(finalRange, SlicesCodeTypeLiterals);
                    } else if ([key isEqual:@"builtin"]) {
                        block(finalRange, SlicesCodeTypeBuiltIn);
                    } else if ([key isEqual:@"brackets"]) {
                        block(finalRange, SlicesCodeTypeBrackets);
                    } else if ([key isEqual:@"braces"]) {
                        block(finalRange, SlicesCodeTypeBraces);
                    }else if ([key isEqual:@"comments"] || [key isEqual:@"documentation_markup"] || [key isEqual:@"documentation_markup_keywords"]) {
                    block(finalRange, SlicesCodeTypeComment);
                }
            }
        }
    }
}
@end

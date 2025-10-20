//
//  SlicesTextStorage.m
//  Slices
//
//  Created by DF on 2/24/25.
//

#import "SlicesTextStorage.h"

@implementation SlicesTextStorage {
    NSMutableAttributedString *_cache;
}
- (id)init {
    self = [super init];
    if (self) {
        _cache = [NSMutableAttributedString new];
    }
    return self;
}
- (void)reloadContent:(NSNotification *)notification {
    [self setContent:_content];
}
- (void)setContent:(SlicesCodeString *)content {
    _content = content;
    [self beginEditing];
    NSInteger oldLength = _cache.length;
    [_cache replaceCharactersInRange:NSMakeRange(0, oldLength) withString:_content];
    [self edited:NSTextStorageEditedCharacters range:NSMakeRange(0, oldLength) changeInLength:(NSInteger)_content.length - oldLength];
    [self updateAttributesForChangedRange: NSMakeRange(0, _content.length)];
    [self endEditing];
}
- (void)setFont:(NSFont *)font {
    _font = font;

    [self beginEditing];
    [self updateAttributesForChangedRange:NSMakeRange(0, self.content.length)];
    [self endEditing];
}
- (NSString *)string {
    return _cache.string;
}
- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_cache attributesAtIndex:location effectiveRange:range];
}
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [self.content replaceCharactersInRange:range withString:str];
    [_cache replaceCharactersInRange:range withString:str];

    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}
- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [_cache setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}
- (void)processEditing {
    [self updateAttributesForChangedRange: self.editedRange];
    [super processEditing];
}
- (NSColor *)colorFromHexString:(NSString *)hexString {
    NSString *firstCharacter = [hexString substringToIndex:1];
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;

    if (nil != hexString) {
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:[firstCharacter isEqualToString:@"#"] ? 1 : 0];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits

    result = [NSColor
    colorWithRed:(CGFloat)redByte / 0xff
    green:(CGFloat)greenByte / 0xff
    blue:(CGFloat)blueByte / 0xff
    alpha:1.0];
    return result;
}
- (NSColor *)textColorForCodeType:(SlicesCodeType)type {
    NSDictionary *themeDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"default" ofType:@"plist"]];
    
    switch (type) {
        default:
        case SlicesCodeTypeText:
            return [NSColor labelColor];

        case SlicesCodeTypeKeyword: {
            NSString *keywords = [themeDict objectForKey:@"keywords"];
            NSColor *keywordColor = [self colorFromHexString:keywords];
            
            return (keywordColor) ? keywordColor : [NSColor systemRedColor];
        }
        case SlicesCodeTypeClass: {
            NSString *classes = [themeDict objectForKey:@"classes"];
            NSColor *classesColor = [self colorFromHexString:classes];
            
            return (classesColor) ? classesColor : [NSColor systemPinkColor];
        }
        case SlicesCodeTypePragma:
            return [NSColor systemBlueColor];

        case SlicesCodeTypeNumber: {
            NSString *numbers = [themeDict objectForKey:@"numbers"];
            NSColor *numbersColor = [self colorFromHexString:numbers];
            
            return (numbersColor) ? numbersColor : [NSColor systemTealColor];
        }
        case SlicesCodeTypeURL: {
            NSString *urls = [themeDict objectForKey:@"urls"];
            NSColor *urlsColor = [self colorFromHexString:urls];
            
            return (urlsColor) ? urlsColor : [NSColor systemPurpleColor];
        }
        case SlicesCodeTypeAttribute: {
            NSString *attributes = [themeDict objectForKey:@"attributes"];
            NSColor *attributesColor = [self colorFromHexString:attributes];
            
            return (attributesColor) ? attributesColor : [NSColor systemBlueColor];
        }
        case SlicesCodeTypeString: {
            NSString *strings = [themeDict objectForKey:@"strings"];
            NSColor *stringsColor = [self colorFromHexString:strings];
            
            return (stringsColor) ? stringsColor : [NSColor systemTealColor];
        }
        case SlicesCodeTypeComment: {
            NSString *comments = [themeDict objectForKey:@"comments"];
            NSColor *commentsColor = [self colorFromHexString:comments];
            
            return (commentsColor) ? commentsColor : [NSColor secondaryLabelColor];
        }
        case SlicesCodeTypeCharacter: {
            NSString *characters = [themeDict objectForKey:@"characters"];
            NSColor *charactersColor = [self colorFromHexString:characters];
            
            return (charactersColor) ? charactersColor : [NSColor systemYellowColor];
        }
        case SlicesCodeTypeFoundation: {
            NSString *foundation = [themeDict objectForKey:@"foundation"];
            NSColor *foundationColor = [self colorFromHexString:foundation];
            
            return (foundationColor) ? foundationColor : [NSColor systemOrangeColor];
        }
        case SlicesCodeTypeLogos: {
            NSString *logos = [themeDict objectForKey:@"foundation"];
            NSColor *logosColor = [self colorFromHexString:logos];
            
            return (logosColor) ? logosColor : [NSColor systemTealColor];
        }
        case SlicesCodeTypeImport: {
            NSString *imports = [themeDict objectForKey:@"imports"];
            NSColor *importsColor = [self colorFromHexString:imports];
            
            return (importsColor) ? importsColor : [NSColor systemGreenColor];
        }
        case SlicesCodeTypeUIKit: {
            NSString *uikit = [themeDict objectForKey:@"uikit"];
            NSColor *uikitColor = [self colorFromHexString:uikit];
            
            return (uikitColor) ? uikitColor : [NSColor systemGreenColor];
        }
        case SlicesCodeTypeBrackets: {
            NSString *brackets = [themeDict objectForKey:@"brackets"];
            NSColor *bracketsColor = [self colorFromHexString:brackets];
            
            return (bracketsColor) ? bracketsColor : [NSColor systemGreenColor];
        }
        case SlicesCodeTypeBraces: {
            NSString *braces = [themeDict objectForKey:@"braces"];
            NSColor *bracesColor = [self colorFromHexString:braces];
            
            return (bracesColor) ? bracesColor : [NSColor systemGreenColor];
        }
        case SlicesCodeTypeLiterals: {
            NSString *literals = [themeDict objectForKey:@"literals"];
            NSColor *literalsColor = [self colorFromHexString:literals];
            
            return (literalsColor) ? literalsColor : [NSColor systemGreenColor];
        }
        case SlicesCodeTypeBuiltIn: {
            NSString *builtin = [themeDict objectForKey:@"builtin"];
            NSColor *builtinColor = [self colorFromHexString:builtin];
            
            return (builtinColor) ? builtinColor : [NSColor systemGreenColor];
        }
    }
}
- (void)updateAttributesForChangedRange:(NSRange)range {
    range = [self.content paragraphRangeForRange:range];

    [self setAttributes:@{} range:range];

    if (self.font) {
        [self addAttribute:NSFontAttributeName value:self.font range:range];
    }

    [self.content enumerateCodeInRange:range usingBlock:^(NSRange range, SlicesCodeType type) {
        [self addAttribute:NSForegroundColorAttributeName value:[self textColorForCodeType: type] range:range];
    }];
}
@end

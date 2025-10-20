//
//  SlicesCodeString.h
//  Slices
//
//  Created by DF on 2/24/25.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SlicesCodeTypeKeyword,
    SlicesCodeTypeClass,
    SlicesCodeTypePragma,
    SlicesCodeTypeNumber,
    SlicesCodeTypeURL,
    SlicesCodeTypeAttribute,
    SlicesCodeTypeString,
    SlicesCodeTypeComment,
    SlicesCodeTypeText,
    SlicesCodeTypeFoundation,
    SlicesCodeTypeCharacter,
    SlicesCodeTypeLogos,
    SlicesCodeTypeImport,
    SlicesCodeTypeUIKit,
    SlicesCodeTypeBrackets,
    SlicesCodeTypeBraces,
    SlicesCodeTypeLiterals,
    SlicesCodeTypeBuiltIn,
} SlicesCodeType;

@interface SlicesCodeString : NSMutableString
- (void)enumerateCodeInRange:(NSRange)range usingBlock:(void (^)(NSRange range, SlicesCodeType type))block;
- (NSString *)string;
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)string;
@end

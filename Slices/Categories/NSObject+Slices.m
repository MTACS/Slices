//
//  NSObject+Slices.m
//  Slices
//
//  Created by DF on 2/6/25.
//

#import "NSObject+Slices.h"

NSString* commonTypes(NSString *atype, NSString *inName) {
    BOOL isRef = NO;
    BOOL isPointer = NO;
    BOOL isCArray = NO;
    BOOL isConst = NO;
    BOOL isOut = NO;
    BOOL isByCopy = NO;
    BOOL isByRef = NO;
    BOOL isOneWay = NO;

      if ([atype rangeOfString:@"r"].location == 0) {
        isConst = YES;
        atype = [atype substringFromIndex:1];
      }

      if ([atype isEqual:@"^?"]) {
        atype = @"/*function pointer*/void*";
      }

      if ([atype rangeOfString:@"^"].location != NSNotFound) {
        isPointer = YES;
        atype = [atype stringByReplacingOccurrencesOfString:@"^" withString:@""];
      }

    int arrayCount = 0;
    if ([atype rangeOfString:@"["].location == 0) {
        isCArray = YES;

        if ([atype rangeOfString:@"{"].location != NSNotFound) {
            atype = [atype stringByReplacingOccurrencesOfString:@"[" withString:@""];
            atype = [atype stringByReplacingOccurrencesOfString:@"]" withString:@""];
            int firstBrace = [atype rangeOfString:@"{"].location;
            arrayCount = [[atype stringByReplacingCharactersInRange:NSMakeRange(firstBrace, atype.length - firstBrace) withString:@""] intValue];
            atype = [atype stringByReplacingCharactersInRange:NSMakeRange(0, firstBrace) withString:@""];
        } else {
            isCArray = NO;
            NSRegularExpressionOptions opt = 0;

            __block NSString* tempString = [atype mutableCopy];
            __block NSMutableArray* numberOfArray = [NSMutableArray array];
            while ([tempString rangeOfString:@"["].location != NSNotFound) {
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\[([^\\[^\\]]+)\\])" options:opt error:nil];
                [regex enumerateMatchesInString:tempString options:0 range:NSMakeRange(0, [tempString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL* stop) {
                    for (int i = 1; i < [result numberOfRanges]; i++) {
                        NSString *foundString = [tempString substringWithRange:[result rangeAtIndex:i]];
                        tempString = [tempString stringByReplacingOccurrencesOfString:foundString withString:@""];
                        [numberOfArray addObject:foundString];  // e.g. [2] or [100c]
                        break;
                    }
                }];
            }

            NSString *stringContainingType;
            for (NSString *aString in numberOfArray) {
                NSCharacterSet *set = [[NSCharacterSet
            characterSetWithCharactersInString:
                @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ@#$%^&*()!<>?:\"|}{"]
            invertedSet];

                if ([aString rangeOfCharacterFromSet:set].location != NSNotFound) {
                    stringContainingType = aString;
                    break;
                }
            }

            [numberOfArray removeObject:stringContainingType];
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:
              @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ@#$%^&*()!<>?:\"|}{"];
            int letterLocation = [stringContainingType rangeOfCharacterFromSet:set].location == NSNotFound ? -1 : [stringContainingType rangeOfCharacterFromSet:set].location;
            NSString* outtype = letterLocation == -1 ? stringContainingType : [stringContainingType substringFromIndex:letterLocation];
            outtype = [outtype stringByReplacingOccurrencesOfString:@"]" withString:@""];
            stringContainingType = [stringContainingType stringByReplacingOccurrencesOfString:outtype withString:@""];
            for (NSString* subarr in numberOfArray) {
                stringContainingType = [subarr stringByAppendingString:stringContainingType];
            }
            atype = outtype;
            if ([atype isEqual:@"v"]) {
                atype = @"void*";
            }
            if (inName != nil) {
                inName = [inName stringByAppendingString:stringContainingType];
            }
        }
    }

    if ([atype rangeOfString:@"=}"].location != NSNotFound && [atype rangeOfString:@"{"].location == 0 && [atype rangeOfString:@"?"].location == NSNotFound && [atype rangeOfString:@"\""].location == NSNotFound) {
        NSString* writeString = [atype stringByReplacingOccurrencesOfString:@"{" withString:@""];
        writeString = [writeString stringByReplacingOccurrencesOfString:@"}" withString:@""];
        writeString = [writeString stringByReplacingOccurrencesOfString:@"=" withString:@""];
        NSString *constString = isConst ? @"const " : @"";
        writeString = [NSString stringWithFormat:@"typedef %@struct %@* ", constString, writeString];

        atype = [atype stringByReplacingOccurrencesOfString:@"{__" withString:@""];
        atype = [atype stringByReplacingOccurrencesOfString:@"{" withString:@""];
        atype = [atype stringByReplacingOccurrencesOfString:@"=}" withString:@""];

        if ([atype rangeOfString:@"_"].location == 0) {
            atype = [atype substringFromIndex:1];
        }

        isRef = YES;
        isPointer = NO;  // -> Ref
    }

    if ([atype rangeOfString:@"b"].location == 0 && atype.length > 1) {
      NSCharacterSet* numberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
      if ([atype rangeOfCharacterFromSet:numberSet].location == 1) {
          NSString* bitValue = [atype substringFromIndex:1];
          atype = @"unsigned";
          if (inName != nil) {
              inName = [inName stringByAppendingString:[NSString stringWithFormat:@" : %@", bitValue]];
          }
      }
    }

    if ([atype rangeOfString:@"N"].location == 0 &&
      ![commonTypes([atype substringFromIndex:1], nil) isEqual:[atype substringFromIndex:1]]) {
      atype = commonTypes([atype substringFromIndex:1], nil);
      atype = [NSString stringWithFormat:@"inout %@", atype];
    }

    if ([atype isEqual:@"d"]) {
      atype = @"double";
    }
    if ([atype isEqual:@"i"]) {
      atype = @"int";
    }
    if ([atype isEqual:@"f"]) {
      atype = @"float";
    }
    if ([atype isEqual:@"c"]) {
      atype = @"char";
    }
    if ([atype isEqual:@"s"]) {
      atype = @"short";
    }
    if ([atype isEqual:@"I"]) {
      atype = @"unsigned";
    }
    if ([atype isEqual:@"l"]) {
      atype = @"long";
    }
    if ([atype isEqual:@"q"]) {
      atype = @"long long";
    }
    if ([atype isEqual:@"L"]) {
      atype = @"unsigned long";
    }
    if ([atype isEqual:@"C"]) {
      atype = @"unsigned char";
    }
    if ([atype isEqual:@"S"]) {
      atype = @"unsigned short";
    }
    if ([atype isEqual:@"Q"]) {
      atype = @"unsigned long long";
    }
    if ([atype isEqual:@"B"]) {
      atype = @"BOOL";
    }
    if ([atype isEqual:@"v"]) {
      atype = @"void";
    }
    if ([atype isEqual:@"*"]) {
      atype = @"char*";
    }
    if ([atype isEqual:@":"]) {
      atype = @"SEL";
    }
    if ([atype isEqual:@"?"]) {
      atype = @"/*function pointer*/void*";
    }
    if ([atype isEqual:@"#"]) {
      atype = @"Class";
    }
    if ([atype isEqual:@"@"]) {
      atype = @"id";
    }
    if ([atype isEqual:@"@?"]) {
      atype = @"/*^block*/id";
    }
    if ([atype isEqual:@"Vv"]) {
      atype = @"void";
    }
    if ([atype isEqual:@"rv"]) {
      atype = @"const void*";
    }

    if (isRef) {
      if ([atype rangeOfString:@"_"].location == 0) {
          atype = [atype substringFromIndex:1];
      }
      atype = [atype isEqual:@"NSZone"] ? @"NSZone*" : [atype stringByAppendingString:@"Ref"];
    }

    if (isPointer) {
      atype = [atype stringByAppendingString:@"*"];
    }

    if (isConst) {
      atype = [@"const " stringByAppendingString:atype];
    }

    if (isCArray &&
      inName !=
          nil) {
      inName = [inName stringByAppendingString:[NSString stringWithFormat:@"[%d]", arrayCount]];
    }

    if (isOut) {
      atype = [@"out " stringByAppendingString:atype];
    }

    if (isByCopy) {
    atype = [@"bycopy " stringByAppendingString:atype];
    }

    if (isByRef) {
      atype = [@"byref " stringByAppendingString:atype];
    }

    if (isOneWay) {
      atype = [@"oneway " stringByAppendingString:atype];
    }
    return atype;
}

@implementation NSObject (Slices)
- (id)safeValueForKey:(NSString *)key {
   unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);

    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *propertyString = [NSString stringWithUTF8String:propertyName];

        if ([propertyString isEqualToString:key]) {
            free(properties);
            return [self valueForKey:key];
        }
    }
    
    free(properties);
    return nil;
}
- (NSDictionary *)ivars {
    unsigned int numIvars = 0;
    Ivar *ivars = class_copyIvarList([self class], &numIvars);
    NSMutableDictionary *pairs = [NSMutableDictionary new];
    for (int i = 0; i < numIvars; ++i) {
        Ivar ivar = ivars[i];
        
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        id ivarValue = [self valueForKey:ivarName];
        const char *ivarType = ivar_getTypeEncoding(ivar);
        
        NSString *ivarTypeString = NULL;
        if (ivarType) {
            ivarTypeString = commonTypes([NSString stringWithCString:ivarType encoding:NSUTF8StringEncoding], ivarName);
        }
        if ([ivarTypeString containsString:@"SpawnOrigin"]) {
            ivarTypeString = @"id";
        }
        
        // NSString *ivarClass = NSStringFromClass([ivarValue class]);
        NSString *name = [NSString stringWithFormat:@"(%@) \"%@\"", ivarTypeString, ivarName];
        [pairs setObject:ivarValue forKey:name];
    }
    free(ivars);
    return pairs;
}
- (NSDictionary *)properties {
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    NSMutableDictionary *pairs = [NSMutableDictionary new];
    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id propertyValue;
        const char *type = property_getAttributes(property);
        NSString *typeString = [NSString stringWithUTF8String:type];
        NSArray *attributes = [typeString componentsSeparatedByString:@","];
        NSString *typeAttribute = [attributes objectAtIndex:0];
        NSString *propertyType = [typeAttribute substringFromIndex:1];
        const char *rawPropertyType = [propertyType UTF8String];
        
        NSString *propertyTypeString = NULL;
        if (rawPropertyType) {
            propertyTypeString = commonTypes([NSString stringWithCString:rawPropertyType encoding:NSUTF8StringEncoding], name);
        }
        
        if (NSNotFound != [[NSString stringWithFormat:@"%s", rawPropertyType] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]].location) {
            continue;
        } else {
            propertyValue = [self safeValueForKey:name];
        }
         
        [pairs setObject:propertyValue forKey:[NSString stringWithFormat:@"(%@) \"%@\"", propertyTypeString, name]];
    }
    free(propertyArray);
    return pairs;
}
- (NSArray *)methods {
    NSMutableArray *list = [NSMutableArray new];
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(self.class, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        Method *method = &methods[i];
        [list addObject:[NSString stringWithCString: sel_getName(method_getName(*method)) encoding:NSUTF8StringEncoding]];
    }
    free(methods);
    return list;
}
@end

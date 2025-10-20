//
//  NSObject+Slices.h
//  Slices
//
//  Created by DF on 2/6/25.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Slices)
- (id)safeValueForKey:(NSString *)key;
- (NSDictionary *)properties;
- (NSDictionary *)ivars;
- (NSArray *)methods;
- (id)fp_methodDescription;
- (id)fp_ivarDescription;
- (id)fp_shortMethodDescription;
- (id)_shortMethodDescription;
- (id)_methodDescription;
- (id)__methodDescriptionForClass:(Class)arg1;
- (id)_propertyDescription;
- (id)__propertyDescriptionForClass:(Class)arg1;
- (id)_ivarDescription;
- (id)__ivarDescriptionForClass:(Class)arg1;
- (id)___methodDescriptionForSelector:(SEL)selector;
@end

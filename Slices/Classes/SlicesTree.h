//
//  SlicesTree.h
//  Slices
//
//  Created by DF on 1/24/25.
//

#import <Foundation/Foundation.h>
#import "SlicesTreeNode.h"

@interface SlicesTree : NSObject
@property (nonatomic) NSMutableArray<SlicesTreeNode *> *windows;
@end

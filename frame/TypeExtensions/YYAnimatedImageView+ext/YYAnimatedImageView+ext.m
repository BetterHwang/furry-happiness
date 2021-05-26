//
//  YYAnimatedImageView.m
//  frame
//
//  Created by apple on 2021/5/6.
//  Copyright © 2021 yl. All rights reserved.
//

#import "YYAnimatedImageView+ext.h"
#import "objc/runtime.h"

@implementation YYAnimatedImageView (DisplayFixed)

+ (void)load {
    // hook：钩子函数
    Method method1 = class_getInstanceMethod(self, @selector(displayLayer:));
    
    Method method2 = class_getInstanceMethod(self, @selector(dx_displayLayer:));
    method_exchangeImplementations(method1, method2);
}

- (void)dx_displayLayer:(CALayer *)layer {
    if ([UIImageView instancesRespondToSelector:@selector(displayLayer:)]) {
        [super displayLayer:layer];
    }
}


@end

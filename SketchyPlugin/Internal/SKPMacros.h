//
//  SKPMacros.h
//  SketchyCode
//
//  Created by Rob Visentin on 11/17/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

#ifndef SKPMacros_h
#define SKPMacros_h

#define SKPLog(fmt, ...) NSLog((@"(Sketchy Plugin) %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define SKP_SET_SUPERCLASS(name) { \
    Class superclass = objc_getClass(#name); \
    if ( superclass != nil ) { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
        class_setSuperclass(self, superclass); \
        _Pragma("clang diagnostic pop") \
    } \
}

#define SKP_ENSURE_SUPER_RESPONDS SKP_ENSURE_SUPER_RESPONDS_RET(;)

#define SKP_ENSURE_SUPER_RESPONDS_RET(ret) { \
    if ( ![[self superclass] instancesRespondToSelector:_cmd] ) { \
        SKPLog(@"ERROR: Superclass of %@ doesn't conform to %s", [self class], sel_getName(_cmd)); \
        return ret; \
    } \
}

#endif

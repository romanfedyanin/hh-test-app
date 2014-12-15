//
//  CommonMacroses.h
//  HeadHunterTestApp
//
//  Created by Roman Fedyanin on 14/12/14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#ifndef HeadHunterTestApp_CommonMacroses_h
#define HeadHunterTestApp_CommonMacroses_h

#define IPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define IPAD   UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

static inline id NULL_TO_NIL(id obj) {
    return (obj == [NSNull null]) ? nil : obj;
}

#endif

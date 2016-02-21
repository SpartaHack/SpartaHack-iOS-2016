//
//  UIColor+SpartaColor.m
//  SpartaHack 2016
//
//  Created by Chris McGrath on 1/29/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

#import "UIColor+SpartaColor.h"

@implementation UIColor (SpartaColor)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF >> 0)/255.0 alpha:1.0];
}

+(UIColor*)spartaBlack{
    return [UIColor colorWithRed:((0x030000) >> 16)/255.0 green:((0x0300) >> 8)/255.0 blue:(0x16 >> 0)/255.0 alpha:1.0];
}

+(UIColor*)spartaMutedGrey{
//    return [UIColor colorWithRed:128 green:255 blue:219 alpha:0.3];
    return [UIColor colorWithRed:((0x160000) >> 16)/255.0 green:((0x2900) >> 8)/255.0 blue:(0x34 >> 0)/255.0 alpha:1.0];
}

+(UIColor*)spartaGreen{
    return [UIColor colorFromHexString:@"80FFDB"];
}

@end

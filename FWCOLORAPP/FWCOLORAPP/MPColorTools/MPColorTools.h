//
//  MPColorTools.h
//
//  Created by Daniele Di Bernardo on 23/01/13.
//  Copyright (c) 2013-2014 marzapower. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#ifndef MP_Color_Tools
#define MP_Color_Tools

#define MP_NUM_MIN(a,b)             (a<b?a:b)
#define MP_NUM_MAX(a,b)             (a>b?a:b)
#define MP_RANGE_0_1(a)             (MP_NUM_MIN(1.0f,MP_NUM_MAX(0,a)))
#define MP_RANGE_0_255(a)           (MP_NUM_MIN(255.0f,MP_NUM_MAX(0,a)))
#define MP_255_TO_1_SCALE(a)        (MP_RANGE_0_255(a)/255.0f)
#define MP_1_TO_255_SCALE(a)        ((int)(MP_RANGE_0_1(a)*255.0f))

/**
 * Generates a new UIColor object with the given RGB values in the [0,255] range
 */
#define MP_RGB(r,g,b)               ([UIColor colorWithRed:MP_255_TO_1_SCALE(r) green:MP_255_TO_1_SCALE(g) blue:MP_255_TO_1_SCALE(b) alpha:1])

 /**
 * Generates a new UIColor object with the given RGBA values in the [0,255] range. The alpha value must be in the [0,1] range.
 */
#define MP_RGBA(r,g,b,a)            ([UIColor colorWithRed:MP_255_TO_1_SCALE(r) green:MP_255_TO_1_SCALE(g) blue:MP_255_TO_1_SCALE(b) alpha:MP_RANGE_0_1(a)])

 /**
 * Generates a new UIColor object with the given HSL values in the [0,1] range
 */
#define MP_HSL(h,s,l)               ([UIColor colorWithHue:MP_RANGE_0_1(h) saturation:MP_RANGE_0_1(s) lightness:MP_RANGE_0_1(l) alpha:1])

 /**
 * Generates a new UIColor object with the given HSLA values in the [0,1] range
 */
#define MP_HSLA(h,s,l,a)            ([UIColor colorWithHue:MP_RANGE_0_1(h) saturation:MP_RANGE_0_1(s) lightness:MP_RANGE_0_1(l) alpha:MP_RANGE_0_1(a)])

/**
 * Generates a new UIColor object with the given HSV values in the [0,1] range
 */
#define MP_HSV(h,s,v)               ([UIColor colorWithHue:MP_RANGE_0_1(h) saturation:MP_RANGE_0_1(s) brightness:MP_RANGE_0_1(v) alpha:1])

/**
 * Generates a new UIColor object with the given HSVA values in the [0,1] range
 */
#define MP_HSVA(h,s,v,a)            ([UIColor colorWithHue:MP_RANGE_0_1(h) saturation:MP_RANGE_0_1(s) brightness:MP_RANGE_0_1(v) alpha:MP_RANGE_0_1(a)])

/**
 * Alias macro for MP_HSV
 *
 * @see MP_HSV
 */
#define MP_HSB(h,s,b)               (MP_HSV(h,s,b))

/**
 * Alias macro for MP_HSVA
 *
 * @see MP_HSVA
 */
#define MP_HSBA(h,s,b,a)            (MP_HSVA(h,s,b,a))

/**
 * Generates a new UIColor object with the given CMYK values in the [0,1] range
 */
#define MP_CMYK(c,m,y,k)            ([UIColor colorWithCyan:MP_RANGE_0_1(c) magenta:MP_RANGE_0_1(m) yellow:MP_RANGE_0_1(y) keyBlack:MP_RANGE_0_1(k)])

/**
 * Generates a new grayscale UIColor object with the gray value in the [0,255] range
 */
#define MP_GRAY(g)                  ([UIColor colorWithWhite:MP_255_TO_1_SCALE(g) alpha:1])

/**
 * Generates a new grayscale UIColor object with the gray value in the [0,255] range and the alpha value in the [0,1] range
 */
#define MP_GRAYA(g,a)               ([UIColor colorWithWhite:MP_255_TO_1_SCALE(g) alpha:MP_RANGE_0_1(a)])

extern UIColor *MP_HEX_RGB(NSString *hexString);
#define MP_HEX_RGB_INT(rgb)         ([UIColor colorWithRGB:(rgb)])
#define MP_HEX_RGB_INTA(rgb,a)      ([UIColor colorWithRGB:(rgb) alpha:MP_RANGE_0_1(a)])


/**
 * The MPColorTools category adds a set of custom functions for inspecting or modifying UIColor objects
 */
@interface UIColor (MPColorTools)

//=================//
// HSL color space //
//=================//

/**
 * Generates a color from values in the HSL color space
 *
 * @param hue the hue of the color in the [0,1] range
 * @param saturation the saturation of the color in the [0,1] range
 * @param lightness the lightness (or luminosity) of the color in the [0,1] range
 * @param alpha the alpha of the color in the [0,1] range
 * @return a UIColor instance
 */
+ (UIColor *) colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha;

/** 
 * Retrieves the hue, saturation and ligthness/luminosity values (HSL color space) from the color
 *
 * @param hue a pointer to the float variable that will contain the hue value
 * @param saturation a pointer to the float variable that will contain the saturation value
 * @param lightness a pointer to the float variable that will contain the lightness value
 * @param alpha a pointer to the float variable that will contain the alpha value
 */
- (void) getHue:(CGFloat *)hue saturation:(CGFloat *)saturation lightness:(CGFloat *)lightness alpha:(CGFloat *)alpha;


//==================//
// CMYK color space //
//==================//

/**
 * Generates a color from values in the CMYK color space
 *
 * @param cyan the cyan component of the color in the [0,1] range
 * @param magenta the magenta component of the color in the [0,1] range
 * @param yellow the yellow component of the color in the [0,1] range
 * @param keyBlack the key black component of the color in the [0,1] range
 * @return a UIColor instance
 */
+ (UIColor *) colorWithCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow keyBlack:(CGFloat)keyBlack;

/**
 * Retrieves the cyan, magenta, yellow and key black values (CMYK color space) from the color
 *
 * @param cyan a pointer to the float variable that will contain the cyan value
 * @param magenta a pointer to the float variable that will contain the magenta value
 * @param yellow a pointer to the float variable that will contain the yellow value
 * @param keyBlack a pointer to the float variable that will contain the key black value
 */
- (void) getCyan:(CGFloat *)cyan magenta:(CGFloat *)magenta yellow:(CGFloat *)yellow keyBlack:(CGFloat *)keyBlack;

//===================//
// Utility functions //
//===================//

/**
 * Generates a color from a hexadecimal RGB value expressed as an integer
 * 
 * @param rgbValue the hexadecimal RGB value expressed as an integer
 * @return a UIColor instance
 */
+ (UIColor *) colorWithRGB:(int32_t)rgbValue;

/**
 * Generates a color from a hex RGB value with a given alpha
 * 
 * @param rgbValue the hexadecimal RGB value expressed as an integer
 * @param alpha the alpha component of the color
 * @return a UIColor instance
 */
+ (UIColor *) colorWithRGB:(int32_t)rgbValue alpha:(CGFloat)alpha;

/**
 * Lightens a color by a percentage
 * 
 * @param percent the percentage of the lightness to add expressed in the [0,1] range
 * @return a modified copy of the color lightened by the given percentage 
 */
- (UIColor *) colorLightenedBy:(CGFloat)percent;

/**
 * Adds or remove a given amount of lightness to a color
 * 
 * @param quantity the absolute quantity of lightness to add (or remove) in the [0,1] range
 * @return a modified copy of the color with the increased or decreased ligthness component
 */
- (UIColor *) colorByAddingLightness:(CGFloat)quantity;

/**
 * Darkens a color by a percentage
 * 
 * @param percent the percentage of the lightness to remove expressed in the [0,1] range
 * @return a modified copy of the color darkened by the given percentage 
 */
- (UIColor *) colorDarkenedBy:(CGFloat)percent;

/**
 * Move the color on the color wheel by a given angle, that should be in the (-360, 360) range.
 * If the angle is positive, the color will be moved counter-clockwise on the HSV/HSL color space
 * else it will be moved clockwise.
 *
 * @param angle the angle by which the color has to be moved on the color wheel. The values should be in the (-360, 360) range.
 * @return a copy of the color that has been moved on the color wheel by the given angle
 */
- (UIColor *) colorByAddingAngle:(CGFloat)angle;

//=============//
// Color wheel //
//=============//

/**
 * Returns the complementary color
 *
 * @return the complementary color
 */
- (UIColor *) complementaryColor;

/**
 * Returns the triadic colors using this one as the reference
 *
 * @return an array of three colors, the first one being this object
 */
- (NSArray *) triadicColors;

/**
 * Returns the square colors using this one as the reference
 *
 * @return an array of n colors, the first one being this object
 */
- (NSArray *) squareColors;

/**
 * Returns three analogous colors using this one as the reference.
 * The two new colors are offset from the reference by +/- the given angle, in the HSL color space.
 *
 * @param angleOffset the angular distance between the new colors and the reference one in the (-360,360) range
 * @return an array of n colors, the middle one being this object
 */
- (NSArray *) analogousColors:(CGFloat)angleOffset;

/**
 * Returns the split-complementary colors using this one as the reference
 *
 * @return an array of three colors, the middle one being this object
 */
- (NSArray *) splitComplementaryColors;

//=====================//
// Getters and setters //
//=====================//

/**
 * Returns the hexadecimal representation of the color object
 *
 * @return the hexadecimal representation of the color object in the RGB(A) space
 *         as an unsigned integer
 */
- (NSUInteger)hexValue;

/**
 * Returns the string representation of the hexadecimal value of the color object in the RGB(A) space.
 * The default format is RRGGBB, with to characters for each color component. If the color has an alpha value
 * different from 1 the format will be RRGGBBAA, with two additional characters for the alpha component.
 *
 * @see hexValue
 * 
 * @return an RGB hexadecimal string representation of the color in the RRGGBB or RRGGBBAA format
 */
- (NSString *)hexString;

/**
 * Returns the red value of the color in the [0,1] range
 *
 * @return the red value of the color in the [0,1] range
 */
- (CGFloat)red;

/**
 * Returns the green value of the color in the [0,1] range
 *
 * @return the green value of the color in the [0,1] range
 */
- (CGFloat)green;

/**
 * Returns the blue value of the color in the [0,1] range
 *
 * @return the blue value of the color in the [0,1] range
 */
- (CGFloat)blue;

/**
 * Returns the alpha value of the color in the [0,1] range
 *
 * @return the alpha value of the color in the [0,1] range
 */
- (CGFloat)alpha;

/**
 * Returns the hue value of the color in the [0,1] range
 *
 * @return the hue value of the color in the [0,1] range
 */
- (CGFloat)hue;

/**
 * Returns the saturation value of the color in the [0,1] range
 *
 * @return the saturation value of the color in the [0,1] range
 */
- (CGFloat)saturation;

/**
 * Returns the brightness value of the color in the [0,1] range
 *
 * @return the brightness value of the color in the [0,1] range
 */
- (CGFloat)brightness;

/**
 * Returns the lightness value of the color in the [0,1] range
 *
 * @return the lightness value of the color in the [0,1] range
 */
- (CGFloat)lightness;

/**
 * Generates a duplicate of the object changing the red component to the given one,
 * and leaving all the other components intact. This value has to be in the [0,1] range.
 *
 * @param red the new value for the red component in the [0,1] range
 * @return a new UIColor object with the red component changed to the desired value
 */
- (UIColor *)colorWithRed:(CGFloat)red;

/**
 * Generates a duplicate of the object changing the green component to the given one,
 * and leaving all the other components intact. This value has to be in the [0,1] range.
 *
 * @param green the new value for the green component in the [0,1] range
 * @return a new UIColor object with the green component changed to the desired value
 */
- (UIColor *)colorWithGreen:(CGFloat)green;

/**
 * Generates a duplicate of the object changing the blue component to the given one,
 * and leaving all the other components intact. This value has to be in the [0,1] range.
 *
 * @param blue the new value for the blue component in the [0,1] range
 * @return a new UIColor object with the blue component changed to the desired value
 */
- (UIColor *)colorWithBlue:(CGFloat)blue;

/**
 * Generates a duplicate of the object changing the hue component to the given one,
 * and leaving all the other components intact. This value has to be in the [0,1] range.
 *
 * @param hue the new value for the hue component in the [0,1] range
 * @return a new UIColor object with the hue component changed to the desired value
 */
- (UIColor *)colorWithHue:(CGFloat)hue;

/**
 * Generates a duplicate of the object changing the saturation component to the given one,
 * and leaving all the other components intact. This value has to be in the [0,1] range.
 *
 * @param saturation the new value for the saturation component in the [0,1] range
 * @return a new UIColor object with the saturation component changed to the desired value
 */
- (UIColor *)colorWithSaturation:(CGFloat)saturation;

/**
 * Generates a duplicate of the object changing the brightness component to the given one,
 * and leaving all the other components intact. This value has to be in the [0,1] range.
 *
 * @param brightness the new value for the brightness component in the [0,1] range
 * @return a new UIColor object with the brightness component changed to the desired value
 */
- (UIColor *)colorWithBrightness:(CGFloat)brightness;

/**
 * Generates a duplicate of the object changing the lightness component to the given one,
 * and leaving all the other components intact. This value has to be in the [0,1] range.
 *
 * @param lightness the new value for the lightness component in the [0,1] range
 * @return a new UIColor object with the lightness component changed to the desired value
 */
- (UIColor *)colorWithLightness:(CGFloat)lightness;

/**
 * Generates a duplicate of the object changing the lightness and alpha components to the given ones,
 * and leaving all the other components intact. These values have to be in the [0,1] range.
 *
 * @param lightness the new value for the lightness component in the [0,1] range
 * @param alpha the new value for the alpha component in the [0,1] range
 * @return a new UIColor object with the lightness and alpha components changed to the desired values
 */
- (UIColor *)colorWithLightness:(CGFloat)lightness alpha:(CGFloat)alpha;

//==================//
// Color overlaying //
//==================//

- (UIColor *)colorByAlphaBlendingOverColor:(UIColor *)underlyingColor;

@end

#endif
////////////////////////////////////////////////////////////////////////////////
//
//
//  IXIcons.h
//
//  Written by Axel Dingen bv
//
//  AUTHOR IDENTITY:
//		Axel Roest		2015-12-10 09:30:46 +0000
//
////////////////////////////////////////////////////////////////////////////////
/**
Class which generates strings and images with the icons in the iconfont
IcoMoon-Free.ttf.
**/

////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>
#import "IXIconNames.h"

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/**
 *
 */
@interface IXIcons : NSObject

/** singleton utility instance **/
+ (instancetype)sharedIcons;

/** return a unicode string for the icon with the name iconName
    See the file MSIconNames.h for a list of names
 **/
+ (NSString *) iconStringFor:(IXIconNameType) iconName;

/** return an image for the icon with the name iconName
 See the file IXIconNames.h for a list of names
 Default values:
 if bgColor is nil, clearColor is used
 if iconColor is nil, whiteColor is used
 **/
+ (UIImage*) iconImageFor:(IXIconNameType)iconName backgroundColor:(UIColor*)bgColor iconColor:(UIColor*) iconColor fontSize:(int)fontSize;

@end


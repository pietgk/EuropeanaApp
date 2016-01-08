////////////////////////////////////////////////////////////////////////////////
//
//
//  IXIcons.m
//
//  Written by Axel Dingen bv
//
//  AUTHOR IDENTITY:
//		Axel Roest		2015-12-10 09:30:46 +0000
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
#import "IXIcons.h"
#import "ArtWhisper-Swift.h"

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
@interface IXIcons ()

@end
////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation IXIcons
// Probably not necessary, as we are going to have class methods
+ (instancetype)sharedIcons
{
    static IXIcons *_sharedIconUtilities = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedIconUtilities = [[IXIcons alloc] init];
    });

    return _sharedIconUtilities;
}

+ (NSString *) iconStringFor:(IXIconNameType) iconName
{
    unichar unicode = (unichar) iconName;
    return [NSString stringWithFormat:@"%C", unicode];
}

+ (NSAttributedString *) attributedIconStringFor:(IXIconNameType) iconName backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor size:(CGFloat) fontSize
{
    NSString* textContent = [[self class] iconStringFor:iconName];

    UIFont *font = [UIFont iconFontWithSize:fontSize];  // [UIFont fontWithName:@"icoMoon-Free" size:fontSize];
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSForegroundColorAttributeName : iconColor,
                                 NSBackgroundColorAttributeName : bgColor,
                                 };
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:textContent attributes:attributes];
    return attrStr;
}

+ (NSAttributedString *) defaultAttributedIconStringFor:(IXIconNameType) iconName size:(CGFloat) fontSize
{
    return [self attributedIconStringFor:iconName backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] size:fontSize];
}

/* with some help from UIImage+UIImage_FontAwesome.m */
+ (UIImage*) iconImageFor:(IXIconNameType)iconName backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor fontSize:(int)fontSize
{
    if (!bgColor) {
        bgColor = [UIColor clearColor];
    }
    if (!iconColor) {
        iconColor = [UIColor whiteColor];
    }

    //// Abstracted Attributes
    NSString* textContent = [[self class] iconStringFor:iconName];

    UIFont *font = [UIFont iconFontWithSize:fontSize];  // [UIFont fontWithName:@"icoMoon-Free" size:fontSize];
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSForegroundColorAttributeName : iconColor,
                                 NSBackgroundColorAttributeName : bgColor,
                                 };

    //// Content Edge Insets
    CGSize size = [textContent sizeWithAttributes:attributes];
    // size = CGSizeMake(size.width * 1.1, size.height * 1.05);
    size = CGSizeMake(size.width, size.height);

    CGRect textRect = CGRectZero;
    textRect.size = size;

    // CGPoint origin = CGPointMake(size.width * 0.05, size.height * 0.025);
    CGPoint origin = CGPointMake(0.0, 0.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);

    //// Rectangle Drawing
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:textRect];
    [bgColor setFill];
    [path fill];

    //// Text Drawing
    [textContent drawAtPoint:origin withAttributes:attributes];

    //Image returns
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

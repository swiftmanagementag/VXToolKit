//
//  UIImage+Rotate.m
//  iTheorie
//
//  Created by Graham Lancashire on 11.08.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import "UIImage+Category.h"

static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat  swap = rect.size.width;
    
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}

@implementation UIImage (Category)

+ (NSString *)resolutionIndependentImagePath:(NSString *)path {
    return [UIImage resolutionIndependentImagePath:path withForce:NO];
}

+ (NSString *)resolutionIndependentImagePath:(NSString *)path withForce:(BOOL)pForce {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSString *pathIpad = [[path stringByDeletingLastPathComponent] 
                            stringByAppendingPathComponent:[NSString stringWithFormat:@"%@~ipad.%@", 
                                                            [[path lastPathComponent] stringByDeletingPathExtension], 
                                                            [path pathExtension]]];
        
        // only force for ipad
        if([[NSFileManager defaultManager] fileExistsAtPath:pathIpad] || pForce){
            return pathIpad;
		}

    } else {
        if([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f) {
            NSString *path2x = [[path stringByDeletingLastPathComponent] 
                            stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.%@", 
                                                            [[path lastPathComponent] stringByDeletingPathExtension], 
                                                            [path pathExtension]]];
        
            if([[NSFileManager defaultManager] fileExistsAtPath:path2x]){
                return path2x;
            }
        }
    }
    return path;
}

-(UIImage*)rotate:(UIImageOrientation)orient
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = self.CGImage;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
	
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
			// would get you an exact copy of the original
			assert(false);
			return nil;
			
        case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;
			
        case UIImageOrientationDown:
			tran = CGAffineTransformMakeTranslation(rect.size.width,
													rect.size.height);
			tran = CGAffineTransformRotate(tran, M_PI);
			break;
			
        case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
			tran = CGAffineTransformScale(tran, 1.0, -1.0);
			break;
			
        case UIImageOrientationLeft:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
			
        case UIImageOrientationLeftMirrored:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(rect.size.height,
													rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
			
        case UIImageOrientationRight:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
			
        case UIImageOrientationRightMirrored:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
			
        default:
			// orientation value supplied is invalid
			assert(false);
			return nil;
    }
	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
			CGContextScaleCTM(ctxt, -1.0, 1.0);
			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
			break;
			
        default:
			CGContextScaleCTM(ctxt, 1.0, -1.0);
			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
			break;
    }
	
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}




- (void)saveAs:(NSString*)pName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pName];
	NSData *imageData = UIImagePNGRepresentation(self);
	[imageData writeToFile:savedImagePath atomically:NO];
}

+ (UIImage*)load:(NSString*)pName  {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:pName];
	return [UIImage imageWithContentsOfFile:getImagePath];
}
+ (UIImage *)convertImageToNegative:(UIImage *)image{
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
    
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return returnImage;
}
+ (UIImage *)convertImageToGrayScale:(UIImage *)image {
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}
- (UIImage *) convertToGreyscale {
	
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
	
    int colors = kGreen;
    int m_width = self.size.width;
    int m_height = self.size.height;
	
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [self CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
	
    // convert from a gray scale image back into a UIImage
    uint32_t *result = (uint32_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
	
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
	
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
	
    free(m_imageData);
	
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
	
    return resultUIImage;
}
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;        
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = heightFactor; // scale to fit width
        else
            scaleFactor = widthFactor; // scale to fit height
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*) overlay:(UIImage*)pOverlay {
	UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);

	CGPoint mainPoint = CGPointMake(0, 0);
	[self drawAtPoint:mainPoint];

	CGPoint overlayPoint = CGPointMake(0, 0);
	[pOverlay drawAtPoint:overlayPoint];
	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}
+(UIImage *) image:(UIImage *)img withColor:(UIColor *)color {
	
	UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
	
	CGRect rect = CGRectMake(0, 0, img.size.width * img.scale, img.size.height * img.scale);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetBlendMode(context, kCGBlendModeColor);
	[img drawInRect:rect];
	
	[color set];
	CGContextAddRect(context, rect);
	CGContextFillPath(context);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIImage *maskImage = img;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGImageRef maskImageRef = [maskImage CGImage];
	
	// create a bitmap graphics context the size of the image
	CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width * img.scale, maskImage.size.height * img.scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
	
	
	if (mainViewContentContext==NULL)
		return NULL;
	
	CGFloat ratio = 0;
	
	ratio = maskImage.size.width/ image.size.width;
	
	if(ratio * image.size.height < maskImage.size.height) {
		ratio = maskImage.size.height/ image.size.height;
	}
	
	CGRect rect1 = {{0, 0}, {maskImage.size.width * img.scale, maskImage.size.height * img.scale}};
	
	CGRect rect2 = {{-((rect.size.width *ratio)-rect1.size.width)/2 , -((rect.size.height* ratio)-rect1.size.height)/2}, {rect.size.width*ratio, rect.size.height* ratio}};
	
	
	CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
	CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
	
	// Create CGImageRef of the main view bitmap content, and then
	// release that bitmap context
	CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	
	UIImage *theImage = [UIImage imageWithCGImage:newImage scale:img.scale orientation:img.imageOrientation];
	
	CGImageRelease(newImage);
	UIGraphicsEndImageContext();
	// return the image
	return theImage;
}
- (UIImage *) tintImageWithColor: (UIColor *) color
{
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [self size];
    // Retrieve source image and begin image context
    CGSize itemImageSize = [self size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );
	
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(contextRect.size, NO, [[UIScreen mainScreen] scale]); //Retina support
    else
        UIGraphicsBeginImageContext(contextRect.size);
	
    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [self CGImage]);
	
    // Fill and end the transparency layer
    color = [color colorWithAlphaComponent:1.0];
	
    CGContextSetFillColorWithColor(c, color.CGColor);
	
    contextRect.size.height = -contextRect.size.height;
    CGContextFillRect(c, contextRect);
    CGContextEndTransparencyLayer(c);
	
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return img;
}
@end
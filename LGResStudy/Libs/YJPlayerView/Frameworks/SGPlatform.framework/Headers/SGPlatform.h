//
//  SGPlatform.h
//  SGPlatform
//
//  Created by Single on 2017/3/9.
//  Copyright © 2017年 single. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double SGPlatformVersionNumber;
FOUNDATION_EXPORT const unsigned char SGPlatformVersionString[];


// Target Conditionals
#import <SGPlatform/SGPLFTargets.h>


// UIKit and AppKit Objects
#import <SGPlatform/SGPLFObject.h>

#import <SGPlatform/SGPLFView.h>
#import <SGPlatform/SGPLFImage.h>
#import <SGPlatform/SGPLFColor.h>
#import <SGPlatform/SGPLFScreen.h>
#import <SGPlatform/SGPLFDisplayLink.h>


// OpenGL
#import <SGPlatform/SGPLFOpenGL.h>

#import <SGPlatform/SGPLFGLView.h>
#import <SGPlatform/SGPLFGLContext.h>
#import <SGPlatform/SGPLFGLViewController.h>

//
//  OpenGLHelper.h
//  MyOpenGL
//
//  Created by The Answer on 17/8/17.
//  Copyright © 2017年 The Answer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface OpenGLUtils : NSObject

+ (GLuint)createVertexBuffersObjectWithObjType:(GLenum)objType ObjSize:(int)objSize Usage:(GLenum)usage Data:(GLvoid *)data;
+ (GLuint)createCommonVertexBuffersObjectWithObjSize:(int)ObjSize Data:(GLvoid *)data;

+ (GLuint)createGPUProgramWithVertexShaderPath:(NSString *)vshPath FragmentShaderPath:(NSString *)fshPath;

+ (GLuint)compileVertexShaderWithPath:(NSString *)shaderPath;
+ (GLuint)compileFragmentShaderWithPath:(NSString *)shaderPath;

@end

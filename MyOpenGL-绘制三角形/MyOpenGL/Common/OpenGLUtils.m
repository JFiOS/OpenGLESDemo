//
//  OpenGLHelper.m
//  MyOpenGL
//
//  Created by The Answer on 17/8/17.
//  Copyright © 2017年 The Answer. All rights reserved.
//

#import "OpenGLUtils.h"

@implementation OpenGLUtils

+ (GLuint)createGPUProgramWithVertexShaderPath:(NSString *)vshPath FragmentShaderPath:(NSString *)fshPath
{
    GLuint gpuProgram;

    GLuint vsShader = [self compileVertexShaderWithPath:vshPath];
    GLuint fsShader = [self compileFragmentShaderWithPath:fshPath];

    gpuProgram = glCreateProgram();

    glAttachShader(gpuProgram, vsShader);
    glAttachShader(gpuProgram, fsShader);

    glLinkProgram(gpuProgram);
    
    glDetachShader(gpuProgram, vsShader);
    glDetachShader(gpuProgram, fsShader);
    
    GLint linkStatus = GL_TRUE;
    glGetProgramiv(gpuProgram, GL_LINK_STATUS, &linkStatus);
    
    if (linkStatus == GL_FALSE) {
        NSLog(@"link error!");
        
        GLchar infoLog[1024] = {0};
        GLsizei len = 0;
        glGetProgramInfoLog(gpuProgram, 1024, &len, infoLog);
        
        NSLog(@"error is %s",infoLog);
        glDeleteProgram(gpuProgram);
    }
    return gpuProgram;
}

+ (GLuint)compileVertexShaderWithPath:(NSString *)shaderPath
{
    return [self compileShaderWithType:GL_VERTEX_SHADER ShaderPath:shaderPath];
}

+ (GLuint)compileFragmentShaderWithPath:(NSString *)shaderPath
{
    return [self compileShaderWithType:GL_FRAGMENT_SHADER ShaderPath:shaderPath];
}

+ (GLuint)compileShaderWithType:(GLenum)type ShaderPath:(NSString *)shaderPath
{
    GLuint shader = glCreateShader(type);

    const GLchar *shaderCode = [self getShaderCodeWithPath:shaderPath];

    glShaderSource(shader, 1, &shaderCode, NULL);

    glCompileShader(shader);
    
    GLint compileStatus = GL_TRUE;

    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus);
    
    if (compileStatus == GL_FALSE) {
        NSLog(@"compile shader error, the error code is %s",shaderCode);
        GLchar infoLog[1024] = {0};
        GLsizei len = 0;

        glGetShaderInfoLog(shader, 1024, &len, infoLog);
        NSLog(@"error log is %s",infoLog);
 
        glDeleteShader(shader);
        return 0;
    }
    return shader;

}

+ (GLchar *)getShaderCodeWithPath:(NSString *)path
{
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:path ofType:nil];
    
    GLchar *shader = (GLchar *)[[NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    return shader;
}

+ (GLuint)createCommonVertexBuffersObjectWithObjSize:(int)ObjSize Data:(GLvoid *)data
{
    return [self createVertexBuffersObjectWithObjType:GL_ARRAY_BUFFER ObjSize:ObjSize Usage:GL_STATIC_DRAW Data:data];
}

+ (GLuint)createVertexBuffersObjectWithObjType:(GLenum)objType ObjSize:(int)objSize Usage:(GLenum)usage Data:(GLvoid *)data
{
    GLuint vbo;
    
    glGenBuffers(1, &vbo);

    glBindBuffer(objType, vbo);

    glBufferData(objType, objSize, data, usage);

    glBindBuffer(objType, 0);
    
    return vbo;
}

@end

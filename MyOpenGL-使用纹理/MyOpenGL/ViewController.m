//
//  ViewController.m
//  MyOpenGL
//
//  Created by The Answer on 17/8/16.
//  Copyright © 2017年 The Answer. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLUtils.h"

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign) GLuint vbo;
@property (nonatomic, assign) GLuint texture;
@property (nonatomic, assign) GLuint gpuProgram;
@property (nonatomic, assign) GLint posLocation;
@property (nonatomic, assign) GLint textureLocation;
@property (nonatomic, assign) GLint texcoordLocation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initContext];
    [self initGpuProgram];
}

- (void)initContext
{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"create context error!");
    }
    
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = self.context;
    [EAGLContext setCurrentContext:self.context];
}

- (void)initGpuProgram
{
    float positions[] =
    {
        // 顶点坐标           // 纹理坐标
        -.5f,-.5f,0.f,      0.f,0.f,
        .5f,-.5f,0.f,       1.f,0.f,
        .5f,.5f,0.f,        1.f,1.f,
        -.5f,.5f,0.f,       0.f,1.f,
    };
    

    _vbo = [OpenGLUtils createVertexBuffersObjectWithObjType:GL_ARRAY_BUFFER ObjSize:sizeof(float) * 5 * 4 Usage:GL_STATIC_DRAW Data:positions];
    _texture = [OpenGLUtils createTexture2DWithImageName:@"lena.bmp"];
    _gpuProgram = [OpenGLUtils createGPUProgramWithVertexShaderPath:@"Shader.vsh" FragmentShaderPath:@"Shader.fsh"];
    _posLocation = glGetAttribLocation(_gpuProgram, "position");
    _texcoordLocation = glGetAttribLocation(_gpuProgram, "texcoord");
    _textureLocation = glGetUniformLocation(_gpuProgram, "u_texture");
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(.1f, .3f, .7f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(_gpuProgram);
    
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1i(_textureLocation, 0);

    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    
    glEnableVertexAttribArray(_posLocation);

    glVertexAttribPointer(_posLocation, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 5, 0);
    
    glEnableVertexAttribArray(_texcoordLocation);
    glVertexAttribPointer(_texcoordLocation, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 5, (void *)(sizeof(float) * 3));
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
 
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    glUseProgram(0);
}

@end

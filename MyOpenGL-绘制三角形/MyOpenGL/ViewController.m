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

@property (strong, nonatomic) EAGLContext *context;
@property (assign, nonatomic) GLuint vbo;
@property (assign, nonatomic) GLuint gpuProgram;
@property (assign, nonatomic) GLint posLocation;

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
        -.5f,-.5f,0.f,
        .5f,-.5f,0.f,
        0.f,.5f,0.f,
    };
    
    _vbo = [OpenGLUtils createVertexBuffersObjectWithObjType:GL_ARRAY_BUFFER ObjSize:sizeof(float) * 3 * 3 Usage:GL_STATIC_DRAW Data:positions];

    _gpuProgram = [OpenGLUtils createGPUProgramWithVertexShaderPath:@"Shader.vsh" FragmentShaderPath:@"Shader.fsh"];
    _posLocation = glGetAttribLocation(_gpuProgram, "position");
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(.1f, .3f, .7f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(_gpuProgram);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    
    glEnableVertexAttribArray(_posLocation);

    glVertexAttribPointer(_posLocation, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
 
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    glUseProgram(0);
}

@end

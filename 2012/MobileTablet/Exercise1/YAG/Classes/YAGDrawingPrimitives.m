//
//  YAGDrawingPrimitives.m
//  YAG
//
//  Created by Tiago Janela on 11/30/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//

#import "YAGDrawingPrimitives.h"
static BOOL initialized = NO;
static CCGLProgram *shader_ = nil;
static int colorLocation_ = -1;
static ccColor4F color_ = {1,1,1,1};
static int pointSizeLocation_ = -1;
//static GLfloat pointSize_ = 1;

static void yag_lazy_init( void )
{
	if( ! initialized ) {

		//
		// Position and 1 color passed as a uniform (to similate glColor4ub )
		//
		shader_ = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_Position_uColor];

		colorLocation_ = glGetUniformLocation( shader_->program_, "u_color");
		pointSizeLocation_ = glGetUniformLocation( shader_->program_, "u_pointSize");

		initialized = YES;
	}

}

void yagDrawSolidCircle( CGPoint center, float r, float a, NSUInteger segs)
{
	yag_lazy_init();

	int additionalSegment = 1;

	const float coef = 2.0f * (float)M_PI/segs;

	GLfloat *vertices = calloc( sizeof(GLfloat)*2*(segs+2), 1);
	if( ! vertices )
		return;

	for(NSUInteger i = 0;i <= segs; i++) {
		float rads = i*coef;
		GLfloat j = r * cosf(rads + a) + center.x;
		GLfloat k = r * sinf(rads + a) + center.y;

		vertices[i*2] = j;
		vertices[i*2+1] = k;
	}
	vertices[(segs+1)*2] = center.x;
	vertices[(segs+1)*2+1] = center.y;

	[shader_ use];
	[shader_ setUniformForModelViewProjectionMatrix];    
	[shader_ setUniformLocation:colorLocation_ with4fv:(GLfloat*) &color_.r count:1];

	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );

	glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	glDrawArrays(GL_TRIANGLE_FAN, 0, (GLsizei) segs+additionalSegment);

	free( vertices );
	
	CC_INCREMENT_GL_DRAWS(1);
}

void yagDrawColor4F( GLfloat r, GLfloat g, GLfloat b, GLfloat a )
{
	color_ = (ccColor4F) {r, g, b, a};
}

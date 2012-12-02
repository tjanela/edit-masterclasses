//
//  YAGDrawingPrimitives.h
//  YAG
//
//  Created by Tiago Janela on 11/30/12.
//  Copyright (c) 2012 Tiago Janela. All rights reserved.
//



#ifndef __YAG_DRAWING_PRIMITIVES_H
#define __YAG_DRAWING_PRIMITIVES_H

#import <Foundation/Foundation.h>

void yagDrawSolidCircle( CGPoint center, float radius, float angle, NSUInteger segments);
void yagDrawColor4F( GLfloat r, GLfloat g, GLfloat b, GLfloat a );
#endif
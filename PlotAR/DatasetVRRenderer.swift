//
//  DatasetVRRenderer.swift
//  PlotAR
//
//  Created by Philipp Thomann on 15.09.18.
//  Copyright © 2018 Philipp Thomann. All rights reserved.
//

import Foundation
import SceneKit

// possible ways to use Scenekit with GoogleVR:
// VRBoilerplarte: https://github.com/AndrianBdn/GVR-SceneKit
//
// use opengl for scenekit: https://stackoverflow.com/questions/41384462/how-can-i-combine-scenekit-with-existing-opengl-using-scnrenderer

class DatasetVRRenderer : GVRRenderer {
    
    var scene: SCNScene!
    var eyeRenderers : [SCNRenderer?] = [nil,nil,nil];
    var renderTime: TimeInterval = 0.0 // seconds
    var datasetHandler: DatasetHandler

    init(scene: SCNScene, datasetHandler: DatasetHandler) {
        self.scene = scene
        self.datasetHandler = datasetHandler
    }
    
    // creates lazyly a SCNRenderer that renders self.scene
    // will be called for each eye by getEyeRenderer
    func getEyeRenderer(eye:GVREye) -> SCNRenderer? {
        if eye.rawValue > 2 {
            return nil
        }
        if eyeRenderers[eye.rawValue] == nil {
            print("created DatasetVRRenderer for eye \(eye.rawValue)")
            let renderer = SCNRenderer.init(context: EAGLContext.current(), options: nil);
            let camNode = SCNNode();
            camNode.camera = SCNCamera();
            renderer.pointOfView = camNode;
            renderer.scene = scene;
            // comment this out if you would like custom lighting
            renderer.autoenablesDefaultLighting = true;
            eyeRenderers[eye.rawValue] = renderer
        }
        return eyeRenderers[eye.rawValue]
    }
    
    override func initializeGl() {
        super.initializeGl()
    }
    
    override func update(_ headPose: GVRHeadPose!) {
        super.update(headPose!)
        
        // can't get SCNRenderer to do this, have to do it myself
        if let color = scene.background.contents as? UIColor {
            var r: CGFloat = 0;
            var g: CGFloat = 0;
            var b: CGFloat = 0;
            color.getRed(&r, green: &g, blue: &b, alpha: nil);
            
            glClearColor(GLfloat(r), GLfloat(g), GLfloat(b), 1);
        } else {
            glClearColor(0, 0, 0, 1);
        }

//        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT));
        glEnable(GLenum(GL_DEPTH_TEST));
        glEnable(GLenum(GL_SCISSOR_TEST));
        
        renderTime = CACurrentMediaTime()
    }
    
    override func draw(_ headPose: GVRHeadPose!) {
        super.draw(headPose!)

        let headFromStartMatrix: GLKMatrix4 = headPose.headTransform
        let eyeFromHeadMatrix: GLKMatrix4 = headPose.eyeTransform
        let modelViewMatrix: GLKMatrix4 = GLKMatrix4Multiply(eyeFromHeadMatrix, headFromStartMatrix)
        let projectionMatrix = headPose.projectionMatrix(withNear: 0.01, far: 1000.0)
//        let viewMatrix = headPose.viewTransform
        
        // from VRBoilerplate
        
        let viewport = headPose.viewport
        glViewport(GLint(viewport.origin.x), GLint(viewport.origin.y), GLint(viewport.size.width), GLint(viewport.size.height))
        glScissor(GLint(viewport.origin.x), GLint(viewport.origin.y), GLint(viewport.size.width), GLint(viewport.size.height))
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT));

        guard let eyeRenderer = getEyeRenderer(eye: headPose.eye) else {
            fatalError("no eye renderer for eye")
        }
        
        eyeRenderer.pointOfView?.camera?.projectionTransform = SCNMatrix4FromGLKMatrix4(projectionMatrix);
        eyeRenderer.pointOfView?.transform = SCNMatrix4FromGLKMatrix4(GLKMatrix4Transpose(modelViewMatrix));
        
        datasetHandler.cameraNode.transform = SCNMatrix4FromGLKMatrix4(headPose.headTransform)
        
        renderTime = CFAbsoluteTimeGetCurrent()
        
        eyeRenderer.scene = scene
        
        if glGetError() == GLenum(GL_NO_ERROR) {
            eyeRenderer.render(atTime: renderTime)
        }
    }
    
    override func handleTrigger() -> Bool {
        print("Trigger was hit")
        return true
    }
    
}

extension GLKMatrix4 {
    // can be helpful: e.g. modelViewMatrix.printMatrix()
    func printMatrix() {
        print("[")
        print("  ", m00, m01, m02, m03)
        print("  ", m10, m11, m12, m13)
        print("  ", m20, m21, m22, m23)
        print("  ", m30, m31, m32, m33)
        print("]")
    }
}

//
//  DatasetHandler.swift
//  PlotAR
//
//  Created by Philipp Thomann on 04.07.19.
//  Copyright © 2019 Philipp Thomann. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

protocol DatasetViewController {
    var datasetHandler: DatasetHandler { get }
    func isSupported() -> Bool
}

extension DatasetViewController {
    func isSupported() -> Bool { return true }
}

class DatasetHandler {
    
    var dataset: Dataset?
    
    var dataNode: SCNNode!
    
    var cameraNode: SCNNode!

    func makeDataNode() -> SCNNode {
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.red
        let blueMaterial = SCNMaterial()
        blueMaterial.diffuse.contents = UIColor.blue
        let greenMaterial = SCNMaterial()
        greenMaterial.diffuse.contents = UIColor.green
        
        let dataNode = SCNNode()
        dataNode.name = "DataNode"
        //        let theData = Data().data
        if let theData = dataset?.data {
            var i = -1
            for item in theData {
                i += 1
                if item.count < 3 {
                    continue
                }
                
                let cubeGeometry: SCNGeometry
                var size = 1.0
                if let label = self.dataset?.label {
                    let textGeometry = SCNText(string: label[i], extrusionDepth: 2.0)
                    textGeometry.font = UIFont (name: "Helvetica Neue", size: 10)
                    // looks nice but has a weird problem with letter 'e'???
//                    textGeometry.chamferRadius = 0.5
                    cubeGeometry = textGeometry
                    size *= 0.0015
                    
                } else {
                   cubeGeometry = SCNSphere(radius: 0.002)
                }
                if let thesize = self.dataset?.size {
                    size *= thesize[i]
                }
                let cubeNode = SCNNode(geometry: cubeGeometry)
                cubeNode.position = SCNVector3(x: Float(item[0]/10.0), y: Float(item[2]/10.0)-0.2, z: -Float(item[1])/10.0-1)
                //            cubeNode.pivot = SCNMatrix4MakeTranslation(-Float(item[0])+6, -Float(item[1])+3, -Float(item[2])+7.5)
                //print(item[3]==1.0)
                cubeNode.scale = SCNVector3(size, size, size)
                //let col: Int
                let col = self.dataset?.col?[i] ?? (item.count >= 4 ? item[3] : 1.0 )
                switch col.truncatingRemainder(dividingBy: 3.0) {
                case 2.0:
                    cubeGeometry.materials = [blueMaterial]
                case 0.0:
                    cubeGeometry.materials = [greenMaterial]
                default:
                    cubeGeometry.materials = [redMaterial]
                }
                dataNode.addChildNode(cubeNode)
                //            scene.rootNode.addChildNode(cubeNode)
            }
        }
        return dataNode
    }
    
    func makeSceneNode() -> SCNNode {
        let sceneNode = SCNNode()
        
        let camera = SCNCamera()
        camera.zNear = 0.01
        cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 1, z: 1)
        
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        //        light.type = SCNLight.LightType.spot
        //        light.spotInnerAngle = 30.0
        //        light.spotOuterAngle = 80.0
        //        light.castsShadow = true
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        

        //        let planeGeometry = SCNPlane(width: 50.0, height: 50.0)
        //        let planeNode = SCNNode(geometry: planeGeometry)
        //        planeNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
        //        planeNode.position = SCNVector3(x: 0, y: -0.5, z: 0)
        
        sceneNode.addChildNode(lightNode)
        sceneNode.addChildNode(cameraNode)
        
        dataNode = makeDataNode()
        if let dataNode = dataNode {
            sceneNode.addChildNode(dataNode)
        }
        
        let axes: SCNNode = makeAxes()
        sceneNode.addChildNode(axes)
        
        cameraNode.look(at: axes.position)
        
        return sceneNode
    }
    
    func makeAxes() -> SCNNode {
        let axesNode = SCNNode()
        
        let r: CGFloat = 0.002      // radius of beam
        let tipH = 4 * r // height of tip
        let tipR = 2 * r // radius of tip
        let a = SCNCylinder(radius: r, height: 2-tipH)
        let an = SCNNode(geometry: a)
//        an.position.y = -1
        let b = SCNCone(topRadius: 0, bottomRadius: tipR, height: tipH)
        let bn = SCNNode(geometry: b)
        bn.position.y = 1
        
        let axis = SCNNode()
        axis.addChildNode(an)
        axis.addChildNode(bn)
        
        let axisX = axis.clone()
        axisX.eulerAngles.z -= Float.pi / 2
        let axisZ = axis.clone()
        axisZ.eulerAngles.x += Float.pi / 2

        axesNode.addChildNode(axis)
        axesNode.addChildNode(axisX)
        axesNode.addChildNode(axisZ)

        return axesNode
    }
    
    func makeSCNScene() -> SCNScene {
        // Create a new scene
        let scene = SCNScene()
        
        let sceneNode = makeSceneNode()
        scene.rootNode.addChildNode(sceneNode)
        return scene
    }
    
    /////////////////////////////////////////////
    //////////         WebSockets        ////////
    /////////////////////////////////////////////
    
    var url = "ws://192.168.2.105:2908/ws"
    func refreshData() {
        dataset?.reload()
    }
    
    var speed: Float = 1.0
    
    func handleKeyStroke(_ msg: String) {
        if msg == "r" || msg == "reload_data" || msg == "x" {
            refreshData();
        }else if(msg == "space"){
            speed = (speed==0) ? 1 : 0;
            print("New speed: ", speed);
            /*      }else if(msg == "f"){
             toggleFullscreen();
             }else if(msg == "c"){
             if(connected){
             device_controls.disconnect();
             }else{
             device_controls.connect();
             }
             connected = !connected;*/
        }else{
            let ALPHA_ROT: Float = 0.1;
            if(msg == "a"){
                go(-1, 0, 0);
            }else if(msg == "d"){
                go(1, 0, 0);
            }else if(msg == "s"){
                go(0, 0, 1);
            }else if(msg == "w"){
                go(0, 0, -1);
            }else if(msg == "q"){
                go(0, 1, 0);
            }else if(msg == "e"){
                go(0, -1, 0);
            }else if(msg == "Left"){
                cameraNode.eulerAngles.y += ALPHA_ROT
            }else if(msg == "Right"){
                cameraNode.eulerAngles.y -= ALPHA_ROT
            }else if(msg == "Up"){
                cameraNode.eulerAngles.x += ALPHA_ROT
            }else if(msg == "Down"){
                cameraNode.eulerAngles.x -= ALPHA_ROT
            }
        }
    }
    
    func go(_ x: Float, _ y: Float, _ z: Float) {
        var vector = simd_float3(x/5,y/5,z/5);
        vector = cameraNode.simdOrientation.act(vector)
//        cameraNode.simdPosition += vector
        dataNode.simdPosition += vector
        print(cameraNode.simdPosition)
        print(vector)
        print(dataNode.position)
    }
}

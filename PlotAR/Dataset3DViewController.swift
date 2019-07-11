//
//  Dataset3DViewController.swift
//  PlotAR
//
//  Created by Philipp Thomann on 17.12.17.
//  Copyright © 2017 Philipp Thomann. All rights reserved.
//

import UIKit
import SceneKit

class Dataset3DViewController: UIViewController, DatasetViewController
    //,SCNSceneRendererDelegate
    {

    @IBOutlet var sceneView: SCNView!
    var sceneNode: SCNNode!
    //var dataNode: SCNNode!
    
    //var dataset: Dataset? = Dataset(file:"smi_choco", verbose: true)//Dataset()
    var datasetHandler: DatasetHandler = DatasetHandler()


    override func viewDidLoad() {
        super.viewDidLoad()

        //sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        sceneView.scene = scene
        
        sceneNode = datasetHandler.makeSceneNode()
        scene.rootNode.addChildNode(sceneNode)
        
        // Set the scene to the view
        sceneView.scene = scene
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

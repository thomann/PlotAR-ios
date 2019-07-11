//
//  DatasetVRViewController.swift
//  PlotAR
//
//  Created by Philipp Thomann on 15.09.18.
//  Copyright © 2018 Philipp Thomann. All rights reserved.
//

import UIKit
import SceneKit

class DatasetVRViewController: UIViewController, GVRRendererViewControllerDelegate, DatasetViewController {
    
    var sceneNode: SCNNode!
    var scene: SCNScene!
    var datasetHandler: DatasetHandler = DatasetHandler()

    func renderer(for displayMode: GVRDisplayMode) -> GVRRenderer! {
        print("Creating DatasetRenderer for \(displayMode.rawValue)")
        return DatasetVRRenderer(scene: datasetHandler.makeSCNScene(), datasetHandler: datasetHandler)
    }
    
    func shouldHideTransitionView() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadVRViewController(self)
    }
    
    func loadVRViewController(_ view: UIViewController){
        // This function is used both on viewDidLoad as well as directly from the DatasetTableViewCellController
        
        // Create a new scene
        scene = SCNScene()
        
        sceneNode = datasetHandler.makeSceneNode()
        scene.rootNode.addChildNode(sceneNode)
        
        // The following comes from the TreasureHunt Sample,
        // TreasureHuntViewController.m
        
        view.view.backgroundColor = UIColor.white;
        
        let renderer: GVRRenderer = DatasetVRRenderer(scene: scene, datasetHandler: datasetHandler)
        
        // Embedded (widget) view with its own view controller.
        guard let viewController = GVRRendererViewController(renderer: renderer) else { return }
        viewController.delegate = self
        viewController.view.frame = CGRect(x:20, y:50, width:self.view.bounds.size.width - 40, height:200)
        viewController.view.autoresizingMask = .flexibleWidth
        viewController.rendererView.vrModeEnabled = true
        // insted of the sample:
//            self.view.addSubview(viewController.view)
//            self.addChildViewController(viewController)
        // we do:
        view.present(viewController, animated: false)
    }
    
    func navigationControllerSupportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        // doesn't work :\
        return UIInterfaceOrientationMask.landscapeRight
        
    }

}

//
//  DatasetTableViewController.swift
//  PlotAR
//
//  Created by Philipp Thomann on 17.12.17.
//  Copyright © 2017 Philipp Thomann. All rights reserved.
//

import UIKit
import os.log
import ARKit

class DatasetTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var datasets = [Dataset]()
    
    var servers = [Server]()
    
    var activeServer: Server?

    //MARK: Private Methods
    
    private func loadSampleDatasets() {
        let iris = Dataset()
        iris.name = "Iris"
//        let choco: Dataset = Dataset(file:"smi_choco", verbose: false)
//        datasets += [iris]
        datasets += Dataset.listDatasets(verbose: false)
        
//        Dataset.listDatasets()
        
    }
    
    fileprivate func setServerUrls(_ arr: [String]) {
        UserDefaults.standard.set(arr, forKey: "serverUrls")
    }
    
    func addServer(_ url: URL) {
        //                    let dataset = Dataset(url: url)
        //                    self.datasets.append(dataset)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.path = ""
        let baseurl = components.url!
        let absUrl = baseurl.absoluteString
        var arr = self.getServerUrls()
        if !arr.contains(absUrl) {
            self.servers.insert(Server(url: baseurl), at: 0)
            arr.insert(absUrl, at: 0)
            setServerUrls(arr)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addDataset(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Server", message: "Enter a URL", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "http://10.0.0.15:2908/"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text ?? "nil")")
            if let code = textField?.text {
                if let url = URL(string: code){
                    self.addServer(url)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    @IBAction func addDatasetCamera(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func showTypeValueChanged(_ sender: Any) {
        UserDefaults.standard.set(showType.selectedSegmentIndex, forKey: "ShowTypeIndex")
    }
    
    fileprivate func getServerUrls() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "serverUrls") ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let showTypeIndex = UserDefaults.standard.integer(forKey: "ShowTypeIndex")
        showType.selectedSegmentIndex = showTypeIndex
        if !ARWorldTrackingConfiguration.isSupported {
            showType.setEnabled(false, forSegmentAt: 0)
            if showType.selectedSegmentIndex == 0 {
                showType.selectedSegmentIndex = 1
            }
        }
        
        loadSampleDatasets()
        
        self.servers = getServerUrls().map { Server(string: $0) }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return servers.count
        }
        return datasets.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Servers"
        default:
            return "Datasets"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DatasetTableViewCell", for: indexPath) as? DatasetTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DatasetTableViewCell.")
        }
        
        if indexPath.section == 0 {
            let s = servers[indexPath.row]
            cell.nameLabel.text = s.url.absoluteString
            cell.iconImageView.image = nil
        } else {
            // Fetches the appropriate meal for the data source layout.
            let d = datasets[indexPath.row]
            
            cell.nameLabel.text = d.name
            cell.iconImageView.image = d.icon
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                let s = servers[indexPath.row]
                if activeServer != nil && activeServer! === s {
                    activeServer = nil
                }
                servers.remove(at: indexPath.row)
                var urls = getServerUrls()
                urls.remove(at: indexPath.row)
                setServerUrls(urls)
            } else {
                datasets.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
//    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//
//    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let destinationTitle = showType.titleForSegment(at: showType.selectedSegmentIndex) {
            performSegue(withIdentifier: "Show "+destinationTitle, sender: indexPath)
        }
    }
    
    // MARK: - Navigation

    @IBOutlet weak var showType: UISegmentedControl!
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    fileprivate func prepareDatasetViewController(_ indexPath: IndexPath, _ destinationViewController: DatasetViewController) {
        let selectedItem: Dataset
        if indexPath.section == 0 {
            let s = servers[indexPath.row]
            activeServer = s
            selectedItem = s.dataset
        } else {
            selectedItem = datasets[indexPath.row]
        }
        if activeServer == nil && servers.count > 0 {
            // connect to top server
            activeServer = servers[0]
        }
        destinationViewController.datasetHandler.dataset = selectedItem
        if let s = activeServer {
            s.delegate = destinationViewController.datasetHandler
            s.ensureConnect()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing for segue: \(segue.identifier ?? "nil")")
        print(showType.selectedSegmentIndex)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new dataset.", log: OSLog.default, type: .debug)
            
        case "QR Scan":
            os_log("QR Scan.", log: OSLog.default, type: .debug)
            guard let destinationViewController = segue.destination as? ScannerViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            destinationViewController.dvc = self
            
        case "Show VR", "Show AR", "Show 3D":
            if let indexPath = sender as? IndexPath {
                print("Showing \(indexPath)")
                guard let destinationViewController = segue.destination as? DatasetViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                prepareDatasetViewController(indexPath, destinationViewController)
            }
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
        
    }
    /* TODO check this
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter details?", message: "Enter your name and email", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let name = alertController.textFields?[0].text
            let email = alertController.textFields?[1].text
            
            self.labelMessage.text = "Name: " + name! + "Email: " + email!
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Email"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
 */
}

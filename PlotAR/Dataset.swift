//
//  data.swift
//  PlotAR
//
//  Created by Philipp Thomann on 20.09.17.
//  Copyright © 2017 Philipp Thomann. All rights reserved.
//

import Foundation

class Dataset {
    
    var name: String = ""
    var icon: UIImage?
    var url: URL?
    
    var data: [[Double]] = [[  5.1,3.5,1.4,1],[4.9,3,1.4,1],[4.7,3.2,1.3,1],[4.6,3.1,1.5,1],[5,3.6,1.4,1],[5.4,3.9,1.7,1],[4.6,3.4,1.4,1],[5,3.4,1.5,1],[4.4,2.9,1.4,1],[4.9,3.1,1.5,1],[5.4,3.7,1.5,1],[4.8,3.4,1.6,1],[4.8,3,1.4,1],[4.3,3,1.1,1],[5.8,4,1.2,1],[5.7,4.4,1.5,1],[5.4,3.9,1.3,1],[5.1,3.5,1.4,1],[5.7,3.8,1.7,1],[5.1,3.8,1.5,1],[5.4,3.4,1.7,1],[5.1,3.7,1.5,1],[4.6,3.6,1,1],[5.1,3.3,1.7,1],[4.8,3.4,1.9,1],[5,3,1.6,1],[5,3.4,1.6,1],[5.2,3.5,1.5,1],[5.2,3.4,1.4,1],[4.7,3.2,1.6,1],[4.8,3.1,1.6,1],[5.4,3.4,1.5,1],[5.2,4.1,1.5,1],[5.5,4.2,1.4,1],[4.9,3.1,1.5,1],[5,3.2,1.2,1],[5.5,3.5,1.3,1],[4.9,3.6,1.4,1],[4.4,3,1.3,1],[5.1,3.4,1.5,1],[5,3.5,1.3,1],[4.5,2.3,1.3,1],[4.4,3.2,1.3,1],[5,3.5,1.6,1],[5.1,3.8,1.9,1],[4.8,3,1.4,1],[5.1,3.8,1.6,1],[4.6,3.2,1.4,1],[5.3,3.7,1.5,1],[5,3.3,1.4,1],[7,3.2,4.7,2],[6.4,3.2,4.5,2],[6.9,3.1,4.9,2],[5.5,2.3,4,2],[6.5,2.8,4.6,2],[5.7,2.8,4.5,2],[6.3,3.3,4.7,2],[4.9,2.4,3.3,2],[6.6,2.9,4.6,2],[5.2,2.7,3.9,2],[5,2,3.5,2],[5.9,3,4.2,2],[6,2.2,4,2],[6.1,2.9,4.7,2],[5.6,2.9,3.6,2],[6.7,3.1,4.4,2],[5.6,3,4.5,2],[5.8,2.7,4.1,2],[6.2,2.2,4.5,2],[5.6,2.5,3.9,2],[5.9,3.2,4.8,2],[6.1,2.8,4,2],[6.3,2.5,4.9,2],[6.1,2.8,4.7,2],[6.4,2.9,4.3,2],[6.6,3,4.4,2],[6.8,2.8,4.8,2],[6.7,3,5,2],[6,2.9,4.5,2],[5.7,2.6,3.5,2],[5.5,2.4,3.8,2],[5.5,2.4,3.7,2],[5.8,2.7,3.9,2],[6,2.7,5.1,2],[5.4,3,4.5,2],[6,3.4,4.5,2],[6.7,3.1,4.7,2],[6.3,2.3,4.4,2],[5.6,3,4.1,2],[5.5,2.5,4,2],[5.5,2.6,4.4,2],[6.1,3,4.6,2],[5.8,2.6,4,2],[5,2.3,3.3,2],[5.6,2.7,4.2,2],[5.7,3,4.2,2],[5.7,2.9,4.2,2],[6.2,2.9,4.3,2],[5.1,2.5,3,2],[5.7,2.8,4.1,2],[6.3,3.3,6,3],[5.8,2.7,5.1,3],[7.1,3,5.9,3],[6.3,2.9,5.6,3],[6.5,3,5.8,3],[7.6,3,6.6,3],[4.9,2.5,4.5,3],[7.3,2.9,6.3,3],[6.7,2.5,5.8,3],[7.2,3.6,6.1,3],[6.5,3.2,5.1,3],[6.4,2.7,5.3,3],[6.8,3,5.5,3],[5.7,2.5,5,3],[5.8,2.8,5.1,3],[6.4,3.2,5.3,3],[6.5,3,5.5,3],[7.7,3.8,6.7,3],[7.7,2.6,6.9,3],[6,2.2,5,3],[6.9,3.2,5.7,3],[5.6,2.8,4.9,3],[7.7,2.8,6.7,3],[6.3,2.7,4.9,3],[6.7,3.3,5.7,3],[7.2,3.2,6,3],[6.2,2.8,4.8,3],[6.1,3,4.9,3],[6.4,2.8,5.6,3],[7.2,3,5.8,3],[7.4,2.8,6.1,3],[7.9,3.8,6.4,3],[6.4,2.8,5.6,3],[6.3,2.8,5.1,3],[6.1,2.6,5.6,3],[7.7,3,6.1,3],[6.3,3.4,5.6,3],[6.4,3.1,5.5,3],[6,3,4.8,3],[6.9,3.1,5.4,3],[6.7,3.1,5.6,3],[6.9,3.1,5.1,3],[5.8,2.7,5.1,3],[6.8,3.2,5.9,3],[6.7,3.3,5.7,3],[6.7,3,5.2,3],[6.3,2.5,5,3],[6.5,3,5.2,3],[6.2,3.4,5.4,3],[5.9,3,5.1,3 ]]
    var col: [Double]?
    var label: [String]?
    var size: [Double]?
    
    func getUrlForFile(file:String, verbose: Bool = false) -> URL? {
        return Bundle.main.url(forResource: file, withExtension: "json")//, subdirectory: "datasets")
    }
    
    static func listDatasets(verbose: Bool = false) -> [Dataset] {
        let urls = Bundle.main.urls(forResourcesWithExtension: ".json", subdirectory: nil) ?? []
        return urls.map { url in Dataset(url: url, verbose: verbose)}
    }
    
    init(file: String? = nil, verbose: Bool = false) {
        if file != nil {
            self.name = file!
            if let url = getUrlForFile(file: file!, verbose: verbose) {
            //        print(String(data: data!, encoding: .utf8) ?? "(No Data)")
                load(url: url, verbose: verbose)
            }
            
        }
    }
    
    init(url: URL, verbose: Bool = false) {
        load(url: url, verbose: verbose)
    }
    
    func reload() {
        if let u = url { load(url: u) }
    }
    
    func load(url: URL, verbose: Bool = false) {
        print("Loading \( url )")
        if verbose {
            print("Loading \( url )")
        }
        self.url = url
        if name == "" {
            name = url.pathComponents.last ?? url.path
        }
        var fixedUrl = url
        if url.pathExtension != "json" {
            fixedUrl = url.appendingPathComponent("data.json", isDirectory: false)
        }
        print(fixedUrl)
        do {
            let data = try Data(contentsOf: fixedUrl)
            if verbose {
//                print(data)
            }
            let json = try? JSONSerialization.jsonObject (with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            if let dictionary = json as? [String: Any] {
                
                for (key, value) in dictionary {
                    let valString = value as? String ?? "(No value)"
                    print("\(key): \( valString.prefix(100) )")
                }
                
                if let vals = dictionary["data"] as? [[Double]] {
                    self.data = vals
                }
                if let vals = dictionary["col"] as? [Double] {
                    self.col = vals
                }
                if let vals = dictionary["size"] as? [Double] {
                    self.size = vals
                }
                if let vals = dictionary["label"] as? [String] {
                    self.label = vals
                }
            } else {
                print("Could not load data")
            }
        } catch {
            print ("File Read Error")
        }
    }
}

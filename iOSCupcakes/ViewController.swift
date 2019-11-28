//
//  ViewController.swift
//  iOSCupcakes
//
//  Created by John Kouris on 11/28/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var cupcakes = [Cupcake]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        let url = URL(string: "http://localhost:8080/cupcakes")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Error \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let decoder = JSONDecoder()
            
            if let cakes = try? decoder.decode([Cupcake].self, from: data) {
                DispatchQueue.main.async {
                    self.cupcakes = cakes
                    self.tableView.reloadData()
                    print("Loaded \(cakes.count) cupcakes.")
                }
            } else {
                print("Unable to parse JSON response.")
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cupcakes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cake = cupcakes[indexPath.row]
        
        cell.textLabel?.text = "\(cake.name) - $\(cake.price)"
        cell.detailTextLabel?.text = cake.description
        
        return cell
    }


}


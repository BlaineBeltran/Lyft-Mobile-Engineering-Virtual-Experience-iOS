//
//  RideHistoryViewController.swift
//  RideSharer
//
//  Created by Blaine Beltran on 4/28/22.
//

import UIKit

class RideHistoryViewController: UIViewController {
    
    let rideHistory = [("Driver: Joe, 12/29/2021", "$26.50"),
                       ("Driver: Sandra, 01/03/2022", "$13.10"),
                       ("Driver: Hank, 01/11/2022", "$16.20"),
                       ("Driver: Michelle, 01/19/2022", "$8.50")]
    
    @IBOutlet weak var rideHistoryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rides"
        navigationController?.navigationBar.prefersLargeTitles = true
        rideHistoryTableView.delegate = self
        rideHistoryTableView.dataSource = self
        rideHistoryTableView.register(UITableViewCell.self,
                                      forCellReuseIdentifier: Constants.rideShareTableViewCellIdentifier )
        
    }
    
}


// MARK: - rideHistoryTableView Delegate and Datasource
extension RideHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.rideShareTableViewCellIdentifier,
                                                 for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = rideHistory[indexPath.row].0
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Configure Price Alert
        let title = NSLocalizedString("Price", comment: "Title for price alert")
        let message = NSLocalizedString("\(rideHistory[indexPath.row].1)", comment: "Price for driver")
        let priceAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionTitle = NSLocalizedString("OK", comment: "OK action title")
        let OKAction = UIAlertAction(title: actionTitle, style: .default) { [weak self] action in
            
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }
        priceAlert.addAction(OKAction)
        present(priceAlert, animated: true, completion: nil)
    }
}


// MARK: - String Constants
struct Constants {
    
    static let rideShareTableViewCellIdentifier = "rideHistoryCell"
}


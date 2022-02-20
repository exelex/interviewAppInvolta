//
//  MessagesViewController.swift
//  interviewAppInvolta
//
//  Created by Alexey Il on 20.02.2022.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var messagesList = [String]() // array of messages
    
    private let baseURL = "https://a-prokudin.node-api.numerology.dev-01.h.involta.ru/getMessages?"
    var url: URL{ return URL(string: "\(baseURL)offset=\(currentRow)")! }
    
    var currentRow: Int = 0

    private let cellId = "id"
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(MessageItemCell.self, forCellReuseIdentifier: cellId)
        self.tableView.separatorStyle = .none

        let loadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.tableView.register(loadingCellNib, forCellReuseIdentifier: "loadingcellid")

        // rotate table 180 deg
        tableView.transform = CGAffineTransform(rotationAngle: (-.pi))
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                       left: 0,
                                                       bottom: 0,
                                                       right: tableView.bounds.size.width - 10)
        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return messagesList.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageItemCell
            cell.messageLabel.text = messagesList[indexPath.row]
            cell.transform = CGAffineTransform(rotationAngle: (-.pi)) // rotate cell of table 180 deg
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingcellid", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            cell.transform = CGAffineTransform(rotationAngle: (-.pi)) // rotate cell of table 180 deg
            return cell
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.height * 2) && !isLoading {
            loadData()
        }
    }
    
    
    // MARK: - Network
    func loadData() {
        if !self.isLoading {
            self.isLoading = true
            
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url) { data, response, error in
                guard let messages = try? JSONDecoder().decode(MessagesList.self, from: data!) else {
                    self.isLoading = false
                    self.showAlert()
                    
                    return
                }
                self.messagesList += messages.result
                
                sleep(1) // simulation of long loading
                self.currentRow += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                }
            }.resume()
        }
    }
    
    // MARK: - Network problem alert
    func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: "Ошибка загрузки данных. Пожалуйста, подождите.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.loadData()
            }))
        
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

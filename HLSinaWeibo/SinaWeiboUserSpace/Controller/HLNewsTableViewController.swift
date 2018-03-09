//
//  HLNewsTableViewController.swift
//  HLSinaWeibo
//
//  Created by jsbios on 2018/3/8.
//  Copyright © 2018年 Dianzhi. All rights reserved.
//

import UIKit


fileprivate let newsCellID = "HLNewsTableViewCell"

class HLNewsTableViewController: UITableViewController {

    public var coverHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: newsCellID)
        tableView.sectionHeaderHeight = coverHeight
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if coverHeight > 0 {
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellID)
        cell?.textLabel?.text = String.init(format: " sina news,cell id = %d ", indexPath.row)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print("coverHeight = \(coverHeight)")
        return coverHeight
    }
}

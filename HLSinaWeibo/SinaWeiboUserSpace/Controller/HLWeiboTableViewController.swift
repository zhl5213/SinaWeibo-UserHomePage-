//
//  HLWeiboTableViewController.swift
//  HLSinaWeibo
//
//  Created by jsbios on 2018/3/8.
//  Copyright © 2018年 Dianzhi. All rights reserved.
//

import UIKit

fileprivate let weiboCellID = "HLWeiboTableViewCell"

class HLWeiboTableViewController: UITableViewController {

    public var coverHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: weiboCellID)
        tableView.sectionHeaderHeight = coverHeight
        if coverHeight > 0 {
            tableView.reloadData()
        }
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
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
        let cell = tableView.dequeueReusableCell(withIdentifier: weiboCellID)
        cell?.textLabel?.text = String.init(format: "weibo content,cell id = %d ", indexPath.row)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return coverHeight
    }

}

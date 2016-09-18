//
//  UIViewControllerDemo.swift
//  RefreshDemo
//
//  Created by bruce on 16/4/25.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit
import RefreshView

class UIViewControllerDemo: UIViewController {

    var array = [String]()
    @IBOutlet var tableView: UITableView!

    func beginRefresh() {
        self.tableView.refreshHeader?.autoBeginRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        for i in 0...20 {
//            self.array.append(String(i))
//        }

        //self.tableView.tableFooterView = UIView()
        //self.tableView.isShowLoadingView = true

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(beginRefresh))

        self.tableView.refreshHeader = CustomRefreshHeaderView.headerWithRefreshingBlock {
            let minseconds = 3 * Double(NSEC_PER_SEC)
            let dtime = DispatchTime.now() + Double(Int64(minseconds)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dtime, execute: {
                for i in 0...20 {
                    self.array.append(String(i))
                }
                self.tableView.refreshHeader?.endRefreshing()
                self.tableView.reloadData()
//                self.tableView.isShowLoadingView = false
            })
        }

//        let minseconds = 3 * Double(NSEC_PER_SEC)
//        let dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
//        dispatch_after(dtime, dispatch_get_main_queue(), {
//            for i in 0...5 {
//                self.array.append(String(i))
//            }
//            self.tableView.isShowLoadingView = false
//            self.tableView.reloadData()
//        })

        self.tableView.refreshFooter = CustomRefreshFooterView.footerWithRefreshingBlock({
            let minseconds = 1 * Double(NSEC_PER_SEC)
            let dtime = DispatchTime.now() + Double(Int64(minseconds)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dtime, execute: {
                let count = self.array.count
                for i in count+1...count+5 {
                    self.array.append(String(i))
                    self.tableView.reloadData()
                }
                self.tableView.refreshFooter?.endRefreshing()
                self.tableView.refreshFooter?.isShowLoadingView = (self.array.count < 25)
            })
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIViewControllerDemo: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CELL")
        }
        cell?.textLabel?.text = "CELL"
        return cell!
    }
}

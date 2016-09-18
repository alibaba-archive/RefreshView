//
//  SecondViewController.swift
//  RefreshDemo
//
//  Created by ZouLiangming on 16/1/25.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit
import RefreshView


class SecondViewController: UITableViewController {

    var content = [String]()


    func beginRefresh() {
        self.tableView.refreshHeader?.autoBeginRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.isShowLoadingView = true
        self.tableView.loadingView?.offsetY = 30

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(beginRefresh))

        let minseconds = 2 * Double(NSEC_PER_SEC)
        let dtime = DispatchTime.now() + Double(Int64(minseconds)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dtime, execute: {
            for i in 1...10 {
                self.content.append(String(i))
                self.tableView.reloadData()
                self.tableView.isShowLoadingView = false
                self.tableView.refreshFooter?.isShowLoadingView = true
            }
        })

        self.tableView.refreshHeader = CustomRefreshHeaderView.headerWithRefreshingBlock(UIColor.white, startLoading: {
            let minseconds = 3 * Double(NSEC_PER_SEC)
            let dtime = DispatchTime.now() + Double(Int64(minseconds)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dtime, execute: {
                let count = self.content.count
                for i in count+1...count+5 {
                    self.content.append(String(i))
                    self.tableView.reloadData()
                }
                self.tableView.refreshHeader?.endRefreshing()
                self.tableView.refreshFooter?.isShowLoadingView = false
            })
        })

        self.tableView.refreshFooter = CustomRefreshFooterView.footerWithLoadingText("Loading More Data", startLoading: {
            let minseconds = 1 * Double(NSEC_PER_SEC)
            let dtime = DispatchTime.now() + Double(Int64(minseconds)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dtime, execute: {
                let count = self.content.count
                for i in count+1...count+5 {
                    self.content.append(String(i))
                    self.tableView.reloadData()
                }
                self.tableView.refreshFooter?.endRefreshing()
                self.tableView.refreshFooter?.isShowLoadingView = count < 20
            })
        })
    }

    func dismiss() {
        self.tableView.refreshHeader?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASIC", for: indexPath)
        cell.textLabel?.text = self.content[(indexPath as NSIndexPath).row]

        return cell
    }
}

//
//  ViewController.swift
//  YBAutoReload
//
//  Created by Yogendra Bagoriya on 27/09/16.
//  Copyright © 2016 Yogendra Bagoriya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    var EndDisplayCellId = ""
    var WillDisplayCellId = ""
    var dataList = NSMutableArray()
    var loadNumber = 0
    var newFetchBool = 0
    
    @IBOutlet weak var dataTV : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //  This will fetch data from server and will reload table vie
    func fetchDataFromServer()
    {
        /**
         * https://jsonplaceholder.typicode.com/posts/1/comments
         * https://jsonplaceholder.typicode.com/posts/2/comments
         * https://jsonplaceholder.typicode.com/posts/3/comments
         * https://jsonplaceholder.typicode.com/posts/4/comments
         */
        
        loadNumber += 1
        let urlStr = String(format: "https://jsonplaceholder.typicode.com/posts/\(loadNumber)/comments")
        let url = URL(string: urlStr)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, reponse, error) in
            if(data != nil)
            {
                do
                {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! NSMutableArray
                    for item in jsonData
                    {
                        self.dataList.add(item)
                    }
                    print(jsonData)
                    DispatchQueue.main.async(execute: {
                        self.dataTV.reloadData()
                    })
                }
                catch{
                    print("Error in catch block")
                }
            }
            else{
                
            }
        }
        task.resume()
    }
    
    
    // MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell!
        
        if((indexPath as NSIndexPath).row < dataList.count)
        {
            // Code for show your data set
            cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
            if (cell == nil)
            {
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CellIdentifier")
            }
            cell.textLabel?.text = (dataList[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "email") as? String
            return cell!
        }
        else{
            // Code to show Refersh cell
            let refreshCell = tableView.dequeueReusableCell(withIdentifier: "RefreshCellIdentifier") as! RefreshCellView
            refreshCell.startStopLoading(false)
            return refreshCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        newFetchBool = 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        newFetchBool += 1
    }
    
    //MARK:- ScrollView Delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if(decelerate && newFetchBool >= 2 && scrollView.contentOffset.y >= 0)
        {
            let tv =  scrollView as! UITableView
            let lastCellIndexPath = IndexPath(row:dataList.count , section: 0)
            let refreshCell = tv.cellForRow(at: lastCellIndexPath) as! RefreshCellView
            refreshCell.startStopLoading(true)
            self.fetchDataFromServer()
            newFetchBool = 0
        }
        else if(!decelerate)
        {
            newFetchBool = 0
        }
    }
}


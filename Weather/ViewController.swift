//
//  ViewController.swift
//  Weather
//
//  Created by 沙庭宇 on 2/29/16.
//  Copyright © 2016 tingyusha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var forecast: UITableView!
    let images: [UIImage] = [UIImage(named: "中雨")!]
    
    let urlQuest = NSURLRequest(URL: NSURL(string: "http://apis.haoservice.com/weather?cityname=%E4%B8%8A%E6%B5%B7&key=48ecd916ae274022ab58ce7743a44ed9")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecast.dataSource = self
        forecast.delegate = self
        getTodayTemperatrue()
    }
    
    func getTodayTemperatrue() {
        //          获得返回的Json对象
        NSURLConnection.sendAsynchronousRequest(urlQuest, queue: NSOperationQueue()) { (response, data, e) -> Void in
            if  let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary  {
                    //              逐步解析Json对象，获得所需要的值
                    let result = json.valueForKey("result")
                    let today = result!.valueForKey("today")!
                    //                  异步加载到主线程，提高界面更新速度
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.city.text = today.valueForKey("city") as? String
                        self.week.text = today.valueForKey("week") as? String
                        self.temperature.text = today.valueForKey("temperature") as? String
                    })
            }
        }
//        self.city.text = "上海"
//        self.week.text = "星期一"
//        self.temperature.text = "12"
        
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2 {
        return 70
        }
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 1
        case 2:
            return 5
        default:
            return 1
        }
       
    }
    
    //根据不同section返回不同cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let weekCell = forecast.dequeueReusableCellWithIdentifier("otherTemperature")! as UITableViewCell
            let weeks:UILabel = weekCell.viewWithTag(1) as! UILabel
            let temperatures:UILabel = weekCell.viewWithTag(2) as! UILabel
            let weathers:UILabel = weekCell.viewWithTag(3) as! UILabel
            weathers.textAlignment = NSTextAlignment.Center
            let weatherImg:UIImageView = weekCell.viewWithTag(4) as! UIImageView

            NSURLConnection.sendAsynchronousRequest(urlQuest, queue: NSOperationQueue()) { (response, data, e) -> Void in
                let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                if json != nil {
                    let result = json?.valueForKey("result")
                    let future = result?.valueForKey("future")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        weeks.text = future![indexPath.row].valueForKey("week") as? String
                        temperatures.text = future![indexPath.row].valueForKey("temperature") as? String
                        weathers.text = future![indexPath.row].valueForKey("weather") as? String
                        weatherImg.image = UIImage(named: weathers.text!)
                    })
                }
            }
//            weeks.text = "星期"
//            temperatures.text = "12~13"
//            weathers.text = "晴"
//            weatherImg.image = UIImage(named: "中雨")
            return weekCell
        case 1:
            let cell2 = "cell2"
            let todayCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cell2)
            let summarize = UILabel(frame: CGRect(x: 15, y: 5, width: 280, height: 60))
            summarize.numberOfLines = 2
            summarize.text = "Today:Haze currently.It's 18;the high today was forecast as 21"
            todayCell.addSubview(summarize)
            forecast.addSubview(todayCell)
            return todayCell
        case 2:
            let cell3 = "cell3"
            let otherCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cell3)
            let otherText = UILabel(frame: CGRect(x: 15, y: 5, width: 280, height: 60))
            otherText.numberOfLines = 2
            for index in 1...5 {
                otherText.text = "Sunrise: \(indexPath.row)\nSunset: \(index)"
            }
            otherText.textAlignment = NSTextAlignment.Center
            otherCell.addSubview(otherText)
            forecast.addSubview(otherCell)
            return otherCell
        default:
            let nilCellID = "nilCell"
            let nilCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nilCellID)
            nilCell.textLabel?.text = "DIY"
            forecast.addSubview(nilCell)
            return nilCell
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


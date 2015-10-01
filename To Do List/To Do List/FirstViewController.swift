//
//  FirstViewController.swift
//  To Do List
//
//  Created by Kyle Boss on 9/13/15.
//  Copyright © 2015 Kyle Boss. All rights reserved.
//

import UIKit

var toDoList = [AnyObject]()

class FirstViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var addTaskTxt: UITextField!
    @IBOutlet weak var table: UITableView!
    var imageView: UIImageView!
    var amountOfIgnoredEventsSoFar = 0;
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numInactiveItems = 0;
        var now = NSDate();
        var totalActiveItems:Int;
        for item in toDoList {
//            if (item["isComplete"] as! Bool == true && daysFrom(now, dateTo: item["dateCompleted"] as! NSDate) > 1) {
//                numInactiveItems++
//            }
            
            if (item["isComplete"] as! Bool == true && daysFrom(item["dateCompleted"] as! NSDate, dateTo: now) > 1) {
                numInactiveItems++
            }
        }
        totalActiveItems = toDoList.count - numInactiveItems
        return totalActiveItems
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    @IBAction func addTaskAction(sender: AnyObject) {
        addTaskBtn.userInteractionEnabled = false
        addTaskBtn.alpha = 0.5
        let newItem:NSMutableDictionary = ["text": addTaskTxt.text!, "isComplete": false, "dateCreated": NSDate()]
        toDoList.append(newItem)
        addTaskTxt.text = ""
        NSUserDefaults.standardUserDefaults().setObject(toDoList, forKey: "toDoList")
        table.reloadData()
        self.view.endEditing(true);
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @IBAction func completeButton(sender: UIButton) {
        let item                = toDoList[sender.tag] as! NSMutableDictionary
        let newCompleteStatus   = !(item["isComplete"] as! Bool == true)
        let newItem             = NSMutableDictionary()
        newItem["isComplete"]   = newCompleteStatus
        newItem["text"]         = item["text"]
        newItem["dateCreated"]  = item["dateCreated"]
        
        if newItem["isComplete"] as! Bool == true {
            newItem["dateCompleted"] = NSDate()
        }
        
        toDoList[sender.tag] = newItem
        
        let selectedImg     = UIImage(named: "selected.png") as UIImage!
        let unselectedImg   = UIImage(named: "unselected.png") as UIImage!
        
        if (toDoList[sender.tag]["isComplete"] as? Bool == true) {
            sender.setImage(selectedImg, forState: UIControlState.Normal)
        } else {
            sender.setImage(unselectedImg, forState: UIControlState.Normal)
        }
        table.reloadData()
    }
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        let selectedImg     = UIImage(named: "selected.png")
        let unselectedImg   = UIImage(named: "unselected.png")
        var now = NSDate();
        var cursor = indexPath.row+amountOfIgnoredEventsSoFar
        while(true) {
            cursor = indexPath.row+amountOfIgnoredEventsSoFar
//            if (cursor > toDoList.count) break;
//            if (toDoList[cursor]["isComplete"] as! Bool == true && daysFrom(now, dateTo: toDoList[cursor]["dateCompleted"] as! NSDate) > 1) {
//            if (toDoList[cursor]["isComplete"] as! Bool == true) {
//                print(secondsFrom(now, dateTo: toDoList[cursor]["dateCompleted"] as! NSDate))
//            }
            if (toDoList[cursor]["isComplete"] as! Bool == true && daysFrom(toDoList[cursor]["dateCompleted"] as! NSDate, dateTo: now) > 1) {
                amountOfIgnoredEventsSoFar++
            } else {
                break;
            }
        }
        cursor = indexPath.row+amountOfIgnoredEventsSoFar

        var itemTitleStr = cell.itemTitle.text;
        
        var subviews = cell.contentView.subviews;
        for subview in subviews {
            if subview.layer.shadowOpacity == 0.5 {
                subview.removeFromSuperview();
            }
        }
        cell.contentView.backgroundColor        = UIColor.clearColor()
        let whiteRoundedView : UIView           = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width-30, 50))
        if (toDoList[cursor]["isComplete"] as! Bool == true) {
            whiteRoundedView.layer.backgroundColor  = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 1.0, 0.0, 0.6])
        } else {
            whiteRoundedView.layer.backgroundColor  = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.0, 0.0, 0.0, 0.6])
        }
        whiteRoundedView.layer.masksToBounds    = false
        whiteRoundedView.layer.cornerRadius     = 3.0
        whiteRoundedView.layer.shadowOffset     = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity    = 0.5
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        var backView = UIView();
        cell.backgroundView = backView;
        
        cell.completeButton.tag = cursor
        cell.layer.cornerRadius = 5.0
        
        if ((toDoList[cursor]["text"]) != nil) {
            itemTitleStr = (toDoList[cursor]["text"] as? String)!
        }
        
        let attrTitle: NSMutableAttributedString =  NSMutableAttributedString(string: itemTitleStr!)
        attrTitle.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attrTitle.length))
        
        if (toDoList[cursor]["isComplete"] as? Bool == true) {
            cell.itemTitle.attributedText = attrTitle;
            cell.completeButton.setImage(selectedImg, forState: UIControlState.Normal)
        } else {
            cell.itemTitle.text = itemTitleStr;
            cell.completeButton.setImage(unselectedImg, forState: UIControlState.Normal)
        }
        NSUserDefaults.standardUserDefaults().setObject(toDoList, forKey: "toDoList")
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        return cell;
    }
    
    func daysFrom(dateFrom:NSDate, dateTo:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: dateFrom, toDate: dateTo, options: []).day
    }
    
    func secondsFrom(dateFrom:NSDate, dateTo:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: dateFrom, toDate: dateTo, options: []).second
    }
    
    override func viewDidAppear(animated: Bool) {
        var tempToDoList = [AnyObject]();
        if NSUserDefaults.standardUserDefaults().arrayForKey("toDoList") != nil {
            tempToDoList = NSUserDefaults.standardUserDefaults().arrayForKey("toDoList")!
            toDoList = [AnyObject]()
            for currentItem in tempToDoList {
                toDoList.append(currentItem)
            }
        }
        var backgroundImg = UIImage(named: "background.jpg")
        var imageView = UIImageView(image: backgroundImg)
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImg
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        table.rowHeight = 70;
        table.reloadData()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            var cursor = indexPath.row + amountOfIgnoredEventsSoFar
        if editingStyle == UITableViewCellEditingStyle.Delete {
            toDoList.removeAtIndex(cursor)
            NSUserDefaults.standardUserDefaults().setObject(toDoList, forKey: "toDoList")
            table.reloadData()
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if !textField.text!.isEmpty {
            addTaskBtn.userInteractionEnabled = true
            addTaskBtn.alpha = 1
        } else {
            addTaskBtn.userInteractionEnabled = false
            addTaskBtn.alpha = 0.5
        }
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func viewDidLoad() {
//        let appDomain = NSBundle.mainBundle().bundleIdentifier!
//        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        addTaskBtn.userInteractionEnabled = false
        addTaskBtn.alpha = 0.5
        var amountOfIgnoredEventsSoFar = 0;
        self.tabBarController?.tabBar.translucent = true;
        self.tabBarController!.tabBar.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.75)
        self.tabBarController!.tabBar.backgroundImage = UIImage()
        self.tabBarController!.tabBar.barTintColor = UIColor.clearColor()

        var attributeDict = [String:NSObject]();
        attributeDict = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        addTaskTxt.attributedPlaceholder = NSAttributedString(string:"Add task...",
            attributes: attributeDict)
        addTaskTxt.frame.size = CGSize(width: addTaskTxt.frame.size.width, height: 40)
        addTaskTxt.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingChanged)
        
        let addBtnImg = UIImage(named: "plus-big.png")
        addTaskBtn.setImage(addBtnImg, forState: UIControlState.Normal)
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


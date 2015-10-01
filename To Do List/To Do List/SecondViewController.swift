//
//  SecondViewController.swift
//  To Do List
//
//  Created by Kyle Boss on 9/13/15.
//  Copyright © 2015 Kyle Boss. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var task: UITextField!
    @IBAction func addTask(sender: AnyObject) {
        let newItem:NSMutableDictionary = ["text": task.text!, "isComplete": false, "dateCreated": NSDate()]
        toDoList.append(newItem)
        task.text = ""
        NSUserDefaults.standardUserDefaults().setObject(toDoList, forKey: "toDoList")
        tabBarController!.selectedIndex = 0;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
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
    
    override func viewDidAppear(animated: Bool) {
        addTaskBtn.userInteractionEnabled = false
        addTaskBtn.alpha = 0.5
        var backgroundImg = UIImage(named: "background.jpg")
        var imageView = UIImageView(image: backgroundImg)
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImg
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    override func viewDidLoad() {
        addTaskBtn.layer.cornerRadius = 15
        task.font =  UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        task.frame.size = CGSize(width: task.frame.size.width, height: 100)
        task.layer.cornerRadius = 15
        var attributeDict = [String:NSObject]();
        attributeDict = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        task.attributedPlaceholder = NSAttributedString(string:"Type task...",
            attributes: attributeDict)
        self.tabBarController?.tabBar.translucent = true;
        self.tabBarController!.tabBar.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.90)
        self.tabBarController!.tabBar.backgroundImage = UIImage()
        self.tabBarController!.tabBar.barTintColor = UIColor.clearColor()
        task.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingChanged)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


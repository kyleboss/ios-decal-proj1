//
//  SecondViewController.swift
//  To Do List
//
//  Created by Kyle Boss on 9/13/15.
//  Copyright © 2015 Kyle Boss. All rights reserved.
//

import UIKit

class DailyStatsViewController: UIViewController {
    
    @IBOutlet weak var totalCompletedTasksToday: UILabel!
    @IBOutlet weak var percentCompletedTasks: UILabel!
    @IBOutlet weak var tasksCompletedTodayLbl: UILabel!
    
    func getCompletedTasks() -> NSMutableArray {
        let completedTasks = NSMutableArray();
        var isComplete:Bool;
        
        for task in toDoList {
            isComplete = task["isComplete"] as! Bool;
            if isComplete {
                completedTasks.addObject(task)
            }
        }
        
        return completedTasks
    }
    
    func getTasksCompletedToday() -> NSMutableArray {
        let tasksCompletedToday = NSMutableArray();
        let completedTasks      = getCompletedTasks();
        var isCompletedToday:Bool;
        
        for task in completedTasks {
            if (task["dateCompleted"] != nil) {
                isCompletedToday = NSCalendar.currentCalendar().isDateInToday(task["dateCompleted"] as! NSDate)
            } else {
                continue
            }
            if isCompletedToday {
                tasksCompletedToday.addObject(task)
            }
        }
        return tasksCompletedToday
    }
    
    func updateTotalTasks() {
        let numTasks    = toDoList.count
    }
    
    func updateTotalCompletedTasks() {
        let completedTasks          = getCompletedTasks()
        let numCompletedTasks       = completedTasks.count
    }
    
    func updateTotalCompletedTasksToday() {
        let tasksCompletedToday         = getTasksCompletedToday()
        let numTasksCompletedToday      = tasksCompletedToday.count
        totalCompletedTasksToday.text   = String(numTasksCompletedToday)
    }
    
    func updatePercentCompletedTasks() {
        let numTasks = Double(toDoList.count)
        
        let tasksCompleted              = getCompletedTasks()
        let numTasksCompleted           = Double(tasksCompleted.count)
        let percentCompletedTasksDbl    = numTasksCompleted/numTasks
        
        if (numTasksCompleted == 1) {
            tasksCompletedTodayLbl.text = "Task completed today"
        } else {
            tasksCompletedTodayLbl.text = "Tasks completed today"
        }
    }
    
    func updateTaskStats() {
        updateTotalTasks()
        updateTotalCompletedTasks()
        updateTotalCompletedTasksToday()
        updatePercentCompletedTasks()
    }
    
    override func viewDidAppear(animated: Bool) {
        updateTaskStats()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var backgroundImg = UIImage(named: "background.jpg")
        var imageView = UIImageView(image: backgroundImg)
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImg
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        updateTaskStats();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


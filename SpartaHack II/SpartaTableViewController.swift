//
//  SpartaTableViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 12/13/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//


import UIKit

class SpartaTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var tableView: UITableView = UITableView()
    var separatorOverride: UIView = UIView()
    
    // Pull-to-refresh customizations
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var customRefreshView: UIView!
    var labelsArray: Array<UILabel> = []
    var isAnimating = false
    var isUpdatingData = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    private var lastKnownTheme: Int = -1 // set to -1 so the view loads the theme the first time
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: type(of: self))
        
        let availableBounds = self.view.bounds
        
        self.tableView.frame = availableBounds
        
        self.tableView.separatorStyle = .none
        
        // Then delegate the TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let cellNib = UINib(nibName: "SpartaTableViewCell", bundle: bundle)
        self.tableView.register(cellNib, forCellReuseIdentifier: "spartaCell")
        
        let headerNib = UINib(nibName: "SpartaTableViewHeaderCell", bundle: bundle)
        self.tableView.register(headerNib, forCellReuseIdentifier: "headerCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        
        self.tableView.allowsSelection = false
        
        // Display table with custom cells
        self.view.addSubview(self.tableView)
        
        // ToDo: Subclass and make a SpartaViewController that sets this.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.addSubview(refreshControl)
        loadCustomRefreshContents()
        self.refreshControl.backgroundColor = .clear
        self.refreshControl.tintColor = .clear
        if let tabBar = self.tabBarController {
            self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, tabBar.tabBar.frame.size.height, 0.0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "spartaCell") as! SpartaTableViewCell
        cell.titleLabel.text = "Override Me"
        cell.detailLabel.text = "Go Green!"
        cell.separatorInset = .zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
        headerCell.titleLabel.text = "Override Me"
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Pull-to-Refresh
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.refreshControl.isRefreshing {
            self.customRefreshView.alpha = 1.0
            // Let the user know they have scrolled down low enough
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: -3.0, options: .curveLinear, animations: { () -> Void in
                let baseView = self.customRefreshView.subviews[0]
                baseView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        } else {
            self.customRefreshView.alpha = max( (scrollView.contentOffset.y + 90.0) / (-210 + 90.0) - 0.1, 0.0)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl.isRefreshing {
            animateRefreshStep1()
            disableAllUserInteractivity()
        }
    }
    
    func loadCustomRefreshContents() {
        for subview in refreshControl.subviews {
            subview.removeFromSuperview()
        }
        if let refreshContents = Bundle.main.loadNibNamed("RefreshView", owner: self, options: nil) {
        
            self.customRefreshView = refreshContents[0] as! UIView
            self.customRefreshView.frame = refreshControl.bounds
            
            let baseView = self.customRefreshView.subviews[0]
            for i in 0 ..< baseView.subviews.count {
                let label = baseView.viewWithTag(i + 1) as! UILabel
                label.textColor = Theme.refreshTextInactive
                self.labelsArray.append(label)
            }
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                self.customRefreshView.subviews[0].transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })

            self.customRefreshView.backgroundColor = Theme.refreshViewBackgroundColor
            self.customRefreshView.subviews[0].backgroundColor = .clear
            self.customRefreshView.subviews[1].frame.size.height = 1.5 // Interface Builder does not allow decimal constants :O
            Theme.setHorizontalGradient(on: self.customRefreshView.subviews[1])
            
            refreshControl.addSubview(self.customRefreshView)
        }
    }

    func animateRefreshStep1() {
        self.isAnimating = true
        UIView.animate(withDuration: 0.05, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.labelsArray[self.currentLabelIndex].textColor = Theme.refreshTextActive
            
        }, completion: { (finished) -> Void in
            UIView.animate(withDuration: 0.05, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform.identity
                self.labelsArray[self.currentLabelIndex].textColor = Theme.refreshTextInactive
                
            }, completion: { (finished) -> Void in
                self.currentLabelIndex += 1
                
                if self.currentLabelIndex < self.labelsArray.count {
                    self.animateRefreshStep1()
                } else {
                    self.animateRefreshStep2()
                }
            })
        })
    }
    
    func animateRefreshStep2() {
        // After animation, check if data is done being updated
        if !self.isUpdatingData {
            self.refreshControl.endRefreshing()
            enableAllUserInteractivity()
            loadCustomRefreshContents() // Reset the refresh view
            self.currentLabelIndex = 0 // Reset currentLabelIndex for next animation
            return
        }

        if self.refreshControl.isRefreshing {
            self.currentLabelIndex = 0
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SpartaTableViewController.animateRefreshStep1), userInfo: nil, repeats: false)
        } else {
            self.isAnimating = false
            self.currentLabelIndex = 0
            for i in 0 ..< self.labelsArray.count {
                self.labelsArray[i].textColor = Theme.primaryColor
                self.labelsArray[i].transform = CGAffineTransform.identity
            }
        }
    }

    // When refreshing, we disable changing tabs and scrolling.
    // This is used to stop users from having multiple refresh animations alive at a time.
    func disableAllUserInteractivity() {
        self.tableView.isUserInteractionEnabled = false
        if let tabBar = self.view.window?.rootViewController?.childViewControllers.last as? SpartaTabBarViewController {
            tabBar.view.isUserInteractionEnabled = false
        }
    }
    
    func enableAllUserInteractivity() {
        self.tableView.isUserInteractionEnabled = true
        if let tabBar = self.view.window?.rootViewController?.childViewControllers.last as? SpartaTabBarViewController {
            tabBar.view.isUserInteractionEnabled = true
        }
    }
    
    // MARK: Theme change
    
    func needsThemeUpdate() -> Bool {
        return self.lastKnownTheme != Theme.currentTheme()
    }
    
    func updateTheme(animated: Bool = false) {
        
        self.tableView.tableFooterView?.backgroundColor = Theme.backgroundColor
        self.tableView.backgroundColor = Theme.backgroundColor
        loadCustomRefreshContents()
        if let customRefreshView = self.customRefreshView {
            customRefreshView.backgroundColor = Theme.refreshViewBackgroundColor
            customRefreshView.subviews[0].backgroundColor = .clear
            Theme.setHorizontalGradient(on: customRefreshView.subviews[1])
        }
        self.lastKnownTheme = Theme.currentTheme()
        if animated {
            UIView.transition(with: self.tableView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            }, completion: nil)
        } else {
            self.tableView.reloadData()
        }
    }

    func getDataAndReload() {
        // Override this for each SpartaTableViewController subclass
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

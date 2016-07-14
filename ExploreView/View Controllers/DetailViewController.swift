//
//  DetailViewController.swift
//  ExploreView
//
//  Created by Mohonish Chakraborty on 14/07/16.
//  Copyright © 2016 mohonish. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var detailTableView: UITableView!
    
    // MARK: - Class Members
    
    private let featuredCellIdentifier = "FeaturedCollectionViewCell"
    private let categoryCellIdentifier = "CategoryTableViewCell"
    
    var sections: [Section]!
    
    private let data = ["Data A", "Data B", "Data C"]
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UI Setup
    
    func setupUI() {
        setupDetailTableView()
    }
    
    func setupDetailTableView() {
        detailTableView.registerNib(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: categoryCellIdentifier)
        detailTableView.tableFooterView = UIView()
        detailTableView.dataSource = self
        detailTableView.delegate = self
    }

}

// MARK: - UITableView DataSource

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionTitle
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sections.count - 1 {
            return data.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(categoryCellIdentifier) as! CategoryTableViewCell
        cell.categoryLabel.text = data[indexPath.item]
        return cell
    }
    
}

// MARK: - UITableView Delegate

extension DetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        let thisSection = Section(index: sections[sections.count - 1].sectionIndex + 1, title: data[indexPath.item], active: false)
        var newSections = self.sections
        newSections.append(thisSection)
        detailVC.sections = newSections
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}



//
//  ViewController.swift
//  ExploreView
//
//  Created by Mohonish Chakraborty on 13/07/16.
//  Copyright © 2016 mohonish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var categoryTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var featuredView: FeaturedView!
    
    // MARK: - Class Members
    
    let featuredCellIdentifier = "FeaturedCollectionViewCell"
    let categoryCellIdentifier = "CategoryTableViewCell"
    
    let sections = ["Category"]
    
    let categories = [
        "Books",
        "Music",
        "Games",
        "Sports"
    ]
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        categoryTableViewHeightConstraint.constant = 1500 //categoryTableView.contentSize.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        setupFeaturedView()
        setupCategoryTableView()
    }
    
    func setupFeaturedView() {
        
        featuredView.collectionView.registerNib(UINib(nibName: "FeaturedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: featuredCellIdentifier)
        featuredView.collectionView.dataSource = self
        
    }
    
    func setupCategoryTableView() {
        
        categoryTableView.registerNib(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: categoryCellIdentifier)
        categoryTableView.tableFooterView = UIView()
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
    }

}

// MARK: - UICollectionView DataSource

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(featuredCellIdentifier, forIndexPath: indexPath) as! FeaturedCollectionViewCell
        cell.titleLabel.text = "Title"
        cell.subtitleLabel.text = "Subtitle"
        return cell
    }
    
}

// MARK: - UITableView DataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(categoryCellIdentifier) as! CategoryTableViewCell
        cell.categoryLabel.text = categories[indexPath.item]
        return cell
        
    }
    
}

// MARK: - UITableView Delegate

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}


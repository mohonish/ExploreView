//
//  ViewController.swift
//  ExploreView
//
//  Created by Mohonish Chakraborty on 13/07/16.
//  Copyright © 2016 mohonish. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var categoryTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var featuredView: FeaturedView!
    
    // MARK: - Class Members
    
    var transitionPresentAnimator = MCExploreAnimator()
    
    let featuredCellIdentifier = "FeaturedCollectionViewCell"
    let categoryCellIdentifier = "CategoryTableViewCell"
    
    var sections = [
        Section(index: 0, title: "All", active: true)
    ]
    
    var category: Category?
    
    var feed = [Feed]()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        categoryTableViewHeightConstraint.constant = categoryTableView.contentSize.height
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.delegate = self
        
        fetchData()
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
    
    // MARK: - API Handling
    
    func fetchData() {
        
        APIController.sharedInstance.fetchExploreContent(Constants.API.exploreEndpoint, completion: { [weak self] (category) in
            
            if let catg = category {
                self?.category = catg
                self?.updateTable()
                if let feedURL = catg.topFreeApplicationsURL {
                    self?.fetchFeed(feedURL.absoluteString)
                }
            }
            
        })
        
    }
    
    func fetchFeed(url: String) {
        
        APIController.sharedInstance.fetchFeed(url, completion: { [weak self] (feeds) in
            
            if let feedItems = feeds {
                if feedItems.count > 0 {
                    self?.feed = feedItems
                    self?.updateFeeds()
                }
            }
            
        })
        
    }
    
    func updateTable() {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.categoryTableView.reloadData()
            self.categoryTableViewHeightConstraint.constant = self.categoryTableView.contentSize.height
        })
        
    }
    
    func updateFeeds() {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.featuredView.collectionView.reloadData()
        })
        
    }

}

// MARK: - UICollectionView DataSource

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(featuredCellIdentifier, forIndexPath: indexPath) as! FeaturedCollectionViewCell
        cell.titleLabel.text = feed[indexPath.item].title
        cell.subtitleLabel.text = feed[indexPath.item].title
        if let imgURL = feed[indexPath.item].imageURL {
            cell.cellImageView.sd_setImageWithURL(imgURL)
        }
        return cell
    }
    
}

// MARK: - UITableView DataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.subcategories?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(categoryCellIdentifier) as! CategoryTableViewCell
        if let subCatg = category?.subcategories {
            cell.categoryLabel.text = subCatg[indexPath.item].name
        }
        return cell
        
    }
    
}

// MARK: - UITableView Delegate

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let subCategories = category?.subcategories else {
            return
        }
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        //subcategory
        let thisSubcategory = self.category?.subcategories![indexPath.item]
        detailVC.category = thisSubcategory
        
        //sections
        let thisSection = Section(index: 1, title: subCategories[indexPath.item].name, active: true)
        var newSections = sections
        newSections.append(thisSection)
        detailVC.sections = newSections
        
        //last section frame
        self.transitionPresentAnimator.lastSectionFrame = self.navigationController!.navigationBar.frame
        
        //title stack
        self.transitionPresentAnimator.titleStackHeight = 0
        
        //divide point
        var cellRect = tableView.rectForRowAtIndexPath(indexPath)
        cellRect = CGRectOffset(cellRect, 0, -tableView.contentOffset.y)
        let cellRectBottomPoint = CGPointMake(cellRect.origin.x, cellRect.origin.y + cellRect.height)
        let dividePoint = view.convertPoint(cellRectBottomPoint, fromView: tableView)
        self.transitionPresentAnimator.dividePoint = dividePoint.y
        detailVC.transitioningDelegate = self
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}

// MARK: - UIViewController Transitioning Delegate

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionPresentAnimator
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionPresentAnimator
    }
    
}


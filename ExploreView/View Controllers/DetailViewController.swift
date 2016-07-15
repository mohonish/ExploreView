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
    
    var transitionPopAnimator = MCExplorePopAnimator()
    var transitionPresentAnimator = MCExploreAnimator()
    
    private let featuredCellIdentifier = "FeaturedCollectionViewCell"
    private let categoryTableCellIdentifier = "CategoryTableViewCell"
    private let featuredTableCellIdentifier = "FeaturedTableViewCell"
    
    var category: Category!
    
    var sections: [Section]!
    
    var feed = [Feed]()
    
    var featuredView: FeaturedView?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.delegate = self
        
        if let topFreeURL = self.category.topFreeApplicationsURL {
            self.fetchFeed(topFreeURL.absoluteString)
        }
        
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
        detailTableView.registerNib(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: categoryTableCellIdentifier)
        detailTableView.registerNib(UINib(nibName: "FeaturedTableViewCell", bundle: nil), forCellReuseIdentifier: featuredTableCellIdentifier)
        detailTableView.tableFooterView = UIView()
        detailTableView.dataSource = self
        detailTableView.delegate = self
    }
    
    // MARK: - Observers
    
    func didTapSectionHeader(gesture: UIGestureRecognizer) {
        if let sectionIndex = gesture.view?.tag {
            popToViewControllerAtIndex(sectionIndex)
        }
        
    }
    
    func popToViewControllerAtIndex(index: Int) {
        if index == self.sections.count - 1 {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let navStack = self.navigationController?.viewControllers
            self.navigationController?.popToViewController(navStack![index], animated: true)
        }
    }
    
    // MARK: - API Handling
    
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
            self.detailTableView.reloadData()
        })
        
    }
    
    func updateFeeds() {
        
        dispatch_async(dispatch_get_main_queue(), {
            let firstCell = self.detailTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.sections.count - 1)) as! FeaturedTableViewCell
            firstCell.featuredView.collectionView.reloadData()
        })
        
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == sections.count - 1 {
            let frame = CGRectMake(0, 0, self.view.frame.width, 50)
            let view = ActiveHeaderView(frame: frame)
            view.titleLabel.text = sections[section].sectionTitle
            view.addBottomBorderWithColor(UIColor.lightGrayColor(), width: 0.5)
            view.tag = section
            let tapGesture = UITapGestureRecognizer(target: self, action: "didTapSectionHeader:")
            view.addGestureRecognizer(tapGesture)
            return view
        } else {
            let frame = CGRectMake(0, 0, self.view.frame.width, 25)
            let view = PassiveHeaderView(frame: frame)
            view.titleLabel.text = sections[section].sectionTitle
            view.addBottomBorderWithColor(UIColor.lightGrayColor(), width: 0.5)
            view.tag = section
            let tapGesture = UITapGestureRecognizer(target: self, action: "didTapSectionHeader:")
            view.addGestureRecognizer(tapGesture)
            return view
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == sections.count - 1 {
            return CGFloat(50)
        }
        return CGFloat(25)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sections.count - 1 {
            let subcatgCount = category.subcategories?.count ?? 0
            return subcatgCount + 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(featuredTableCellIdentifier) as! FeaturedTableViewCell
            cell.featuredView.collectionView.registerNib(UINib(nibName: "FeaturedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: featuredCellIdentifier)
            cell.featuredView.collectionView.dataSource = self
            cell.featuredView.title = "Popular"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(categoryTableCellIdentifier) as! CategoryTableViewCell
            cell.categoryLabel.text = self.category.subcategories![indexPath.item - 1].name
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return CGFloat(221)
        }
        return CGFloat(44)
    }
    
}

// MARK: - UITableView Delegate

extension DetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        //subcategory
        let thisSubcategory = self.category?.subcategories![indexPath.item]
        detailVC.category = thisSubcategory
        
        //section
        let thisSection = Section(index: sections[sections.count - 1].sectionIndex + 1, title: thisSubcategory!.name, active: false)
        var newSections = self.sections
        newSections.append(thisSection)
        detailVC.sections = newSections
        
        //last section frame
        var lastSectionRect = tableView.rectForHeaderInSection(sections.count - 1)
        lastSectionRect = view.convertRect(lastSectionRect, fromView: tableView)
        self.transitionPresentAnimator.lastSectionFrame = lastSectionRect
        
        //title stack
        self.transitionPresentAnimator.titleStackHeight = lastSectionRect.origin.y + lastSectionRect.height
        
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

// MARK: - UICollectionView DataSource

extension DetailViewController: UICollectionViewDataSource {
    
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

// MARK: - UIViewController Transitioning Delegate

extension DetailViewController: UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Push {
            return transitionPresentAnimator
        }
        return transitionPopAnimator
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionPresentAnimator
    }
    
}


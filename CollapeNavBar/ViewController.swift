//
//  ViewController.swift
//  CollapeNavBar
//
//  Created by zhihao.lv on 2019/9/3.
//  Copyright © 2019 zhihao.lv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuIconTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var naviTitleLabel: UILabel!
    
    @IBOutlet weak var paxNameLabel: UILabel!
    @IBOutlet weak var tierLabel: UILabel!
    @IBOutlet weak var memberIdLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    
    let headerViewMaxHeight: CGFloat = 190 + UIApplication.shared.statusBarFrame.height
    let headerViewMinHeight: CGFloat = 44 + UIApplication.shared.statusBarFrame.height
    var isScollUp: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviTitleLabel.isHidden = true
        menuIconTopConstraint.constant = UIApplication.shared.statusBarFrame.height + 5
        topViewHeightConstraint.constant = headerViewMaxHeight
    }

}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel?.text = "This is for testing use" + "\(indexPath.row)"
        
        return cell
        
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .yellow
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight: CGFloat = topViewHeightConstraint.constant - y
        
        var alpha = (newHeaderViewHeight - headerViewMinHeight) / (headerViewMaxHeight - headerViewMinHeight)
        if alpha <= 0 {
            alpha = 0
        }
        
        if newHeaderViewHeight > headerViewMaxHeight {
            naviTitleLabel.isHidden = true
            topViewHeightConstraint.constant = headerViewMaxHeight
        } else if newHeaderViewHeight < headerViewMinHeight {
            naviTitleLabel.isHidden = false
            topViewHeightConstraint.constant = headerViewMinHeight
        } else {
            topViewHeightConstraint.constant = newHeaderViewHeight
            naviTitleLabel.isHidden = true
            if scrollView.contentOffset.y > 0 {
                isScollUp = true
            }
            if scrollView.contentOffset.y < 0 {
                isScollUp = false
            }
            scrollView.contentOffset.y = 0 // block scroll view
        }
        setAlphaToSubviews(with: alpha)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetTheHeaderPosition()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        resetTheHeaderPosition()
    }
    
    private func resetTheHeaderPosition() {
        guard let isScollUp = isScollUp else {
            return
        }
        
        if isScollUp {
            UIView.animate(withDuration: 0.1, animations: {
                self.topViewHeightConstraint.constant = self.headerViewMinHeight
                self.view.layoutIfNeeded()
            }) { (isCompleted) in
                if isCompleted {
                    self.setAlphaToSubviews(with: 0)
                    self.naviTitleLabel.isHidden = false
                }
            }
            
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.topViewHeightConstraint.constant = self.headerViewMaxHeight
                self.view.layoutIfNeeded()
            }) { (isCompleted) in
                if isCompleted {
                    self.setAlphaToSubviews(with: 1)
                    self.naviTitleLabel.isHidden = true
                }
            }
            
        }
    }
    
    private func setAlphaToSubviews(with alpha: CGFloat) {
        paxNameLabel.alpha = alpha
        tierLabel.alpha = alpha
        memberIdLabel.alpha = alpha
        remarkLabel.alpha = alpha
        icon1.alpha = alpha
        icon2.alpha = alpha
    }
}

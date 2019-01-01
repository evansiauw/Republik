//
//  menuCollectionViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 12/12/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit

private let sectionInsets = UIEdgeInsets(top: 100.0, left: 20.0, bottom: 50.0, right: 20.0)
private let itemsPerRow: CGFloat = 3
private var widthPerItem: CGFloat?

private let options = ["jobSearch", "housing", "shopping", "food", "communication", "event", "news", "currency", "service"]

class menuCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
  
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return options.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! menuCollectionViewCell
        
        cell.backgroundColor = UIColor.cyan
        cell.menuImage.image = UIImage(named: options[indexPath.row])
        
        return cell
    }
    
}

extension menuCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem!, height: widthPerItem!)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


extension UIImageView {
    
    func roundedCorner(){
        layer.borderWidth = 2
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
    
    
}

    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */



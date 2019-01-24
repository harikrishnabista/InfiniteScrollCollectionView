//
//  ViewController.swift
//  InfiniteCollectionView
//
//  Created by Satinder Singh on 11/11/17.
//  Copyright © 2017 Satinder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let numberOfItemsInAPage = 30
    var page = 0
    
    func prepareList() -> [Int] {
        var list:[Int] = []
        
        let lowerIndex = self.page * numberOfItemsInAPage
        let upperIndex = lowerIndex + numberOfItemsInAPage
        
        for number in lowerIndex..<upperIndex {
            list.append(number)
        }
        return list
    }
    
    var numbers:[Int]?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.numbers = self.prepareList()
        self.collectionView.reloadData()
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static func random() -> UIColor {
        return UIColor(rgb: Int(CGFloat(arc4random()) / CGFloat(UINT32_MAX) * 0xFFFFFF))
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = UIColor.random()
        
        if let label = cell.viewWithTag(100) as? UILabel,
            let numbers = self.numbers,
                indexPath.row < numbers.count {
                        let item = numbers[indexPath.row]
                        label.text =  "\(item)"
        }
        
        // appending new when last cell is shown
        if indexPath.row == self.numbers!.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.page = self.page + 1
                let newList = self.prepareList()
                self.numbers?.append(contentsOf: newList)
                self.collectionView.reloadData()
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numbers = self.numbers {
            return numbers.count
        }else {
            return 0
        }
    }
}


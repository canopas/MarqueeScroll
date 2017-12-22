//
//  ViewController.swift
//  MarqueeScroll
//
//  Created by Satish Vekariya on 22/12/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum MarqueeDirection : CGFloat {
        case left = 1
        case right = -1
    }

    @IBOutlet weak var collectionView:UICollectionView!
    
    fileprivate var timer:Timer?
    fileprivate var direction:MarqueeDirection = .left
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize.init(width: 1, height: 1)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelTimer()
    }

    func startTimer() {
        guard timer == nil, collectionView.numberOfSections == 3 else { return }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(scroll(sender:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    func cancelTimer() {
        guard let timer = timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
    }
    
    @objc
    func scroll(sender:Timer) {
        self.collectionView.contentOffset.x += direction.rawValue
    }


}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.label.text = "\(indexPath.row)"
        return cell
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let framWidth = collectionView.frame.width
        let sectionLength = collectionView.contentSize.width/CGFloat(numberOfSections(in: collectionView))
        let contentLength = collectionView.contentSize.width
        if contentOffsetX <= 0 {
            collectionView.contentOffset.x = sectionLength - contentOffsetX
        } else if contentOffsetX >= contentLength - framWidth {
            collectionView.contentOffset.x = contentLength - sectionLength - framWidth
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        cancelTimer()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0) {
            direction = .right
        } else {
            direction = .left
        }
        startTimer()
    }
}



class CustomCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let view = UILabel()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(label)
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 80).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        
        attributes.frame.size.height = 90
        attributes.frame.size.width = 90
        
        return attributes
    }
}

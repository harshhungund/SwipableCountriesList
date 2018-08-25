//
//  SwipeTableViewCellActionView.swift
//
//  Created by Harsh Hungund on 25/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import UIKit

public class SwipeTableViewCellActionView: UIView {
    
    // Outlets
    private var imageView: UIImageView!
    private var contentView: UIView!
    private var tap: UITapGestureRecognizer!
    
    // State
    private(set) var currentScale: CGFloat = 1
    
    // Configurations
    public var minScale: CGFloat = 0.1
    public var maxScale: CGFloat = 1
    private(set) var handler: (() -> ())?
    
    //----------------------------------------------
    // MARK: - Life Cycle
    //----------------------------------------------
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView = UIView(frame: CGRect.zero)
        addSubview(contentView)
        
        imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        tap = UITapGestureRecognizer(target: self, action: #selector(SwipeTableViewCellActionView.didTap(_:)))
        addGestureRecognizer(tap)
    }
    
    // MARK: - User Interactions
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        handler?()
    }
    
    
    // MARK: - Configuration
    public func configure(image: UIImage?, handler:(()->())?) {
        imageView.image = image
        self.handler = handler
    }
    
}

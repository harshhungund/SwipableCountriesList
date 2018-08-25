//
//  CountryCellTableViewCell.swift
//  SwipableCountriesList
//
//  Created by Harsh Hungund on 25/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import UIKit

public class CountryCell: UITableViewCell {
    
    // Definitions
    private enum SwipeMode {
        case  left, none
    }
    
    private enum OpenMode {
        case left, none
    }
    
    // Outlets
    private var bgView : UIView!
    private var leftActionContainer: UIView!
    private var panGestureRecognizer : UIPanGestureRecognizer!
    private var tapGestureRecognizer : UITapGestureRecognizer!
    private var actionViews: [SwipeTableViewCellActionView] = []
    private var leftContainerMask: UIView!
    private var countryNameLabel: UILabel!
    private var countryCurrencyLabel: UILabel!
    private var countryLanguageLabel: UILabel!
    
    // States
    private var swipeMode: SwipeMode = .none
    private var openMode: OpenMode = .none
    
    // Layouts Configurations
    // width of any swipeable action view
    public var actionWidth: CGFloat = 80 {
        didSet {
            setNeedsLayout()
        }
    }
    public var spaceBetweenActions: CGFloat = 2 {
        didSet {
            setNeedsLayout()
        }
    }
    public var actionHorizontalSpace: CGFloat = 20 {
        didSet {
            setNeedsLayout()
        }
    }
    public var swipeSpeedThreshold: CGFloat = 2500
    public var openMargin: CGFloat = 20
    public var springMargin: CGFloat = 80
    public var panElasticity: CGFloat = 100

    
    var updateTableviewForDeletedRowClosure: (()->())?
    // MARK: - Life Cycle
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        prepareView()
    }
    // MARK: - Initial configuration of UI

    private func prepareView() {
        bgView = UIView(frame: CGRect.zero)
        backgroundView = bgView
        leftActionContainer = UIView(frame: CGRect.zero)
        leftActionContainer.backgroundColor = UIColor.purple
        bgView.addSubview(leftActionContainer)
        leftContainerMask = UIView(frame: CGRect.zero)
        leftContainerMask.backgroundColor = UIColor.purple
        leftActionContainer.addSubview(leftContainerMask)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CountryCell.handlePan(sender:)))
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CountryCell.handleTap(sender:)))
        addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
        contentView.backgroundColor = UIColor.white
    }

    private func setCellLabelsData(name: String, currency: String, language: String){
        if countryNameLabel == nil {
            countryNameLabel = UILabel(frame: CGRect(x: 80, y: 15, width: 200, height: 40.0))
            countryNameLabel.lineBreakMode = .byWordWrapping
            countryNameLabel.numberOfLines = 0
            countryNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
            countryNameLabel.textColor = UIColor.blue
        }
        if countryCurrencyLabel == nil {
            countryCurrencyLabel = UILabel(frame: CGRect(x: 80, y: 55, width: 200, height: 40.0))
            countryCurrencyLabel.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
            countryCurrencyLabel.numberOfLines = 0
            countryCurrencyLabel.font = UIFont(name: "Helvetica", size: 16.0)
        }
        if countryLanguageLabel == nil {
            countryLanguageLabel = UILabel(frame: CGRect(x: 80, y: 95, width: 200, height: 40.0))
            countryLanguageLabel.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
            countryLanguageLabel.numberOfLines = 0
            countryLanguageLabel.font = UIFont(name: "Helvetica", size: 16.0)
        }
        countryNameLabel.text = "Country : \(name)"
        countryCurrencyLabel.text = "Currency : \(currency)"
        countryLanguageLabel.text = "Language : \(language)"
        contentView.addSubview(countryNameLabel)
        contentView.addSubview(countryCurrencyLabel)
        contentView.addSubview(countryLanguageLabel)
    }
    
    public func configureCell(name: String, currency: String, language: String){
        setCellLabelsData(name: name, currency: currency, language: language)
        let deleteAction = SwipeTableViewCellAction(image: UIImage(named: "Bomb")!) {
            (cell) in
            cell.deleteCountry(initialVX: 0)
        }
        configure(action: [deleteAction])
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.closeActionView), name:NSNotification.Name(rawValue: "Another Cell Tapped"), object: nil) // observe if any other cell tapped or swiped and hide the delete button

    }
    
    @objc func closeActionView() {
        hideDeleteView(initialVX: 0, aniamted: true, complete: nil)
    }
    
    public func configure(action: [SwipeTableViewCellAction]?) {
        if let actions = action {
            prepareActionViews(num: actions.count)
            for (i, action) in actions.enumerated() {
                actionViews[i].configure(image: action.image, handler: {
                    [weak self] in
                    if let sself = self {
                        action.handler?(sself)
                    }
                })
            }
        } else {
            prepareActionViews(num: 0)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = bounds
        leftActionContainer.frame = bounds
        
        for (index, view) in actionViews.enumerated() {
            let x = bounds.width - actionWidth * CGFloat(index + 1) - spaceBetweenActions * CGFloat(index)
            view.frame = CGRect(x: x, y: 0, width: actionWidth, height: bounds.height)
        }
        var maxX = bounds.maxX
        if let actionView = actionViews.last {
            maxX = (bounds.width - actionView.frame.minX) / 2
        }
        leftContainerMask.frame = CGRect(x: 0, y: 0, width: maxX, height: bounds.height)
        
        updateOpenMode(openMode, initialVX: 0, animated: true)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        updateOpenMode(.none, initialVX: 0, animated: false)
    }
    
    // MARK: - Gesture
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === panGestureRecognizer {
            let velocity = panGestureRecognizer.velocity(in: self)
            if abs(velocity.y) > abs(velocity.x) {
                return false
            }
            return true
        }
        else if gestureRecognizer === tapGestureRecognizer{
            return true
        }
        else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
    }
    
    public override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    
   // MARK: - Handle User interaction on cell
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        // hide delete icon if cell tapped
        updateOpenMode(.none, initialVX: 0, animated: true)
        // fire notification to other cells to hide their delete button
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name("Another Cell Tapped"), object: nil)
    }
    
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self)
        let velocity = sender.velocity(in: self)
        
        let currentFrame = contentView.frame
        let newFrame = calculateSwipeDestinationFrame(currentFrame: currentFrame, translation: translation)
        contentView.frame = newFrame

        if sender.state == .began {
            // fire notification to other cells to hide their delete button
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name("Another Cell Tapped"), object: nil)
        }
        
        // set the mode for left swipe
        if swipeMode == .none {
             if newFrame.minX < 0 {
                swipeMode = .left
            }
        }
        
        if sender.state == .ended || sender.state == .cancelled {
            if newFrame.minX > 0 {
                updateOpenMode(.none, initialVX: 200, animated: true) //set contentview to starting frame if any right swipe happens
            }
            updateOpenModeAfterSwipe(oldFrame: currentFrame, newFrame: newFrame, velocity: velocity) {} // update the view after swipe
            swipeMode = .none
        }
        sender.setTranslation(CGPoint(x:0, y:0), in: self)
        updateActionContrainers(contentViewFrame: newFrame)
    }
    
    // MARK: - Update UI based on swipe characteristics
    
    // take action upon swipe, i.e. decide if delete icon need to be shown or hidden based on speed and swipe length
    private func updateOpenModeAfterSwipe(oldFrame: CGRect, newFrame: CGRect, velocity: CGPoint, complete: ( () -> () )? ) {
        let velocityX = velocity.x
        switch swipeMode {
        case .left:
            if velocity.x < -swipeSpeedThreshold {
                // if swipe speed crosses threshold the delete the row
                deleteCountry(initialVX: velocityX)
            } else if let actionView = actionViews.first {
                //if swipe beyond anchor point, then show the delete icon
                if newFrame.maxX < actionView.frame.minX {
                    updateOpenMode(.left, initialVX: velocityX, animated: true)
                } else {
                    //if swipe does not cross anchor point, then hide delete icon
                    updateOpenMode(.none, initialVX: velocityX, animated: true)
                }
            }
        case .none:
            break
        }
    }
    
    // update UI to remove the deleted row and call the closure to update viewmodel and tableview
    func deleteCountry(initialVX velocityX: CGFloat) {
        translateContentViewToX(-contentView.bounds.width, initialVX: velocityX, animated: true, complete: nil)
        self.updateTableviewForDeletedRowClosure!()
    }

    
    // call the actual method with delete icon show/hide implementation depending on mode
    private func updateOpenMode(_ mode: OpenMode, initialVX velocityX: CGFloat, animated: Bool, complete: ( () -> () )? = nil) {
        switch mode {
        case .left:
            showDeleteView(openMode: .left, initialVX: velocityX, animated: animated) {
                complete?()
            }
            openMode = .left
        case .none:
            hideDeleteView(initialVX: velocityX, aniamted: animated) {
                complete?()
            }
            openMode = .none
        }
    }
   
   // MARK: - Delete Icon Display/Hide methods
    
    // hide delete icon
    private func hideDeleteView(initialVX: CGFloat, aniamted: Bool, complete: ( () -> () )?) {
        translateContentViewToX(0, initialVX: initialVX, animated: aniamted, complete: complete)
    }
    
    // show delete icon
    private func showDeleteView(openMode: OpenMode, initialVX: CGFloat, animated: Bool, complete: ( () -> () )? ) {
        var destinationX: CGFloat = 0
        switch openMode {
        case .left:
            if let actionView = actionViews.last {
                destinationX = -(bounds.width - actionView.frame.minX )
            }
        default:
            break
        }
        translateContentViewToX(destinationX, initialVX: initialVX, animated: animated, complete: complete)
    }

    
    // MARK: - UI Animation
    
    // causes UI animation of content view being moved and bouncing after left swipe
    private func translateContentViewToX(_ x: CGFloat, initialVX: CGFloat, animated: Bool, complete: ( () -> () )?) {
        let x0 =  contentView.frame.origin.x
        if x0 == x {
            return
        }
        let dx = x - x0
        let springVelocity : CGFloat = initialVX / dx
        let duration: TimeInterval = animated ? 0.6 : 0.0
        let damping: CGFloat = 1.0
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: springVelocity, options: [.allowUserInteraction], animations: {
            [weak self] in
            guard var frame = self?.contentView.frame else {
                return
            }
            frame.origin.x = x
            self?.contentView.frame = frame
        }) { (flag) in
            complete?()
        }
    }
    
    // MARK: - Calculation utilities
    // calculate new frame to which contentview need to be moved
    private func calculateSwipeDestinationFrame(currentFrame: CGRect, translation: CGPoint) -> CGRect {
        var newFrame = contentView.frame
        var factor: CGFloat = 1
        var range : (min: CGFloat, max: CGFloat)? = nil
        switch swipeMode {
        case .left:
            range = swipingRange()
        default:
            break
        }
        if let range = range {
            if currentFrame.minX < range.min && translation.x < 0 {
                factor = min(panElasticity / (range.min - currentFrame.minX), 1)
            }
        }
        newFrame.origin.x += translation.x * factor
        return newFrame
    }

    private func swipingRange() -> (min: CGFloat, max: CGFloat) {
        if let actionView = actionViews.last {
            return (min: actionView.frame.minX - springMargin - bounds.width, max: 0)
        } else {
            return (min: 0, max: 0)
        }
    }
    
    // MARK: - Action view setup
    
    private func updateActionContrainers(contentViewFrame frame: CGRect) {
        switch swipeMode {
        case .left:
            leftActionContainer.isHidden = false
            leftContainerMask.isHidden = frame.minX < 0
        default:
            break
        }
    }

    private func prepareActionViews(num: Int) {
        if actionViews.count == num {
            return
        }
        if actionViews.count < num {
            let toCreate = num - actionViews.count
            for _ in 0..<toCreate {
                let view = SwipeTableViewCellActionView(frame: CGRect.zero)
                leftActionContainer.addSubview(view)
                actionViews.append(view)
            }
        }
    }
    
}

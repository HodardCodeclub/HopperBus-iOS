//
//  StopTableViewCell.swift
//  HopperBus
//
//  Created by Tosin Afolabi on 22/08/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

import UIKit
import QuartzCore

class StopTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 14)
        label.numberOfLines = 2
        return label
    }()

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Light", size: 14)
        label.textColor = UIColor(red: 0.631, green: 0.651, blue: 0.678, alpha: 1)
        label.textAlignment = .Right
        return label
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.906, green: 0.914, blue: 0.918, alpha: 1)
        return view
    }()

    lazy var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 7
        view.layer.borderColor = UIColor.disabledGreen().CGColor
        return view
    }()

    var isLastCell: Bool = false {
        willSet {
            let constant: CGFloat = newValue ? -0.5 * self.contentView.frame.size.height : 0
            lineViewYConstraint.constant = constant
        }
    }

    var isCurrent: Bool = false {
        willSet(current) {
            if current {
                circleView.backgroundColor = UIColor.selectedGreen()
                circleView.layer.borderColor = UIColor.selectedGreen().CGColor
                timeLabel.textColor = UIColor.selectedGreen()
            } else {
                circleView.backgroundColor = UIColor.whiteColor()
                circleView.layer.borderColor = UIColor.disabledGreen().CGColor
                timeLabel.textColor = UIColor(red: 0.631, green: 0.651, blue: 0.678, alpha: 1)
            }
        }
    }

    var height: CGFloat = 55 {
        willSet(height) {
            contentView.removeConstraint(heightConstraint)
            heightConstraint.constant = height
            contentView.addConstraint(heightConstraint)
        }
    }

    lazy var lineViewYConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self.lineView, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: 1.0, constant: 0)
    }()

    lazy var heightConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self.contentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 55)
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None

        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(circleView)

        let views = [
            "timeLabel": timeLabel,
            "titleLabel": titleLabel,
            "lineView": lineView,
            "circleView": circleView,
            "contentView": contentView
        ]

        let metrics = [
            "margin": 6,
            "leftMargin": 16,
            "lineMargin": 14
        ]

        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(leftMargin)-[timeLabel(80)]-(lineMargin)-[lineView(2)]-(lineMargin)-[titleLabel]-|", options: [], metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(margin)-[titleLabel]-(margin)-|", options: [], metrics: metrics, views: views))

        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[lineView]", options: [], metrics: metrics, views: views))
        contentView.addConstraint(NSLayoutConstraint(item: circleView, attribute: .CenterX, relatedBy: .Equal, toItem: lineView, attribute: .CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: circleView, attribute: .CenterY, relatedBy: .Equal, toItem: titleLabel, attribute: .CenterY, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: circleView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 14))
        contentView.addConstraint(NSLayoutConstraint(item: circleView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 14))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: timeLabel, attribute: .CenterY, multiplier: 1, constant: 0))

        contentView.addConstraint(lineViewYConstraint)
        contentView.addConstraint(heightConstraint)
    }

    func animateTimeLabelTextChange(text: String) {
        let animation = CATransition();
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade;
        animation.duration = 0.15;
        timeLabel.layer.addAnimation(animation, forKey: "kCATransitionFade")

        timeLabel.text = text
    }
}

extension UIColor {

    class func selectedGreen() -> UIColor {
        return UIColor(red: 0.541, green: 0.875, blue: 0.780, alpha: 1)
    }

    class func disabledGreen() -> UIColor {
        return UIColor(red: 0.329, green: 0.831, blue: 0.690, alpha: 1)
    }
}
//
//  Capabilitys.swift
//  MessageChat
//
//  Created by Mac Novo on 28/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class FormatHeaderViewDate: UIView {
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let backgroundTimes: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12.5
        view.backgroundColor = UIColor(red: 188/255, green: 211/255, blue: 242/255, alpha: 1.0)
        return view
    }()
    private let dateFormatter: DateFormatter = {
        let date = DateFormatter()
        date.dateFormat = "EEEE"
        date.dateStyle = .medium
        date.timeStyle = .none
        date.locale = Locale(identifier: "pt_BR")
        return date
    }()
    
    private let dateweek: DateFormatter = {
        let date = DateFormatter()
        date.dateFormat = "EEEE"
        return date
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
        label.textAlignment = .center
        label.textColor = .darkGray
        //        label.layer.masksToBounds = false
        //        label.layer.shadowColor = UIColor.lightGray.cgColor
        //        label.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        //        label.layer.shadowOpacity = 1.0
        //        label.layer.shadowRadius = 0.0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    func setDateString(date: Date) {
        self.title.text = self.translateDayWeek(dateweek.string(from: date)) + ", " + dateFormatter.string(from: date)
    }
    
    private func setup() {
        self.addSubview(self.view)
        view.fillSuperview()
        
        self.view.addSubview(self.backgroundTimes)
        
        self.view.addSubview(title)
        self.title.anchorXY(centerX: self.centerXAnchor, centerY: self.centerYAnchor, top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(), size: .init(width: 0, height: 15))
        self.alpha = 0
        
        self.backgroundTimes.anchor(top: title.topAnchor, leading: title.leadingAnchor, bottom: title.bottomAnchor, trailing: title.trailingAnchor, padding: .init(top: -5, left: -5, bottom: -5, right: -5))
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func translateDayWeek(_ day: String) -> String {
        let days = ["dom", "seg", "ter", "qua", "qui", "sex", "sáb"]
        switch day {
        case "Sunday":
            return days[0]
        case "Monday":
            return days[1]
        case "Tuesday":
            return days[2]
        case "Wednesday":
            return days[3]
        case "Thursday":
            return days[4]
        case "Friday":
            return days[5]
        case "Saturday":
            return days[6]
        default:
            return ""
        }
    }
}


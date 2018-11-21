//
//  Util.swift
//  Importacao
//
//  Created by Luciano Pezzin on 11/10/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import Foundation
//    func createBottomView() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        child = storyboard.instantiateViewController(withIdentifier: "bottombar") as! BottomBarC
//        child.createBottomBar()
//        addChild(child)
//        child.view.translatesAutoresizingMaskIntoConstraints = false
//        child.didMove(toParent: self)
//        child.numberTf.delegate = self
//
//        container.layer.cornerRadius = 10
//        container.layer.shadowOffset = .zero
//        container.layer.shadowOpacity = 0.2
//        container.layer.shadowRadius = 10
//        container.layer.shadowColor = UIColor.black.cgColor
//        container.layer.masksToBounds = false
//
//        container.translatesAutoresizingMaskIntoConstraints = false
//
//        self.view.addSubview(container)
//        container.addSubview(child.view)
//        container.anchor(top: nil, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(), size: .init(width: 0, height: 271))
//
//        bottomConstraint = NSLayoutConstraint(item: self.container, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1, constant: 0)
//
//        view.addConstraint(bottomConstraint!)
//
//        child.view.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: container.trailingAnchor)
//
//        child.buttonValidate.addTarget(self, action: #selector(validateChannel), for: .touchDown)
//
//        self.channelValidated()
//
//        let gesture = UITapGestureRecognizer(target : self, action : #selector(upDownBottonBar))
//        self.container.addGestureRecognizer(gesture)
//
//        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        self.container.addGestureRecognizer(gestureRecognizer)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//        self.container.transform = CGAffineTransform(translationX: 0, y: 203)
//    }
//
//    @objc func handleKeyBoardNotification(_ notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//            let isKeyBoardShowing = notification.name == UIResponder.keyboardWillShowNotification
//
//            bottomConstraint?.constant = isKeyBoardShowing ? -keyboardFrame.height : 0
//            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
//                self.view.layoutIfNeeded()
//            }) { (_) in
//
//            }
//        }
//    }
//    var direction = 0.0
//
//    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
//        self.view.endEditing(true)
//        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
//            if gestureRecognizer.view!.transform.ty >= 0 {
//                let translation = gestureRecognizer.translation(in: self.view)
//                // note: 'view' is optional and need to be unwrapped
//                self.direction = Double(translation.y)
//                gestureRecognizer.view!.transform.ty = gestureRecognizer.view!.transform.ty + translation.y < 0 ? 0 : gestureRecognizer.view!.transform.ty + translation.y
//                gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
//
//            }
//        }
//        if gestureRecognizer.state == .ended {
//            UIView.animate(withDuration: 0.3) {
//                if self.direction < 0 {
//                    gestureRecognizer.view!.transform.ty = 0
//                } else {
//                    gestureRecognizer.view!.transform.ty = 206
//
//                }
//            }
//        }
//    }
//
//    @objc func upDownBottonBar() {
//        self.view.endEditing(true)
//        UIView.animate(withDuration: 0.3) {
//            if self.container.transform.ty == 206.0 {
//                self.container.transform = CGAffineTransform(translationX: 0, y: 0)
//
//            } else {
//                self.container.transform = CGAffineTransform(translationX: 0, y: 206)
//            }
//        }
//    }
//
//    @objc func showBar(_ view: UIView) {
//        UIView.animate(withDuration: 0.3) {
//            self.container.transform = CGAffineTransform(translationX: 0, y: 206)
//        }
//        UIView.animate(withDuration: 0.2, animations: {
//            self.iconTop.alpha = 0
//        }) { (_) in
//            self.iconTop.removeFromSuperview()
//            self.iconTop.alpha = 1
//        }
//    }

//    @objc func swipe_side_menu(_ gestureRecognizer: UIPanGestureRecognizer) {
//        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
//            let transformTx = Int(gestureRecognizer.view!.transform.tx)
//            let sizeTx = Int(self.view.frame.width * 0.9)
//            let width = self.view.frame.width * 0.9
//
//            if transformTx <= sizeTx {
//                let translation = gestureRecognizer.translation(in: self.side_bar)
//                // note: 'view' is optional and need to be unwrapped
//                self.direction = Double(translation.x)
//                let calc = gestureRecognizer.view!.transform.tx + translation.x > width ? width : gestureRecognizer.view!.transform.tx + translation.x
//                gestureRecognizer.view!.transform.tx = calc
//                self.regularAlpha(value: calc / width)
//                gestureRecognizer.setTranslation(CGPoint.zero, in: self.side_bar)
//            }
//        }
//        if gestureRecognizer.state == .ended {
//            UIView.animate(withDuration: 0.3, animations: {
//                if self.direction > 0 {
//                    gestureRecognizer.view!.transform.tx = self.view.frame.width * 0.9
//                } else {
//                    gestureRecognizer.view!.transform.tx = 0
//                    self.backgroundBlur.alpha = 0
//                }
//            }) { (_) in
//                if self.direction < 0 {
//                    self.backgroundBlur.removeFromSuperview()
//                    self.side_bar.isHidden = true
//                }
//            }
//        }
//    }

//    private func backgroundShadow() {
//        let bluerBack = UIBlurEffect(style: .light)
//        backgroundBlur = UIVisualEffectView(effect: bluerBack)
//        backgroundBlur.backgroundColor = UIColor.darkText.withAlphaComponent(0.1)
//        self.view.addSubview(backgroundBlur)
//        backgroundBlur.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
//        backgroundBlur.alpha = 0
//    }
//    private func regularAlpha(value: CGFloat) {
//        if backgroundBlur != nil {
//            self.backgroundBlur.alpha = value
//        }
//    }

//    @objc func side_menu() {
//        if side_bar.isHidden {
//            self.backgroundShadow()
//            self.view.bringSubviewToFront(self.side_bar)
//            self.view.endEditing(true)
//            side_bar.isHidden = false
//            UIView.animate(withDuration: 0.2, animations: {
//                self.side_bar.transform = CGAffineTransform(translationX: self.side_bar.frame.width, y: 0)
//                self.view.layoutIfNeeded()
//                self.backgroundBlur.alpha = 1
//            })
//        } else {
//            UIView.animate(withDuration: 0.2, animations: {
//                self.side_bar.transform = CGAffineTransform(translationX: -self.side_bar.frame.width, y: 0)
//                self.view.layoutIfNeeded()
//                self.backgroundBlur.alpha = 0
//            }) { (_) in
//                self.side_bar.isHidden = true
//                self.backgroundBlur.removeFromSuperview()
//            }
//        }
//    }
//
//    func addLeftBarIcon() {
//        let logoImageView = UIButton()
//        logoImageView.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
//        logoImageView.addTarget(self, action: #selector(side_menu), for: .touchDown)
//        logoImageView.frame = CGRect(x:0, y:0.0, width: 35,height: 35)
//        logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
//        logoImageView.layer.masksToBounds = true
//        logoImageView.contentMode = .scaleAspectFill
//
//        let imageItem = UIBarButtonItem.init(customView: logoImageView)
//        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 35)
//        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 35)
//        heightConstraint.isActive = true
//        widthConstraint.isActive = true
//        navigationItem.leftBarButtonItem =  imageItem
//    }


//    @objc func handleKeyBoardNotification(_ notification: NSNotification) {
//        var bottomConstraint: NSLayoutConstraint? // global variable
//        if let userInfo = notification.userInfo {
//            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//            let isKeyBoardShowing = notification.name == UIResponder.keyboardWillShowNotification
//
//            bottomConstraint?.constant = isKeyBoardShowing ? -keyboardFrame.height : 0
//            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
//                self.view.layoutIfNeeded()
//            }) { (_) in
//
//            }
//        }
//    }
//    var direction = 0.0
//
//    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
//
//        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
//            if gestureRecognizer.view!.transform.ty >= 0 {
//                let translation = gestureRecognizer.translation(in: self.view)
//                // note: 'view' is optional and need to be unwrapped
//                self.direction = Double(translation.y)
//                gestureRecognizer.view!.transform.ty = gestureRecognizer.view!.transform.ty + translation.y < 0 ? 0 : gestureRecognizer.view!.transform.ty + translation.y
//                gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
//            }
//        }
//        if gestureRecognizer.state == .ended {
//            UIView.animate(withDuration: 0.3) {
//                if self.direction < 0 {
//                    gestureRecognizer.view!.transform.ty = 0
//                } else {
//                    gestureRecognizer.view!.transform.ty = 206
//                }
//            }
//        }
//    }

//
//  ViewController.swift
//  Twitter UI
//
//  Created by Rohan Lokesh Sharma on 14/08/17.
//  Copyright © 2017 webarch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //constants
    let ratio:CGFloat = 0.347826086956522
    let profileHeight:CGFloat = 80.0
    var minOffset:CGFloat!
    let leftConstant:CGFloat = 20
    
    
    
    lazy var scrollView:UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.contentSize = CGSize(width: self.view.bounds.width, height: 2 * self.view.bounds.height)
       // view.bounces = true
        view.delegate = self;
        view.isScrollEnabled = true
        view.backgroundColor = .clear
        view.clipsToBounds = false;
        
        return view
    }()
    var imageBlur:UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view;
    }()
    
    lazy var headerImage:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.image = #imageLiteral(resourceName: "header_bg")
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.layer.masksToBounds = true
        view.addSubview(imageBlur)
        NSLayoutConstraint.activate([
            imageBlur.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageBlur.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageBlur.topAnchor.constraint(equalTo: view.topAnchor),
            imageBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        imageBlur.alpha = 0.0
        //view.alpha = 0.5
        return view;
    }()
    var profileImageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.image = #imageLiteral(resourceName: "profile")
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.0
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10;
        return view;
    }()
    
    var nameLabel:UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.text = "Rohan Lokesh Sharma"
        return view;
    }()
    var twitterLabel:UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "HelveticaNeue", size: 12)
        view.textColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.text = "@rohan999"
        return view;
    }()

    override func viewDidLoad() {
        setupUI()
        setupNameLabels()
        minOffset = self.view.frame.width * ratio - 44  - 20
        super.viewDidLoad()
        view.backgroundColor = .white;
    }


}

extension ViewController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
       
        let y = scrollView.contentOffset.y;
       
        
        
        if(y < 0){
            // pull down scale
            let pChange = (-y) / headerImage.bounds.height
            let h1 = headerImage.bounds.height
            let h2 = headerImage.bounds.height + (headerImage.bounds.height * pChange)
            let t1 = CGAffineTransform(scaleX: h2 / h1, y: h2 / h1)
            let t2 = CGAffineTransform(translationX: 0, y: (h2 - h1) / 2)
            headerImage.transform = t1.concatenating(t2)
            UIView.animate(withDuration: 0.25, animations: {
                self.profileImageView.transform = CGAffineTransform.identity
                self.profileImageView.layer.zPosition = 1;
                self.headerImage.layer.zPosition = 0
            })

        }
        else{
            headerImage.transform = CGAffineTransform(translationX: 0, y: -min(y,minOffset))
            UIView.animate(withDuration: 0.5, animations: {
                 self.profileImageView.transform = CGAffineTransform(translationX: 0, y: self.profileImageView.bounds.height * 1/4).concatenating(CGAffineTransform(scaleX: 0.75, y: 0.75))
                //self.profileImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            
            imageBlur.alpha = min(y / minOffset,0.7)
            
            if(y >= minOffset){
                self.profileImageView.layer.zPosition = 0;
                self.headerImage.layer.zPosition = 1;
            }
           
            
            
        }
       
        
        
    }
}
extension ViewController{
    //setup ui here
    func setupUI(){
        view.addSubview(headerImage)
        view.addSubview(scrollView)
        scrollView.addSubview(profileImageView)
        
    
        NSLayoutConstraint.activate([
            headerImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerImage.topAnchor.constraint(equalTo: view.topAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: view.frame.width * CGFloat(ratio))
            ])
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        view.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: profileHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: profileHeight),
            profileImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant:leftConstant),
            profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: view.bounds.width * ratio - profileHeight/4 )
            ])
        
    }
    
    func setupNameLabels(){
        view.addSubview(nameLabel)
        view.addSubview(twitterLabel)
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant:leftConstant),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant:10),
            twitterLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant:leftConstant),
            twitterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant:0),
            ])
        nameLabel.sizeToFit()
        twitterLabel.sizeToFit()
        
    }
}


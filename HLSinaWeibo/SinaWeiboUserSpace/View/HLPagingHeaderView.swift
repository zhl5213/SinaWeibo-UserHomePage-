//
//  HLPagingHeaderView.swift
//  HLSinaWeibo
//
//  Created by jsbios on 2018/3/8.
//  Copyright © 2018年 Dianzhi. All rights reserved.
//

import UIKit

protocol HLPagingHeaderViewDelegate {
    func pagingHeaderViewButtonIsTapped(_ view:HLPagingHeaderView, atIndex index:NSInteger)
}

class HLPagingHeaderView: UIView {
    //    MARK:- var and lazy load -

//    菜单栏的高度
    public var menuHeight :CGFloat = 0
    
//    需要交互的视图
    var interactionItems = [UIView]()
    //    菜单栏上的BUtton集合
    var buttons = [UIButton]()

//    背景视图
    var backGroundImage:UIImageView = {
        let backImage = UIImageView.init()
        backImage.image = UIImage.init(named: "卡通")
        backImage.contentMode = UIViewContentMode.scaleAspectFill
        return backImage
    }()
    
    //    头像
    var avatar:UIImageView = {
        let avatar = UIImageView.init()
        avatar.image = UIImage.init(named: "话题")
        avatar.layer.cornerRadius = 25.0
        avatar.layer.masksToBounds = true
        avatar.isUserInteractionEnabled = true
        return avatar
    }()

    //    用户名字
    var nameLabel:UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.text = "这里是我的名字的描述栏"
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var delegate:HLPagingHeaderViewDelegate?


    //    MARK:- init and setup -

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews()  {
        
        layer.masksToBounds = true
        self.backgroundColor = UIColor.white

        self.addSubview(backGroundImage)
        self.addSubview(avatar)
        //注意，点击方法必须在此处加载，不能在懒加载里面写；懒加载里面创建的action会找不到
        avatar.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(avatarIsTapped)))
        interactionItems.append(avatar)
        
        self.addSubview(nameLabel)
        nameLabel.addGestureRecognizer(UITapGestureRecognizer.init(target:self, action: #selector(nameLabelIsTapped(gesture:))))
        interactionItems.append(nameLabel)
        
        //背景图，需要交互
        let buttonTitle = ["profile","weiboContent","news"]
        for i in 0...2 {
            let button = UIButton.init()
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.setTitleColor(UIColor.red, for: UIControlState.selected)
            button.setTitle(buttonTitle[i], for: UIControlState.normal)
            button.addTarget(self, action: #selector(buttonIsTapped(button:)), for: UIControlEvents.touchUpInside)
            self.addSubview(button)
            interactionItems.append(button)
            buttons.append(button)
            if i == 0 {
                button.isSelected = true
            }
        }
    }
    
    //MARK: - target -
    @objc func avatarIsTapped(){
        print("avatar Is Tapped")

    }
    
    @objc func buttonIsTapped(button:UIButton) {
        let index = buttons.index(of: button)!
        self.setButtonSelected(index: index)
        
        guard let _ = delegate else{ return }
        delegate?.pagingHeaderViewButtonIsTapped(self, atIndex:index)
    }
    

    @objc func nameLabelIsTapped(gesture:UITapGestureRecognizer) {
        let f = CGFloat(arc4random()%255)/255.000
        
        print("label is tapped ,arc4random()%255) = \(f)")
        let Label = gesture.view! as! UILabel
        Label.textColor = UIColor.init(red: CGFloat(arc4random()%255)/255.000, green: CGFloat(arc4random()%255)/255.000, blue: CGFloat(arc4random()%255)/255.000, alpha: 1)
    }
    
    //    MARK: - layout and interaction -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth = self.frame.width/CGFloat(buttons.count)
        
        backGroundImage.mas_makeConstraints { (make) in
            make?.top.left().right().equalTo()(self)
            make?.bottom.equalTo()(self)?.offset()( -self.menuHeight)
        }

        for button in buttons {
            button.mas_makeConstraints({ (make) in
                make?.left.equalTo()(self)?.offset()(buttonWidth * CGFloat(self.buttons.index(of: button)!))
                make?.size.equalTo()(CGSize.init(width: buttonWidth, height: self.menuHeight))
                make?.bottom.equalTo()(self)
            })
        }
        
        nameLabel.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self)?.offset()( -self.menuHeight - 10)
            make?.left.right().equalTo()(self)
            make?.height.equalTo()(30)
        }
        
        avatar.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.size.equalTo()(CGSize.init(width: 50, height: 50))
            make?.bottom.equalTo()(self.nameLabel.mas_top)?.offset()(-20)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        //需要交互的元素，点击时触发点击响应
        for view in interactionItems {
            if view.frame.contains(point){
                return view
            }
        }
        
        //点击需要交互的元素以外的区域，不触发点击响应
        return nil
    }
    
    
    public func setButtonSelected(index atIndex:Int) {
        for bt in buttons {
            if buttons.index(of: bt)! == atIndex {
                bt.isSelected = true
            }else{
                bt.isSelected = false
            }
        }
    }
    
    
}

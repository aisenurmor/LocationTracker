//
//  BottomSheetViewController.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 23.03.2025.
//

import UIKit

final class BottomSheetViewController: UIViewController {
    
    private let contentView: UIView
    
    init(contentView: UIView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
    }
}

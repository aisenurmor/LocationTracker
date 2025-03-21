//
//  MapView.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 21.03.2025.
//

import UIKit

final class MapView: UIViewController {
    
    private weak var viewModel: MapViewModel!
    
    init(viewModel: MapViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location Tracker"
        
        view.backgroundColor = .white
    }
}

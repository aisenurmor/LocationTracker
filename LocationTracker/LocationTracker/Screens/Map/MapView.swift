//
//  MapView.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 21.03.2025.
//

import GoogleMaps
import UIKit

final class MapView: UIViewController {
    
    private var mapView: GMSMapView!
    
    private let viewModel: MapViewModel
    
    init(viewModel: MapViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupMapView()
    }
}

private extension MapView {
    
    func setupMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1)
        
        let options = GMSMapViewOptions()
        options.camera = camera
        options.frame = view.bounds
        
        mapView = GMSMapView(options: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        view.addSubview(mapView)
    }
}

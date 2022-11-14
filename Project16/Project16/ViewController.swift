//
//  ViewController.swift
//  Project16
//
//  Created by Oliwier Kasprzak on 24/10/2022.
//

import UIKit
import MapKit
import WebKit

class ViewController: UIViewController, MKMapViewDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let london = Capital(title: "London",coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the summer olympic in 2012")
        let oslo = Capital(title:"Oslo",coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "It was founded over 1000 years ago")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change map", style: .plain, target: self, action: #selector(changeMap))
        
 
        
        
    }
    
    @objc func changeMap(){
        let ac = UIAlertController(title: "Change map type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: settingMapStan))
        ac.addAction(UIAlertAction(title: "Satelite", style: .default, handler: settingMapSat))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: settingMapHybrid))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    func settingMapSat(action: UIAlertAction){
        
        mapView.mapType = MKMapType.satellite
            
       }
    func settingMapStan(action: UIAlertAction){
        
        mapView.mapType = MKMapType.standard
            
       }
    func settingMapHybrid(action: UIAlertAction){
        
        mapView.mapType = MKMapType.hybrid
            
       }
    
    
        
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let indentifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: indentifier)
        
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: indentifier)
            annotationView?.canShowCallout = true
            annotationView?.tintColor = .green
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView as? MKMarkerAnnotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Wikipedia", style: .default, handler: { _ in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? WebViewController {
                    if let title1 = placeName {
                    vc.website = "en.wikipedia.org/wiki/" + title1
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }))
        present(ac, animated: true)
    }
    
    func webViewPage(action: UIAlertAction){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? WebViewController {
            vc.loadView()
            vc.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
        
        
    }

}



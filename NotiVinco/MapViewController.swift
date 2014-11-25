//
//  MapViewController.swift
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 13/11/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    //outlets
    @IBOutlet var titleNote:UILabel!
    @IBOutlet var map:MKMapView!
    //distancia de radio en el mapa
    let searchDistance:CLLocationDistance = 1000
    //gestionador de la localizacion
    private var locationManager:CLLocationManager!
    //noticia a ser mostrada
    var noticia: Noticia?{
        didSet {//una vez con el elemento noticia configurado
            self.configureView()
        }
    }
    //metodo q configura la vista
    func  configureView(){
        if let detail: Noticia = self.noticia? {
            if let label = self.titleNote {
                label.text = detail.titleNoticia
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //inicializa el manejador de localización
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        //agrega el pin en el mapa
        self.map.addAnnotation(self.noticia)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //pide permiso para usar la localización
        self.checkLocationAuthorizationStatus()
        // llena la vista
        self.configureView()
    }
    //solicita permiso, si el permiso es concedido muestra la ubicacion del usuario en el mapa
    private func checkLocationAuthorizationStatus(){
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse{
            self.map.showsUserLocation = true
            if let location = self.map.userLocation.location {
                self.centerOnMapLocation(self.map.userLocation.location)
            }else   {
                if let  note = self.noticia?{
                    let pinlocation = CLLocation(latitude: note.location.latitude, longitude: note.location.longitude)
                    self.centerOnMapLocation(pinlocation)
                }
                
            }
        }else{
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    //centra el mapa un punto determidado
    private func centerOnMapLocation(location:CLLocation){
        let coordiateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, searchDistance, searchDistance)
        self.map.setRegion(coordiateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension MapViewController: CLLocationManagerDelegate{
    //metodo que se ejecuta cuando el permiso de localización ha sufrido cambios
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.checkLocationAuthorizationStatus()
    }
}

extension MapViewController:MKMapViewDelegate{
    //metodo que se ejecuta cuando se agrega una anotación en el mapa
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Noticia{
            let identifier = "Pin"
            var view: MKPinAnnotationView
            if let dequeuedView =  mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
    }
}
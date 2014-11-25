//
//  ReportViewController.swift
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 12/11/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

import UIKit
import CoreLocation

class ReportViewController: UIViewController {
    //vista blanca que se sobrepone para evitar envio de eventos
    var overlayview:UIView =  UIView()
    //imagen seleccionada de la camara o galeria
    var selectedImage:UIImage = UIImage()
    //outlets
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tvContent: UITextView!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var camerabtn: UIButton!
    @IBOutlet var lblLocation: UILabel!
    //manejador de localización
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuWillBeOpen", name: "menuWillOpen", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuWillBeClose", name: "menuWillClose", object: nil)
        //configurar la UI 
        btnSend.layer.cornerRadius=10
        tvContent.layer.cornerRadius=10
        tvContent.layer.borderWidth = 1
        //inicializar la localización
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        //setear el tap gesture
        let tapgesture = UITapGestureRecognizer(target: self, action: "dismisKeyboard")
        self.view.addGestureRecognizer(tapgesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //metodo que revisa los permisos de localizacion, solicita acceso o localiza al usuario
    private func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    // MARK: - IBActions
    //metodo que muestra el menu lateral
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    //metodo encargado de enviar datos
    @IBAction func sendData(sender: AnyObject){
        
    }
    //metodo que se ejecuta al presionar el boton de la camara
    @IBAction func takePicture(sender:AnyObject){
        //puede ser camara o galeria
        //se inicializa un actionsheet para elegir cual tomar
        let actionSheet = UIAlertController(title:nil, message: "Selecciona uno", preferredStyle: .ActionSheet)
        //boton cancelar
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        //boton tomar foto
        let takePhotoAction = UIAlertAction(title: "Tomar foto", style: .Default) {
            (action:UIAlertAction!) in
            //llama a iniciar la camara
            self.startCamera()
        }
        //boton galeria
        let showGalleryAction = UIAlertAction(title: "Galería", style: .Default) {
            (action:UIAlertAction!) in
            //llama iniciar galeria
            self.showGallery()
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(showGalleryAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        
    }
    // MARK: - GestureRecognizer responder
    func dismisKeyboard(){
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
    }
    
    // MARK: -  Notification Handler
    func closeMenu(){
        toggleSideMenuView()
    }
    func menuWillBeOpen(){
        overlayview = UIView(frame: self.view.bounds)
        overlayview.backgroundColor=UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let tapgesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "closeMenu")
        overlayview.addGestureRecognizer(tapgesture)
        self.view.addSubview(overlayview)
    }
    func menuWillBeClose(){
        overlayview.removeFromSuperview()
    }
    //MARK: - Photos
    //metodo para abrir la galeria
    private func showGallery(){
        let galleryController = UIImagePickerController()
        galleryController.delegate = self
        galleryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(galleryController, animated: true, completion: nil)
        
    }
    //metodo para iniciar la camara
    private func startCamera(){
        //revisamos que exista cámara trasera
        if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear){
            //iniciamos la camara
            let cameraController =  UIImagePickerController()
            cameraController.delegate = self
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(cameraController, animated: true, completion: nil)
        }else{
            //mandamos alerta de q no hay cámara
            let alert =  UIAlertController(title: "Lo sentimos", message: "tu dispositivo no tiene cámara", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
}
//extension que hace uso de metodos delegados del corelocationmanager

extension ReportViewController:CLLocationManagerDelegate{
    //metodo que captura cambios en los permisos de localización
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.checkLocationAuthorizationStatus()
    }
    //metodo que captura la localización del usuario
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //detenemos la busqueda por ahorro de batería
        self.locationManager.stopUpdatingLocation()
        //obtenemos la localización mas reciente
        let currentLocation: CLLocation = locations.last as CLLocation
        //buscamos el nombre de la colonia y la ciudad
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks:[AnyObject]!, error:NSError!) in
            // si hubo error al traer esos datos no se hace nada
            if error != nil{
                return;
            }
            //si hay algun lugar relacionado se despliega la informacion
            if placemarks.count != 0{
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            }
        })
        
        // escribimos la localizacion en pantalla con la etiqueta
        if let label = self.lblLocation {
            label.text = "Location:(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))"
        }
    }
    func displayLocationInfo(placemark: CLPlacemark) {
        // una vez obtenido el lugar imprimimos: localizacion, colonia y pais
        if let label = self.lblLocation {
            label.text = "Location:(\(placemark.location.coordinate.latitude),\(placemark.location.coordinate.longitude))\n" + placemark.subLocality + ", " + placemark.locality
        }
    }
}
//extension que responde a los metodos delegados del textfield
extension ReportViewController: UITextFieldDelegate{
    //si se presiona el boton siguiente en el teclado del textfield se ejecuta este metodo
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //el textfield debe dejar de responder al teclado
        textField.resignFirstResponder()
        //el textview debe empezar a responder al teclado
        tvContent.becomeFirstResponder()
        return true
    }
}
//extension que responde a los metodos delegados del textview
extension ReportViewController:UITextViewDelegate{
    //metodo que captura el texto y se ejecuta cuando el usuario escribe
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        //se captura el enter si es enter el textview deja de responder al teclado
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    //metodo que se ejecuta cuando se empieza a editar el textview
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Descripción" {//se fija que el texto sea 'Descripción'
            textView.text = ""              // de ser así limpia el textview
        }
    }
}
//extension que reacciona a la los metodos de la seleccion de la galeria o de captura via camara
extension ReportViewController:UINavigationControllerDelegate,  UIImagePickerControllerDelegate{
    //se selecciona una imagen en camara o galería
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // se captura la imagen
        self.selectedImage = image
        // se hace algo con ella
//        if let btn = self.camerabtn{
//            btn.setImage(selectedImage, forState: UIControlState.Normal)
//        }
        // cerramos la cámara o la galeria
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // se seleccionó cancelar en la camara o galería
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // cerramos la cámara o la galeria
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

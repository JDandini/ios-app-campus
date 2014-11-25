//
//  DetailViewController.swift
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 10/11/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {
    @IBOutlet var noticiaImage: UIImageView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
   
    
    var noticia: Noticia?{
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Noticia = self.noticia? {
            if let label = self.detailDescriptionLabel {
                label.text = detail.content
            }
            //bajamos la imagen para llenar el placeholder
            if let urlstr = self.noticia?.urlString{
                let url = NSURL(string: urlstr)
                let request = NSURLRequest(URL: url!)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response: NSURLResponse!, data: NSData!, error: NSError!) in
                        let image = UIImage(data: data)
                        self.noticiaImage.image = image
                })
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationPressed(sender:AnyObject){
        //enviando al mapa
        self.performSegueWithIdentifier("mapview", sender: self)
    }
    //metodo q envia a compartir la noticia
    @IBAction func sharePressed(sender:AnyObject){
        //inicializamos un actionSheet con tres opciones, cancelar, facebook y twitter
        let actionSheet = UIAlertController(title: nil, message: "A donde quieres compartir?", preferredStyle: .ActionSheet)
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
        let facebookAction = UIAlertAction(title: "Facebook", style: .Default) {
            (action:UIAlertAction!) in
            //mostramos el compose de facebook
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){//nos fijamos si hay cuenta de facebook
                //llenamos el composer con el texto mira esta noticia y la imagen que descargamos
                let composer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                composer.setInitialText("Mira esta noticia")
                composer.addImage(self.noticiaImage.image)
                self.presentViewController(composer, animated: true, completion: nil)
            }else {
                // si no hay cuenta avisamos al usuario que no hay cuenta asociada
                let alert  = UIAlertController(title: "Lo sentimos", message: "Debes tener una cuenta de facebook en el dispositivo", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        let twitterAction = UIAlertAction(title: "Twitter", style: .Default) {
            (action:UIAlertAction!) in
            //mostramos el compose de twitter
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){//nos fijamos si hay cuenta de twitter
                //llenamos el composer con el texto mira esta noticia y la imagen que descargamos
                let composer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                composer.setInitialText("Mira esta noticia")
                composer.addImage(self.noticiaImage.image)
                self.presentViewController(composer, animated: true, completion: nil)
            }else {
                // si no hay cuenta avisamos al usuario que no hay cuenta asociada
                let alert  = UIAlertController(title: "Lo sentimos", message: "Debes tener una cuenta de twitter en el dispositivo", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(cancel)
        actionSheet.addAction(facebookAction)
        actionSheet.addAction(twitterAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    // mandandole la notica al mapa
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapview"{
            var map = segue.destinationViewController as? MapViewController
            map?.noticia = self.noticia
        }
    }

}


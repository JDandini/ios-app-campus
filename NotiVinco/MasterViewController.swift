//
//  MasterViewController.swift
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 10/11/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    private var news: [Noticia] = []  //variable del tipo Array (de strings) que será el que contenga las noticias
    //feed JSON de las noticias
    let jsonURL = "https://gist.githubusercontent.com/GustavoAxel/bea697325747ed2b2b84/raw/ad8df55cecd252db33a436b6abdb739b834bc903/noticias_feed.json"
    //vista negra que se pone encima de la vista
    var overlayview:UIView =  UIView()
    //metodo del ciclo de vida de la applicacion
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuWillBeOpen", name: "menuWillOpen", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuWillBeClose", name: "menuWillClose", object: nil)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let url =  NSURL(string: self.jsonURL)!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
        {
            (response: NSURLResponse!, data: NSData!, error: NSError!) in
            if error != nil {
                println("Error: \(error.description)")
                let alert = UIAlertController(title: "¡Oh no!", message: "Algo salió mal intenta mas tarde", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default , handler: nil))
                self .presentViewController(alert, animated: true, completion: nil)
            }else  {
                var error:NSError?
                let jsonObj: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
                if let jsonArray = jsonObj as? [AnyObject] {
                    if error == nil {
                        if  let data = JSONValue.fromObject(jsonArray)?.array{
                            var allnews:[Noticia] = []
                            for noticiaRAW  in data{
                                if let noticiaJSON = noticiaRAW.object{
                                    if let noticia = Noticia.fromJSON(noticiaJSON){
                                        allnews.append(noticia)
                                    }
                                }
                            }
                            self.news = allnews
                            self.tableView.reloadData()
                            
                        }
                    }
                }
            }
        }
    }
    //metodo que se ejecuta cuando se tiene un warning de memoria.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - IBActions
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
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
}

// MARK: - UITableViewDataSource methods
extension MasterViewController{
    //metodo el cual regresa el numero de secciones en la tabla
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //metodo que especifica el numero de renglones por seccion en la tabla
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    //metodo que regresa la celda para cada renglón en la tabla
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as CellNews
        cell.titulo.text = news[indexPath.row].titleNoticia
        cell.descripcion.text = news[indexPath.row].content
        cell.date.text = news[indexPath.row].date
        return cell
    }

}
// MARK: - UITableViewDelegate Methods

extension MasterViewController{
    //metodo que se ejecuta al seleccionar un elemento en la tabla
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - Navegación
extension MasterViewController{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                var detail = segue.destinationViewController as DetailViewController
                detail.noticia = news[indexPath.row]
            }
        }
    }
}


//
//  ViewController.swift
//  SoapWebServiceSwift
//
//  Created by MACOS on 7/3/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController,XMLParserDelegate {

    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var lbl: UILabel!
    
    
    var strcontent = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnclick(_ sender: Any) {
        
        let url = URL(string: "http://dneonline.com/calculator.asmx");
        
        let soapbody = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><Add xmlns='http://tempuri.org/'><intA>\(txt1.text!)</intA><intB>\(txt2.text!)</intB></Add></soap:Body></soap:Envelope>"
        
        let length = soapbody.characters.count;
        
        var request = URLRequest(url: url!);
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String(length), forHTTPHeaderField: "Content-Length")
        request.addValue("http://tempuri.org/Add", forHTTPHeaderField: "SOAPAction")
        request.httpMethod = "POST";
        request.httpBody = soapbody.data(using: String.Encoding.utf8);
        
        let session = URLSession.shared;
        
        let datatask =  session.dataTask(with: request, completionHandler: {(data1, res, err) in
            
            let str = String(data: data1!, encoding: String.Encoding.utf8);
            
            print(str);
            
            let parse = XMLParser(data: data1!);
            parse.delegate = self;
            
            parse.parse();
            
        });
        datatask.resume();
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        
        if elementName == "AddResult"
        {
            
            DispatchQueue.main.async {
                
                self.lbl.text = self.strcontent;
                print( self.strcontent);
                
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        strcontent = string;
    }
    

}


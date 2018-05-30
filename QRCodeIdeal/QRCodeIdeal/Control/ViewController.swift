//
//  ViewController.swift
//  QRCode_ideal
//
//  Created by Bruno Vieira on 26/05/18.
//  Copyright © 2018 Bruno Vieira. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MessageUI

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate
{
    //variables for capture device and print qrcode
    var video = AVCaptureVideoPreviewLayer()
    var qrCodeFrameView:UIView?
    
    //variable for storage the strings fo qrcode and write into the file
    var list: [String] = []
    var lastGenerateQRCode: String?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            list.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! QRTableViewCell
        cell.qrLbl.text = list[indexPath.row]
        
        let data = list[indexPath.row].data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        let img = UIImage(ciImage: (filter?.outputImage)!)
        
        cell.qrImage.image = img
        
        return(cell)
    }



//    class globalLink {
//        var url: String = ""
//        var values: String{
//            get{
//                return url
//            }
//            set(newUrl){
//                url = newUrl
//            }
//        }
//    }
    
    //variables of button
    @IBOutlet weak var btnGenerate: UIButton!
    @IBOutlet weak var btnScan: UIButton!
    
    //variables of uiview
    @IBOutlet weak var QRImgView: UIImageView!
    @IBOutlet weak var UIViewQRCode: UIView!
    @IBOutlet weak var UIViewScan: UIView!
    @IBOutlet weak var UIViewPopUp: UIView!
    
    //text filds and labels all so
    @IBOutlet weak var TFQRCode: UITextField!
    
    //table view
    @IBOutlet weak var tableView: UITableView!
    
    // switch segment
    @IBOutlet weak var switchSegment: UISegmentedControl!
    
    //func for create the qrcode from text
    @IBAction func btnGenerateQRCode(_ sender: Any) {
        
        UIViewQRCode.isHidden = false;
        UIViewQRCode.layer.cornerRadius = 2
        UIViewQRCode.layer.borderWidth = 0.5
        UIViewQRCode.layer.borderColor = UIColor.blue.cgColor
        
        if(TFQRCode.text == ""){
            UIViewQRCode.isHidden = true;
            let alert = UIAlertController(title: "Error", message: "Você precissa adicionar algum link ou texto", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated:true, completion: nil)
            
        }else{
            if let link = TFQRCode.text {
                QRImgView.image = generateQRCode(link: link)
                //list.append(link)
                writeFile(data: link)
                //savePhoto()
                toShareImg(value: TFQRCode.text!)
            }
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Atualiza a tabela
        tableView.delegate = self
        tableView.dataSource = self
        styleButton(button: btnScan)
        switchSegment.layer.borderColor = UIColor.clear.cgColor
    }

    //func que lê o código de barras e gera um alerta com opções de copiar e scanear outro qrcode
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects != nil && metadataObjects.count != 0
            {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                    UIPasteboard.general.string = object.stringValue
                }))
                present(alert, animated:true, completion: nil)
            }
        }
    }
    
    //this button remains to the swith segment and controls the interation of elements on view
    @IBAction func switchSegmentAct(_ sender: Any) {
        
        switch switchSegment.selectedSegmentIndex {
            
        case 0:
            hiddenAll()
            btnScan.isHidden = false;
            UIViewScan.isHidden = false;
            
        case 1:
            hiddenAll()
            //readFile()
            tableView.isHidden = false;
            self.tableView.reloadData()
        case 2:
            hiddenAll()
            btnGenerate.isHidden = false;
            TFQRCode.isHidden = false;
            btnGenerate.layer.cornerRadius = 2;
            TFQRCode.layer.cornerRadius = 2
            TFQRCode.text = ""
            
        case 3:
            toShare()
        case 4:
            let mailComposeViewController = configureMailController()
            if MFMailComposeViewController.canSendMail(){
                self.present(mailComposeViewController, animated: true, completion: nil)
            }else{
                showMailError()
            }
        default: break
            
        }
              
    }
    
    //this func write and read the file from the variable list
    func writeFile(data: String){
//
//
//        // Create a FileManager instance
//        let fileManager = FileManager.default
//        // Create 'subfolder' directory
//        do {
//            try fileManager.createDirectory(atPath: "/qrcode", withIntermediateDirectories: true, attributes: nil)
//        }
//        catch let error as NSError {
//            print("Error \(error)")
//        }
//
        let fileName = "file.txt"
        var fileWrite = ""
        var filePath = ""
        
        // File documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
            fileWrite.append("\(data)")
            print(fileName)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            return
        }
        // Set the contents
        let fileContentToWrite = data
        
        do {
            // Write contents to file
            try fileContentToWrite.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        do{
            //read the file
            let contentFrameFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            self.list.append(contentFrameFile as String)
            print(">>>>>>>>>>>>>>>>>>>>>>>>>> \(contentFrameFile)")
            
            //save the last qrcode data generate
            lastGenerateQRCode = contentFrameFile as String
        }catch {print("Não foi possível ler o arquivo")}
    }
    
    func readFile() -> String{
        let filePath = "/file.txt" //this is the file. we will write to and read from it
        var file = ""
        do{
            let contentFrameFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            file.append(contentFrameFile as String)
            print("HUEHUEHEUHUE \(contentFrameFile)")
        }catch {print("Não foi possível ler o arquivo / func readFile()")}
        return file
    }
    
    //styles the button
    func styleButton(button: UIButton){
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.green.cgColor
    }
    
    //this func always so capture the qrcode, but is a separete func
    func captureQR(){
        let session = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch{
            print("error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: UIViewScan)
        session.startRunning()
        
    }
    //this fuc hidden all views and buttons on view master
    func hiddenAll(){
        btnScan.isHidden = true;
        UIViewScan.isHidden = true;
        tableView.isHidden = true;
        btnGenerate.isHidden = true;
        TFQRCode.isHidden = true;
        TFQRCode.clearsOnInsertion = true
        UIViewPopUp.isHidden = true;
        UIViewQRCode.isHidden = true;
    }
    func toShare(){
        //recept the values and share
        let textToShare = "https://sac.digital/"
        
        let objectsToShare = [textToShare] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    func toShareImg(value: String) {
        let data = value
        let alertController = UIAlertController(title: "QRCode Ideal", message: data, preferredStyle: .alert)
        var url = UIAlertAction()
        let secondActivityItem : NSURL = NSURL(string: self.lastGenerateQRCode!)!
        
        if self.verifyUrl(urlString: "\(secondActivityItem)"){
            url = UIAlertAction(title: "Open in Safari", style: .default) {(action) in
                UIApplication.shared.open(NSURL(string: self.lastGenerateQRCode!)! as URL);
                return;
            };
            alertController.addAction(url)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: { x -> Void in
        
            let firstActivityItem = self.lastGenerateQRCode!
            
            
            // If you want to put an image
            let image: UIImage = self.QRImgView.image!
            
                let activityViewController : UIActivityViewController = UIActivityViewController(
                    activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivityType.postToWeibo,
                UIActivityType.print,
                UIActivityType.assignToContact,
                UIActivityType.saveToCameraRoll,
                UIActivityType.addToReadingList,
                UIActivityType.postToFlickr,
                UIActivityType.postToVimeo,
                UIActivityType.postToTencentWeibo
            ]
        
            self.present(activityViewController, animated: true, completion: nil)
        })
        
        alertController.addAction(shareAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func generateQRCode(link: String) -> UIImage{
        let data = link.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 1, y: 1)
        
        let img = filter?.outputImage?.transformed(by: transform)
        return UIImage(ciImage: img!)
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    func savePhoto(){
        let imageData = UIImagePNGRepresentation(self.QRImgView.image!)
        let compreedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compreedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "saved", message: "YOutt image save vlw", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["brunokasv@ucl.br"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //Send email to developer
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["brunokasv@ucl.br"])
        mailComposerVC.setSubject("Hello")
        mailComposerVC.setMessageBody("<p>E ae cara blz!</p>", isHTML: false)
        
        return mailComposerVC
    }
    //Show some error that maybe its gonna be
    func showMailError(){
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    //Controller of mail
    func mailComposerController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        controller.dismiss(animated: true, completion: nil)
    }
}





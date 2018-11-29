//
//  BluetoothControll.swift
//  MiBand2TesteSingleton
//
//  Created by Luciano Pezzin on 20/07/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//
import UIKit
import Foundation
import CoreBluetooth
import CryptoSwift

protocol CheckBluetooth {
    func updateSwitchMiband()
    func timeOut()
    func bluetoothOff(state: String)
}
protocol LoadingBluetooth {
    func stopLoading()
}
protocol ConfigLoadingBluet {
    func stopLoading()
}
class BluetoothControll: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    typealias Conetando = (Bool) -> ()
    
    var centralManager: CBCentralManager!
    var miband: CBPeripheral!

    
    var statusbluet: CBManagerState!
    var b: CheckBluetooth?
    var b2: LoadingBluetooth?
    var b3: ConfigLoadingBluet?
    
    var servico_auth: CBService!
    var servico_info: CBService!
    var servico_alert: CBService!
    var servico_notify: CBService!
    var servico_miband: CBService!
    var servico_heart: CBService!
    
    var peripheralMiband: CBPeripheralManager!
    var descriptor_miband: CBDescriptor!
    
    var cc_auth: CBCharacteristic!
    var cc_notify: CBCharacteristic!
    var cc_alert: CBCharacteristic!
    var cc_baterry: CBCharacteristic!
    var cc_firmware: CBCharacteristic!
    var cc_hardware: CBCharacteristic!
    var cc_touch: CBCharacteristic!
    var cc_heart: CBCharacteristic!
    
    private var afterPeripheralDiscovered : ((_ cbPeripheral:CBPeripheral, _ advertisementData:NSDictionary, _ RSSI:NSNumber)->())?
    
    
    var miband_battery_percent: String!
    var miband_identifier: String!
    var miband_firmware_version: String!
    var miband_hardware_version: String!
    
    var pareado: Bool!
    var connectado: Bool!
    var tentativas = 0
    var backgroundTask = UIApplication.shared
    
    var viewAtual: String!
    var count = 0
    var connected = true
    var error: String!
    
    var identifier = "minha_miband"
    
    static let shared = BluetoothControll()
    
    private override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBConnectPeripheralOptionNotifyOnConnectionKey:true,CBCentralManagerOptionRestoreIdentifierKey:identifier])
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        //print(characteristic.uuid.uuidString)s
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("unknown")
            statusbluet = central.state
        case .resetting:
            print("resetting")
            statusbluet = central.state
        case .unsupported:
            print("unsupported")
            statusbluet = central.state
        case .unauthorized:
            print("unauthorized")
            statusbluet = central.state
        case .poweredOff:
            print("Bluetooth Off")
            statusbluet = central.state
            b?.bluetoothOff(state: "Bluetooth está OffLine. Por favor, religue seu Bluetooth e tente outra vez")
        case .poweredOn:
            print("Bluetooth On")
            checkStatusMiband()
            statusbluet = central.state
        }
    }
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        
    }
    
    func checkStatusMiband() {
        if let identifier = UserDefaults.standard.value(forKey: "identifier") as? String {
            //necessita consultar o banco se existe o peripheral
            if let state = UserDefaults.standard.value(forKey: "miband_activate") as? Bool {
                if state {
                    let peripheral = centralManager.retrievePeripherals(withIdentifiers: [UUID(uuidString: identifier)!])
                    miband = peripheral.first
                    connect()
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("restore")
    }
    
    func registerBackgroundTask() {
        
    }
    func scan() {
        centralManager.scanForPeripherals(withServices: [MiBand2Constants.MIBAND_SERVICE], options: nil)
        print("Iniciando busca")
        connectado = false
        pareado = false
    }
    
    
    func connect() {
        if miband != nil {
            centralManager.connect(miband, options: [CBConnectPeripheralOptionNotifyOnNotificationKey:true])
            
            print("Connectando com: ", miband.identifier)
        } else {
            print("Periferico nil")
        }
    }
    
    func connectAfterMain(completed: @escaping Conetando) {
        if miband != nil {
            centralManager.connect(miband, options: nil)
            print("Connectando com: ", miband.identifier)
        } else {
            print("Periferico nil")
        }
    }

    func disconnect() {
        connected = false
        if miband != nil {
            centralManager.cancelPeripheralConnection(miband)
            print("Desconnectado com: ", miband.identifier)
            UserDefaults.standard.set(false, forKey: "miband_on_off")
        } else {
            print("Periferico nil disconnect")
        }
    }

    /*Envia notificação
     - @paran: [UInt8]
     - @return: Notificação com ícone
     */
    func enviarNotificacao(tipo: [UInt8]) {
        let bytesToWrite:[UInt8] = tipo
        let data = NSData(bytes: bytesToWrite, length: bytesToWrite.count)
        
        miband.writeValue(data as Data, for: cc_notify, type: .withResponse)
    }
    
    /*Enviar vibração
     - @paran: [UInt8]
     - @return: Notificação sem ícone
     */
    func enviarAlert(tipo: [UInt8]) {
        let bytesToWrite:[UInt8] = tipo
        let data = NSData(bytes: bytesToWrite, length: bytesToWrite.count)
        miband.writeValue(data as Data, for: cc_alert, type: .withoutResponse)
    }
    
    /*Ativa notificação para pareamento
     - @paran: nil
     - @return: Permissão para parear
     */
    func ativarNotificacoes() {
        print("Ativar Notificação")
        miband.setNotifyValue(true, for: cc_auth)
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print("descriptor")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("descriptor")
    }
    
    /* Envia requisicão de pareamento
     - @paran: nil
     - @return: Resposta UInt8 com success ou fail
     */
    func parear(){
        print("iniciando pareamento")
        var rawArray:[UInt8] = [0x01, 0x8, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45]
        let data = NSData(bytes: &rawArray, length: rawArray.count)
        miband.writeValue(data as Data, for: cc_auth, type: .withoutResponse)
    }
    
    func touchEvent() {
        miband.setNotifyValue(true, for: cc_touch)
    }
    /* Envia requisição
     - @paran: [UInt8]
     - @return: Notificação com ícone
     */
    @objc func reconnect() {
        var rawArray:[UInt8] = [0x02, 0x8]
        let data = NSData(bytes: &rawArray, length: rawArray.count)
        miband.writeValue(data as Data, for: cc_auth, type: .withoutResponse)
        print("Auth step reconnect")
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        setError(error: error)
        
        self.peripheralIsReady(toSendWriteWithoutResponse: peripheral)
        let valor = characteristic.value
        print(valor)
        if valor![0] == 0x10 && valor![1] == 0x01 && valor![2] == 0x01 {
            var rawArray:[UInt8] = [0x02, 0x8]
            let data = NSData(bytes: &rawArray, length: rawArray.count)
            peripheral.writeValue(data as Data, for: cc_auth, type: .withoutResponse)
            print("Auth step 1")
        } else if valor![0] == 0x10 && valor![1] == 0x02 && valor![2] == 0x01 {
            print("Auth step 2")
            var bytes: Array<UInt8> = []
            for i in 0..<19 {
                if(i > 2){
                    bytes.append(valor![i])
                }
            }
            

            let result = aes_Encrypt(input: bytes)
            var rawArray:[UInt8] = [0x03, 0x08]+result
            let data = NSData(bytes: &rawArray, length: rawArray.count)
            peripheral.writeValue(data as Data, for: cc_auth, type: .withoutResponse)
        }
        else if (valor![0] == 0x10 && valor![1] == 0x03 && valor![2] == 0x01){
            print("Auth step 3")
            self.pareado = true
            print("😆🌚👀🚀🚀🚀")
            
            connected = true
            if viewAtual == "scan" {
                b?.updateSwitchMiband()
                b3?.stopLoading()
                viewAtual = "ki"
            } else {
                b2?.stopLoading()
                b3?.stopLoading()
            }

            UserDefaults.standard.set(true, forKey: "miband_on_off")
            UserDefaults.standard.set(self.miband.identifier.uuidString, forKey: "identifier")
        } else  {
            if (valor![0] == 0x10 && valor![1] == 0x01 && valor![2] == 0x02){
                print("cancelou pareamento")
                disconnect()
                miband = nil
                b?.timeOut()
            }
            if valor![0] == 4 {
                if count == 3 {
                    print("HSUAHSUAUS")
                    count = 0
                } else {
                    count += 1
                }
            }
            if valor?.count == 20 {
                self.miband_battery_percent = "\(valor![1])"
            }
            if valor?.count == 9 {
                let string = String(bytes: valor!, encoding: .utf8)
                self.miband_firmware_version = string
            }
            if valor?.count == 8 {
                let string = String(bytes: valor!, encoding: .utf8)
                self.miband_hardware_version = string
            }
            if valor![0] == 7 {
                print("cancelou")
            }
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        print("entrou no descriptor")
    }
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print(RSSI)
    }
    func getHeart() {
        self.miband.readValue(for: self.cc_heart)
        
    }
    /* Requisição level bateria
     - @paran: [UInt8]
     - @return: Int on didUpdateValueFor
     */
    func getBattery() {
        miband.readValue(for: cc_baterry)
    }
    /* Requisição V. Firmware
     - @paran: [UInt8]
     - @return: String on didUpdateValueFor
     */
    func getFirmware() {
        miband.readValue(for: cc_firmware)
    }
    /* Requisição Hardware
     - @paran: [UInt8]
     - @return: String on didUpdateValueFor
     */
    func getHardware() {
        miband.readValue(for: cc_hardware)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        setError(error: error)
        print("Charc", characteristic.uuid)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        setError(error: error)
        for serv in peripheral.services! {
            switch serv.uuid.uuidString {
            case "180A":
                servico_info = serv
                miband.discoverCharacteristics(nil, for: serv)
                break
            case "FEE1":
                servico_auth = serv
                miband.discoverCharacteristics(nil, for: serv)
                break
            case "FEE0":
                self.servico_miband = serv
                self.miband.discoverCharacteristics(nil, for: serv)
                break
            case "1802":
                self.servico_alert = serv
                self.miband.discoverCharacteristics(nil, for: serv)
                break
            case "1811":
                self.servico_notify = serv
                self.miband.discoverCharacteristics(nil, for: serv)
                break
            case "180D":
                self.servico_heart = serv
                self.miband.discoverCharacteristics(nil, for: serv)
            default:
                break
            }
        }
    }
    
    /* Func que cria a chave de criptografia pra enviar pro bluetooth
     - @paran: Array<UInt8>
     - @return: [UInt8]
     */
    func aes_Encrypt(input: Array<UInt8>) -> [UInt8] {
        let key: Array<UInt8> = [0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45]
        do {
            let encrypted = try AES(key: key, blockMode: ECB(), padding: .noPadding).encrypt(input)
            return encrypted
        } catch {
            print(error)
            return []
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        setError(error: error)
        for cc in service.characteristics! {
            //print("Charc: ",cc.uuid.uuidString)
            if cc.uuid == MiBand2Constants.AUTH_CHARACTERISTIC {
                self.cc_auth = cc
                self.ativarNotificacoes()
                if let identifier = UserDefaults.standard.value(forKey: "identifier") as? String {
                    if identifier != miband.identifier.uuidString {
                        parear()
                    } else {
                        reconnect()
                    }
                } else {
                    parear()
                }
            }
            if cc.uuid == MiBand2Constants.UUID_TOUCH_CHARACTERISTIC {
                cc_touch = cc
            }
            if cc.uuid == MiBand2Constants.UUID_ALERT_CHARACTERISTIC {
                cc_alert = cc
            }
            if cc.uuid == MiBand2Constants.UUID_ALERT_NOTIFICATION_CHARACTERISTIC {
                self.cc_notify = cc
            }
            if cc.uuid.uuidString == MiBand2Constants.BATTERY_LEVEL_CHARACTERISTIC_STRING {
                self.cc_baterry = cc
                getBattery()
            }
            if cc.uuid.uuidString == MiBand2Constants.FIRMWARE_REVISION_STRING {
                self.cc_firmware = cc
                self.getFirmware()
            }
            if cc.uuid.uuidString == MiBand2Constants.HARDWARE_REVISION_STRING {
                self.cc_hardware = cc
                self.getHardware()
            }
            if cc.uuid == MiBand2Constants.UUID_HEART_RATE_CONTROL_POINT_CHARACTERISTIC {
                cc_heart = cc
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connectado: ",peripheral.identifier)
        self.miband_identifier = peripheral.identifier.uuidString
        miband.delegate = self
        miband.discoverServices([])
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Falha na conexão")
        b?.timeOut()
        setError(error: error)
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnect: ", peripheral.identifier)
        
        setError(error: error)
        if connected {
            centralManager.connect(peripheral, options: nil)
        }
    }

    func setError(error: Error?) {
        self.error = error.debugDescription
    }
    func getError() -> String {
        if error != nil {
            let erro = self.error
            self.error = nil
            return erro!
        } else {
            return ""
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Mi Band encontrada: ", peripheral.identifier)
        if let afterPeripheralDiscovered = self.afterPeripheralDiscovered {
            afterPeripheralDiscovered(peripheral, advertisementData as NSDictionary, RSSI)
        }
        if peripheral.name == "MI Band 2" {
            miband = peripheral
            connect()
            centralManager.stopScan()
            print("Scan parado!")
        }
        
    }
}





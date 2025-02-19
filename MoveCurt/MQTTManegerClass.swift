//
//  File.swift
//  MoveCurt
//
//  Created by Cauan Lopes Galdino on 28/01/25.
//

import CocoaMQTT

// Classe gerenciadora MQTT
class MQTTManager: NSObject, ObservableObject {
    private var mqttClient: CocoaMQTT?
    
    // Propriedades observáveis para integração com SwiftUI
    @Published var connectionState: MQTTConnectionState = .disconnected
    @Published var receivedMessage: String = "" // Mensagem recebida do brokers
    @Published var subscribedTopic: String = " " // Tópico subscrito

    // Propriedades de configuração
    private var identifier: String = ""
    private var host: String = ""
    private var username: String?
    private var password: String?
    
    func initializeMQTT(host: String, identifier: String, username: String? = nil, password: String? = nil) {
        if mqttClient != nil {
            mqttClient = nil
        }
        self.identifier = identifier
        self.host = host
        self.username = username
        self.password = password
        
        let clientID = "CocoaMQTT-\(identifier)-" + String(ProcessInfo().processIdentifier)
        mqttClient = CocoaMQTT(clientID: clientID, host: host, port: 1883) // Porta padrão do MQTT
        
        // Configurações adicionais
        if let finalUsername = self.username, let finalPassword = self.password {
            mqttClient?.username = finalUsername
            mqttClient?.password = finalPassword
        }
        mqttClient?.willMessage = CocoaMQTTMessage(topic: "/will", string: "dieout")
        mqttClient?.keepAlive = 60
        mqttClient?.delegate = self
    }
    
    func connect() {
        guard let mqttClient = mqttClient else { return }
        self.connectionState = .connecting
        _ = mqttClient.connect()
    }
    
    func disconnect() {
        mqttClient?.disconnect()
        self.connectionState = .disconnected
    }
    
    func subscribe(topic: String) {
        mqttClient?.subscribe(topic, qos: .qos2)
        self.subscribedTopic = topic
    }
    
    func publish(topic: String, message: String) {
        mqttClient?.publish(topic, withString: message, qos: .qos2)
    }
}

extension MQTTManager: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("Mensagem publicada com sucesso. ID: \(id)")
        // Aqui você pode atualizar o estado do app, exibir uma mensagem de sucesso, etc.
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("Desinscrito dos tópicos: \(topics)")
        // Atualize o estado da interface, se necessário.
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("Ping enviado ao servidor MQTT")
        // Você pode usar isso para monitorar a conexão.
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("Pong recebido do servidor MQTT")
        // Isso indica que a conexão com o servidor está ativa.
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: (any Error)?) {
        if let error = err {
            print("Desconectado do servidor MQTT com erro: \(error.localizedDescription)")
        } else {
            print("Desconectado do servidor MQTT sem erros.")
        }
        // Atualize a interface ou tente reconectar, dependendo do caso.
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            self.connectionState = .connected
            print("Conexão bem-sucedida ao broker!")
        } else {
            self.connectionState = .error("Erro ao conectar ao broker: \(ack)")
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didDisconnectWithError error: Error?) {
        self.connectionState = .disconnected
        print("Desconectado do broker. Erro: \(String(describing: error))")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        guard let payload = message.string else { return }
        self.receivedMessage = payload
        print("Mensagem recebida no tópico \(message.topic): \(payload)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("Subscrição bem-sucedida nos tópicos: \(success.allKeys)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Mensagem publicada no tópico \(message.topic)")
    }
}

// Enum para representar estados do app
enum MQTTConnectionState: Equatable {
    case disconnected
    case connecting
    case connected
    case error(String)
}

//
//  ContentView.swift
//  MoveCurt
//
//  Created by Cauan Lopes Galdino on 28/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mqttManager = MQTTManager()
    @State private var inputMessage: String = ""
    @State private var inputTopic: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Estado da conexão
            Text("Estado da conexão: \(connectionStatusText)")
                .foregroundColor(connectionStatusColor)
            
            // Subscrição
            TextField("Tópico para subscrever", text: $inputTopic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Subscrever") {
                mqttManager.subscribe(topic: inputTopic)
            }
            .disabled(mqttManager.connectionState != MQTTConnectionState.connected)
            
            // Publicação
            TextField("Mensagem a ser enviada", text: $inputMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Publicar") {
                mqttManager.publish(topic: inputTopic, message: inputMessage)
            }
            .disabled(mqttManager.connectionState != .connected)
            
            // Mensagem recebida
            Text("Última mensagem recebida: \(mqttManager.receivedMessage)")
                .padding()
             
            // Conectar/Desconectar
            Button(mqttManager.connectionState == .connected ? "Desconectar" : "Conectar") {
                if mqttManager.connectionState == .connected {
                    mqttManager.disconnect()
                } else {
                    mqttManager.initializeMQTT(
                        host: "broker.emqx.io",
                        identifier: UUID().uuidString,
                        username: "cauanzin",
                        password: "testando123"
                    )
                    mqttManager.connect()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
    
    private var connectionStatusText: String {
        switch mqttManager.connectionState {
        case .disconnected: return "Desconectado"
        case .connecting: return "Conectando..."
        case .connected: return "Conectado"
        case .error(let message): return "Erro: \(message)"
        }
    }
    
    private var connectionStatusColor: Color {
        switch mqttManager.connectionState {
        case .disconnected: return .red
        case .connecting: return .orange
        case .connected: return .green
        case .error: return .red
        }
    }
}

//struct ContentView: View {
//    @StateObject private var mqttManager = MQTTManager()
//    @State private var leftCurtain: Double = 50
//    @State private var rightCurtain: Double = 50
//    
//    var body: some View {
//        VStack {
//            Text("Controle das Cortinas")
//                .font(.title)
//            
//            Slider(value: $leftCurtain, in: 0...100, step: 1, onEditingChanged: { _ in
//                mqttManager.publish(topic: "curtains/left", message: "\(Int(leftCurtain))")
//            })
//            Text("Cortina Esquerda: \(Int(leftCurtain))%")
//            
//            Slider(value: $rightCurtain, in: 0...100, step: 1, onEditingChanged: { _ in
//                mqttManager.publish(topic: "curtains/right", message: "\(Int(rightCurtain))")
//            })
//            Text("Cortina Direita: \(Int(rightCurtain))%")
//        }
//        .padding()
//    }
//}

#Preview {
    ContentView()
}

//@State var brokerAddress: String = ""
//@EnvironmentObject private var mqttManager: MQTTManager
//var body: some View {
//VStack {
//ConnectionStatusBar (message:
//mqttManager.connectionStateMessage(), isConnected:
//mqttManager. isConnected ( ))
//MQTTTextField(placeHolderMessage: "Broker Address",
//isDisabled:
//mqttManager.currentAppState.appConnectionState !=
//• disconnected, message: $brokerAddress)
//• padding (EdgeInsets (top:
//0.0, leading: 7.0, bottom:
//0.0, trailing: 7.0))
//HStack(spacing: 15) {
//setUpConnectButton ( )
//setUpDisconnectButton ( )
//}
//.padding()
//Spacer ( )
//}
//.background (Color gray)
//.navigationBarTitleDisplayMode(inline)
//}

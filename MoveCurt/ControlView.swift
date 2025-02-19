//
//  CurtainView.swift
//  Basics
//
//  Created by Cauan Lopes Galdino on 07/01/25.
//

import SwiftUI

struct ControlView: View {
    
    @StateObject var vm = CurtainViewModel()
    @StateObject private var mqttManager = MQTTManager()
    
    var body: some View {
        ZStack{
            Color(.fundoAzulEscuro1)
                .saturation(0.8)
                .ignoresSafeArea()
            GeometryReader { geo in
                VStack {
                    Text("MoveCurt")
                        .fontDesign(.rounded)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .padding(.top)
                        .frame(minHeight: geo.size.height * 0.1)
                        
                    
                    Spacer()
                    
                    CurtainView(sWidth: geo.size.width, sHeight: geo.size.height)
                    
                    HStack {
                        
                        Slider(value: $vm.leftTargetOpening, in: 0...100, step: 1){
                            Text("Left")
                        } onEditingChanged: { isEditing in
                            if !isEditing {
                                vm.animateOpening(to: vm.leftTargetOpening, toLeft: true, moveSlider: false)
                            }
                        }
                        .disabled(vm.leftIsMoving)
                        .scaleEffect(x: -1, y: 1) // Espelha horizontalmente
                        .padding([.vertical, .leading])
                        .padding(.trailing, 2)
                        
                        
                        Slider(value: $vm.rightTargetOpening, in: 0...100, step: 1){
                            Text("Right")
                        } onEditingChanged: { isEditing in
                            if !isEditing {
                                vm.animateOpening(to: vm.rightTargetOpening, toLeft: false, moveSlider: false)
                            }
                        }
                        .disabled(vm.rightIsMoving)
                        .padding([.vertical, .trailing])
                        .padding(.leading, 2)
                    }
                    .tint(.azulClaro)
                    .frame(width: geo.size.width * 0.9)
                    Spacer()
                    HStack{
                        Button("Open", systemImage: "curtains.open") {
                            vm.animateOpening(to: 100, toLeft: true, moveSlider: true)
                            vm.animateOpening(to: 100, toLeft: false, moveSlider: true)
                        }
                        .labelStyle(.iconOnly)
                        .font(.title)
                        .padding(16)
                        .background {
                            Color.cinzaClaro.clipShape(Circle()).shadow(radius: 10, x: 0, y: 4)
                        }
                        .disabled(vm.leftIsMoving || vm.rightIsMoving)
                        Spacer()
                        Button("Pause", systemImage: (vm.leftIsMoving || vm.rightIsMoving) ? "pause.fill" : "play.fill") {
                            if !vm.leftIsMoving && !vm.rightIsMoving {
                                if vm.isOpening {
                                    vm.animateOpening(to: 100, toLeft: true, moveSlider: true)
                                    vm.animateOpening(to: 100, toLeft: false, moveSlider: true)
                                } else {
                                    vm.animateOpening(to: 0, toLeft: true, moveSlider: true)
                                    vm.animateOpening(to: 0, toLeft: false, moveSlider: true)
                                }
                            } else {
                                vm.leftIsMoving = false
                                vm.rightIsMoving = false
                            }
                        }
                        .labelStyle(.iconOnly)
                        .font(.system(size: 56))
                        .padding(24)
                        .background {
                            Color.cinzaClaro.clipShape(Circle()).shadow(radius: 10, x: 0, y: 4)
                        }
                        Spacer()
                        Button("Close", systemImage: "curtains.closed") {
                            vm.animateOpening(to: 0, toLeft: true, moveSlider: true)
                            vm.animateOpening(to: 0, toLeft: false, moveSlider: true)
                            
                        }
                        .labelStyle(.iconOnly)
                        .font(.title)
                        .padding(16)
                        .background {
                            Color.cinzaClaro.clipShape(Circle()).shadow(radius: 10, y: 4)
                        }
                        .disabled(vm.leftIsMoving || vm.rightIsMoving)
                    }
                    .foregroundStyle(.fundoAzulEscuro1)
                    .frame(width: geo.size.width*0.75)
                    .padding(.bottom)
                    
                }
                .position(x: geo.size.width/2, y: geo.size.height/2)
            }
        }
        .environmentObject(vm)
        .onChange(of: mqttManager.receivedMessage){
            let message = mqttManager.receivedMessage
            if message == "100" {
                vm.animateOpening(to: 100, toLeft: true, moveSlider: true)
                vm.animateOpening(to: 100, toLeft: false, moveSlider: true)
            } else if message == "0" {
                vm.animateOpening(to: 0, toLeft: true, moveSlider: true)
                vm.animateOpening(to: 0, toLeft: false, moveSlider: true)
            }
            
        }
        .onAppear {
            mqttManager.initializeMQTT(
                host: "broker.emqx.io",
                identifier: UUID().uuidString,
                username: "test",
                password: "testando"
            )
            mqttManager.connect()
            print(mqttManager.subscribedTopic)
//            mqttManager.subscribe(topic: mqttManager.subscribedTopic)
            
        }
        .onDisappear {
            mqttManager.disconnect()
        }
    }
}

#Preview {
    ControlView()
        .environmentObject(CurtainViewModel())
}

# MoveCurt

MoveCurt is an academic project developed during the **MCMP course at IFCE (2024.2)**.  
The goal of the project is to explore the integration between software and embedded devices through a simple curtain automation system.

The solution uses an ESP32 to control a motor and communicates with a client application using message-based communication.

---

## How it Works

- The ESP32 connects to a Wi-Fi network
- A connection is established with an MQTT broker
- The device subscribes to control topics and listens for commands
- Control messages trigger motor movement (open, close, pause)
- The device publishes its current state for synchronization

The client application sends commands and displays the current curtain status.

---

## Main Concepts

- Embedded device control using **ESP32**
- Message-based communication with **MQTT**
- Asynchronous publish/subscribe model
- State synchronization between physical device and software
- Versioned development using Git

---

## Technologies

- ESP32  
- MQTT  
- Wi-Fi and Bluetooth  
- Swift / SwiftUI  

---

## Academic Context

This project was developed as part of an undergraduate course at the **Instituto Federal do Ceará (IFCE)** and focuses on learning automation, communication between systems, and embedded software integration.

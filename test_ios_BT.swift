import SwiftUI
import CoreBluetooth

struct BluetoothDevice: Identifiable {
    let id = UUID()
    let name: String?
    let rssi: Int?
}

class BluetoothManager: NSObject, CBCentralManagerDelegate {
    var devices = [BluetoothDevice]()
    var manager: CBCentralManager!

    override init() {
        super.init()

        manager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            manager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth not available.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = peripheral.name
        let rssi = RSSI.intValue

        let device = BluetoothDevice(name: name, rssi: rssi)
        devices.append(device)
    }
}

struct ContentView: View {
    @StateObject var bluetoothManager = BluetoothManager()

    var body: some View {
        NavigationView {
            List(bluetoothManager.devices) { device in
                VStack(alignment: .leading) {
                    Text(device.name ?? "Unknown device")
                    Text("RSSI: \(device.rssi ?? 0) dBm")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Bluetooth Devices")
        }
    }
}

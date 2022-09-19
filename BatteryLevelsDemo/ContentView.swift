import SwiftUI
import WidgetKit

struct ContentView: View {
    @StateObject private var batteryVM = BatteryViewModel()

    var body: some View {
        VStack {
            Text("Battery Level").font(.largeTitle)
            Text("charge is \(batteryVM.level)%")
            Text("state is \(batteryVM.description)")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

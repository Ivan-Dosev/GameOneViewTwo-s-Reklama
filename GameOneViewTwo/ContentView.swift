//
//  ContentView.swift
//  GameOneViewTwo
//
//  Created by Ivan Dimitrov on 29.09.20.
//

import SwiftUI
import CoreData
import UserNotifications

struct ContentView: View {
    
    @EnvironmentObject var timeOnOff : TimeOnOff
   
  
    var body: some View {
//                           CoreDataView()
//                           ContView()
//                             FirstView()
        FirstNewView()
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
                print("Moving to the background")
                // Вика нотификацията като излезеш от приложението след 5 секунди
                createNotification()
                let toDay = Date()
                self.timeOnOff.isNotification = true
                let diffComponents = Calendar.current.dateComponents([.second, .minute], from: toDay)
                let sec = diffComponents.second
                let min = diffComponents.minute
                print("...\(Int(sec!) + (Int(min!) * 60))")
                
                timeOnOff.offApp = Int(sec!) + (Int(min!) * 60)
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
                print("Moving to App")
                let toDay = Date()
                self.timeOnOff.isNotification = false
                let diffComponents = Calendar.current.dateComponents([.second, .minute], from: toDay)
                let sec = diffComponents.second
                let min = diffComponents.minute
                print("...\(Int(sec!) + (Int(min!) * 60))")
                
                timeOnOff.onApp = Int(sec!) + (Int(min!) * 60)
                
                print("\(timeOnOff.onApp - timeOnOff.offApp)")
                
                if timeOnOff.onApp - timeOnOff.offApp > 10 {
                    timeOnOff.start = 0
                    timeOnOff.pauseTimer()
                    print("Out from App")
                }

            })
            .onAppear() {
                // Иска разрешение да изпраща нотификации като зареди ContentView
                notificationPermission()
                //
            }
//        ProbaView()
    }
    func notificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func createNotification () {
        let content = UNMutableNotificationContent()
        content.title = "Go back to the app"
        content.subtitle = "You will lose your points in 10 sec"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()
        Text("alo")
    }
}
/*
 let diffComponents = Calendar.current.dateComponents([.second, .minute], from: toDay)
 let sec = diffComponents.second
 let min = diffComponents.minute
 let s = Int(sec!) + (Int(min!) * 60)
 */

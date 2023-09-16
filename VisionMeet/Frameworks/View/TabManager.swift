//
//  TabManager.swift
//  VisionMeet
//
//  Created by Ha Changjin on 9/17/23.
//

import SwiftUI

struct TabManager: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("홈")
                }
                .tag(0)
            
            DataManagementView()
                .tabItem{
                    Image(systemName: "lock.doc.fill")
                    Text("데이터 관리")
                }
                .tag(1)
            
            SettingsView()
                .tabItem{
                    Image(systemName: "gear")
                    Text("설정")
                }
                .tag(2)
        }.font(.headline)
    }
}

#Preview {
    TabManager()
}

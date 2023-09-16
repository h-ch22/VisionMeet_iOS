//
//  SplashView.swift
//  VisionMeet
//
//  Created by Ha Changjin on 9/17/23.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack{
            Color.backgroundGradient.edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                
                Image("ic_appstore")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                
                Text("VisionMeet")
                    .font(.title2)
                    .foregroundStyle(Color.txt)
                    .fontWeight(.semibold)
                
                Spacer()
                
                ProgressView()
            }
        }

    }
}

#Preview {
    SplashView()
}

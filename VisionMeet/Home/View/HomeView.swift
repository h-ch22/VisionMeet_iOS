//
//  HomeView.swift
//  VisionMeet
//
//  Created by Ha Changjin on 9/17/23.
//

import SwiftUI

struct HomeView: View {
    @State private var showNewSessionView = false
    @State private var sessions = [String]()
    
    private let userDefaults = UserDefaults.standard
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundGradient.edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        Text("안녕하세요.")
                            .foregroundStyle(Color.txt)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }

                    Spacer().frame(height: 20)
                    
                    ScrollView(.horizontal){
                        LazyHStack{
                            ForEach(sessions, id:\.self){session in
                                VStack(alignment: .leading){
                                    Image(systemName: "arkit")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.txt)
                                    
                                    Text(session)
                                        .foregroundStyle(Color.txt)
                                }.padding(15)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
                            }
                        }
                    }.frame(height: 100)
                    
                    Spacer()
                    
                }.padding(20)
                    .sheet(isPresented: $showNewSessionView, content: {
                        CreateARSessionView()
                    })
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing, content: {
                            Button(action: {
                                showNewSessionView = true
                            }){
                                Image(systemName: "plus")
                            }
                        })
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear{
                        sessions.removeAll()
                        let keys = userDefaults.dictionaryRepresentation().keys
                        
                        for key in keys{
                            if key.contains("session_"){
                                sessions.append(key)
                            }
                        }
                    }
            }
        }

    }
}

#Preview {
    HomeView()
}

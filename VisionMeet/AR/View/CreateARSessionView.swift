//
//  CreateARSessionView.swift
//  VisionMeet
//
//  Created by Ha Changjin on 9/17/23.
//

import SwiftUI
import PhotosUI

struct CreateARSessionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var sessionName = ""
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedFiles = [URL]()
    @State private var selectedImages = [Data]()
    @State private var showFilePicker = false
    @State private var showDuplicatedAlert = false
    @State private var showProgress = false
    
    private let userDefaults = UserDefaults.standard
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        Text("새 AR 세션 생성하기")
                            .foregroundStyle(Color.txt)
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    TextField("세션 이름", text: $sessionName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Text("대상 이미지")
                            .foregroundStyle(Color.txt)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        PhotosPicker(selection: $selectedItems,
                                     matching: .images){
                            Image(systemName: "plus")
                        }
                    }
                    
                    Spacer().frame(height: 10)
                    
                    if selectedImages.isEmpty{
                        Text("대상 이미지를 불러오십시오.")
                            .foregroundStyle(Color.gray)
                    } else{
                        ScrollView(.horizontal){
                            LazyHStack{
                                ForEach(selectedImages, id: \.self){ item in
                                    Image(uiImage: UIImage(data: item)!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                }
                            }
                        }.frame(height: 150)
                    }
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Text("화체 데이터")
                            .foregroundStyle(Color.txt)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {
                            showFilePicker = true
                        }){
                            Image(systemName: "plus")
                        }
                    }
                    
                    if selectedFiles.isEmpty{
                        Spacer().frame(height: 10)

                        Text("화체 데이터를 불러오십시오.")
                            .foregroundStyle(Color.gray)
                    } else{
                        ScrollView(.horizontal){
                            LazyHStack{
                                ForEach(selectedFiles, id: \.self){ file in
                                    VStack(alignment: .leading){
                                        Image(systemName: "doc.text.fill")
                                            .foregroundStyle(Color.txt)
                                        
                                        Text(file.lastPathComponent)
                                            .foregroundStyle(Color.txt)
                                    }.padding(15)
                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
                                }
                            }.frame(height: 150)
                        }
                    }
                    
                    Spacer()
                }.padding(20)
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading, content: {
                            Button("닫기"){
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        })
                        
                        ToolbarItem(placement: .topBarTrailing, content: {
                            if showProgress{
                                ProgressView()
                            } else{
                                Button("완료"){
                                    showProgress = true
                                    let saveDict = [
                                        "images": selectedImages,
                                        "files": selectedFiles
                                    ] as [String : Any]
                                    
                                    if userDefaults.object(forKey: "session_\(sessionName)") != nil{
                                        showDuplicatedAlert = true
                                    } else{
                                        userDefaults.set(saveDict, forKey: "session_\(sessionName)")
                                    }
                                    
                                    showProgress = false
                                }
                            }
                        })
                    }
                    .onChange(of: selectedItems){ _ in
                        Task{
                            selectedImages.removeAll()
                            
                            for item in selectedItems{
                                if let data = try? await item.loadTransferable(type: Data.self){
                                    selectedImages.append(data)
                                }
                            }
                        }
                    }
                    .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.text], allowsMultipleSelection: true, onCompletion: { result in
                        do{
                            let fileURL = try result.get()
                            
                            for url in fileURL{
                                let name = url.lastPathComponent
                                let exts = name.components(separatedBy: ".")
                                
                                if exts[exts.count-1] == "txt"{
                                    selectedFiles.append(url)
                                }
                            }

                        } catch{
                            print("Error reading file: \(error.localizedDescription)")
                        }
                    })
                    .alert(isPresented: $showDuplicatedAlert, content: {
                        return Alert(title: Text("중복된 세션"), message: Text("동일한 이름의 세션이 이미 존재합니다."), dismissButton: .default(Text("확인")))
                    })
            }
        }
    }
}

#Preview {
    CreateARSessionView()
}

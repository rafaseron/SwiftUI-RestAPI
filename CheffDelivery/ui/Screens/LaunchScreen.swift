//
//  LaunchScreen.swift
//  CheffDelivery
//
//  Created by Rafael Seron on 17/05/24.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    @State private var buttonOffset: CGSize = .zero
    @State private var navigateToHome: Bool = false
    
    //Validar para que o buttonOffset nao seja atualizado caso o Usuario arraste o Botao para o lado Esquerdo
    func buttonOffsetValidador () -> CGSize{
        if buttonOffset.width > 0{
            return buttonOffset
        }else{
            return .zero
        }
    }
    
    let buttonHeight: CGFloat = 80
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Circle()
                    .foregroundStyle(.colorRed)
                    .frame(width: isAnimating ? 200 : 0)
                    .position(x: isAnimating ? 50 : -50, y: isAnimating ? 100 : -100)
                    .blur(radius: 60)
                    .opacity(isAnimating ? 0.5 : 0)
                
                Circle()
                    .foregroundStyle(.colorRedDark)
                    .frame(width: isAnimating ? 200 : 0)
                    .position(x: isAnimating ? geometry.size.width-50 : geometry.size.width+50,
                              y: isAnimating ? geometry.size.height-50 : geometry.size.height+50)
                    .blur(radius: 60)
                    .opacity(isAnimating ? 0.5 : 0)
                
                VStack{
                    Text("Cheff Delivery")
                        .font(.system(size: 40))
                        .fontWeight(.heavy)
                        .foregroundStyle(.colorRed)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : -40)
                    
                    Text("Peça as suas comidas no conforto da sua casa")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black .opacity(0.7))
                        .offset(y: isAnimating ? 0 : -40)
                    
                    Image("launchScreenBurguer")
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 60)
                        .padding(isAnimating ? 32 : 92)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(x: imageOffset.width, y: imageOffset.height)
                        .gesture(
                            DragGesture()
                            .onChanged({ gestureChanged in
                                withAnimation(.easeInOut(duration: 0.5)){
                                    imageOffset = gestureChanged.translation
                                }
                            })
                            .onEnded({ gestureEnded in
                                withAnimation(.easeInOut(duration: 0.5)){
                                    imageOffset = .zero
                                }
                            })
                        
                        )
                    
                    ZStack(alignment: .center){
                        Capsule()
                            .fill(Color(.colorRed).opacity(0.2))
                            .frame(width: geometry.size.width-60 ,height: buttonHeight-20)
                        
                        Capsule()
                            .fill(Color(.colorRed).opacity(0.2))
                            .frame(width: geometry.size.width-40 ,height: buttonHeight)
                        
                        Text("Descubra mais")
                            .bold()
                            .font(.title2)
                            .foregroundStyle(.colorRedDark)
                            .offset(x: 20)
                        
                        HStack{
                            Capsule()
                                .fill(Color(.colorRed))
                                .frame(width: buttonOffset.width+buttonHeight, height: buttonHeight)
                            
                            Spacer()
                            
                        }.padding()
                        
                        HStack{
                            ZStack{
                                Circle()
                                    .fill(Color(.colorRed))
                                    .frame(height: buttonHeight)
                                
                                Circle()
                                    .fill(Color(.colorRedDark))
                                    .frame(height: buttonHeight-20)
                                
                                Image(systemName: "chevron.right.2")
                                    .font(.system(size: 24))
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                            
                            Spacer()
                        }.padding()
                            .offset(x: buttonOffsetValidador().width)
                            .gesture(
                                DragGesture()
                                    .onChanged({ gestureChanged in
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            //Validar para que o buttonOffset nao seja atualizado caso passe do Tamanho do Slider do Botao
                                            if gestureChanged.translation.width <= geometry.size.width-40-70{
                                                buttonOffset = gestureChanged.translation
                                            }
                                            
                                        }
                                    })
                                    .onEnded({ gestureEnded in
                                        
                                        if buttonOffset.width > (geometry.size.width-60)/2{
                                            navigateToHome = true
                                        } else {
                                            withAnimation(.easeInOut(duration: 0.2)){
                                                buttonOffset = .zero
                                            }
                                        }
                                    })
                            
                            )
                        
                    }.offset(y: isAnimating ? 0 : 100)
                        .opacity(isAnimating ? 1 : 0.5)
                    
                    
                }.onAppear{
                    withAnimation(.easeInOut(duration: 1.5)){
                        isAnimating = true
                    }
            }
            }
        }.fullScreenCover(isPresented: $navigateToHome, content: {
            HomeScreen()
        })
    }
}

#Preview {
    LaunchScreen()
}

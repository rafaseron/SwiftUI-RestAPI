//
//  ContentView.swift
//  CheffDelivery
//
//  Created by Rafael Seron on 23/04/24.
//

import SwiftUI

struct HomeScreen: View {
    
    // MARK: - Atributos
    
    private let service = StoresService()
    @State private var listStores: [Loja] = []
    
    // MARK: - View
    
    var body: some View {
        NavigationView{
            VStack(spacing: 30) {
                NavigationBar()
                    .padding(.horizontal, 15)
                
                ScrollView(.vertical, showsIndicators: false){
                    LazyVStack(spacing: 20){
                        CategoriasGridView(categoriaList: listaCategorias)
                            .padding(.top, 50)
                        CarouselBanners(bannerList: imageList)
                        
                        StoresList(shopsList: listaDeLojas)
                        
                    }.offset(y: -70)
                    //.frame(height: 350)
                }
                
            }
        }.navigationBarBackButtonHidden()
            .onAppear{
                //O escopo Task tem a mesma funcao que o escopo de Couroutine em Kotlin
                //Alem de serem rodadas em Scopo de 'Coroutines', também devem ter o await na frente
                Task{
                    await searchForStores()
                }
            }
    }
    
    // MARK: - Métodos da HomeScreen (escopo HomeScreen View aqui)
    
    func searchForStores() async {
        
        //Como service.getAllStores() pode retornar .sucess ou .failure, precisamos executar com o 'try', já que não sabemos qual o retorno que virá
        //o 'try', por sua vez, pede o uso da estrutura 'do-catch'
        //Usamos um 'switch case' para verificar sucess ou failure
        
        do{
            let result = try await service.getAllStores()
            switch(result){
            case .success(let stores):
                self.listStores = stores
            case .failure(let error):
                print(error.localizedDescription)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
}

#Preview {
    HomeScreen()
}

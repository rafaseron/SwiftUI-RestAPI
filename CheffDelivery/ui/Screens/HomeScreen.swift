//
//  ContentView.swift
//  CheffDelivery
//
//  Created by Rafael Seron on 23/04/24.
//

import SwiftUI

struct HomeScreen: View {
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
                getAllStores()
            }
    }
    
    // MARK: - Methods (dentro do escopo struct HomeScreen
    func getAllStores(){
        guard let url = URL(string: "https://private-501c8-rafaseron.apiary-mock.com/stores") else { return }
        
        //colocado procedimento de requisicao dentro de uma variavel 'task' para que tu possa dar .resume() posteriormente - é OBRIGATÓRIO, se não ele NÃO FAZ a Requisicao
        //.shared de URLSession garante um Singleton
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            
            // Verifica se tiver Erro. Caso tenha, nem executa guardar o data e a serializacao JSON
            if error != nil {
                guard let errorMessage = error?.localizedDescription else { return }
                print(errorMessage)
                
            } else {
                guard let storesData = data else { return }
                
                // o .jsonObject é uma funcao que pode falhar 'throws -> Any' - entao temos que usar 'try'
                // o try por sua vez nos obriga a usar a estrutura 'do' 'catch'
                do {
                    // '[String:Any]]' -> representa um Dicionário de String,Any (chave-valor)
                    // [ [String:Any] ] -> representa uma Lista de Dicionários
                    // Traduzindo em Kotlin -> '[ [String:Any] ]' Representa uma List<Map<String,Any>>
                    
                    let json = try JSONSerialization.jsonObject(with: storesData) as? [[String: Any]]
                    guard let response = json else {return}
                    print(response)
                    
                } catch{
                    
                }
            }
            
        }
        
        task.resume()
        
    }
    
    
}

#Preview {
    HomeScreen()
}

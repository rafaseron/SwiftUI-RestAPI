//
//  StoresService.swift
//  CheffDelivery
//
//  Created by Rafael Seron on 29/05/24.
//

import Foundation

struct StoresService{
    
    enum RequestError: Error{
        case invalidUrl
        case errorRequest(error: String)
    }
    
    func getAllStores() async throws -> Result<[Loja], RequestError>{
        guard let url = URL(string: "https://private-501c8-rafaseron.apiary-mock.com/stores") else { return.failure(.invalidUrl) }
        
        // Vamos criar um objeto da classe URLRequest. Esse objeto tem a url acima definida no parametro.
        // Com essa property já criada, podemos mudar seu httpMethod para 'GET', etc ..
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Agora vamos usar um método de URLSession que aceite uma URLRequest como argumento. Lembrando de usar 'shared' para garantir Singleton
        let (data, response) = try await URLSession.shared.data(for: request)
        let listStores = try JSONDecoder().decode([Loja].self, from: data)
        
        return.success(listStores)
    }
    
}


// CÓDIGO ANTERIOR DO REQUEST USANDO URLSESSION


//func getAllStores() async{
//    guard let url = URL(string: "https://private-501c8-rafaseron.apiary-mock.com/stores") else { return }
//    
//    //colocado procedimento de requisicao dentro de uma variavel 'task' para que tu possa dar .resume() posteriormente - é OBRIGATÓRIO, se não ele NÃO FAZ a Requisicao
//    //.shared de URLSession garante um Singleton
//    let task = URLSession.shared.dataTask(with: url){ data, response, error in
//        
//        // Verifica se tiver Erro. Caso tenha, nem executa guardar o data e a serializacao JSON
//        if error != nil {
//            guard let errorMessage = error?.localizedDescription else { return }
//            print(errorMessage)
//            
//        } else {
//            //Como data pode ser nula, precisamos 'desembrulhar'
//            guard let storesData = data else { return }
//            
//            //tentar decodificar o JSON para um Array de Lojas -> .self significa que é para converter naquele type, e não em uma instancia
//            //como essa decodificacao pode falhar, o try pode ser nulo -> 'try?'. Essas falhas ocorrem por divergencia entre o estilo de escrita das 'variaveis' do JSON (com _) vs. Padrao CamelCase no SWift/Kotlin. Para corrigir isso -> fazer CodingKeys em todas as structs de Molde necessárias (aqui no caso, Loja e Product)
//            let listLojas = try? JSONDecoder().decode([Loja].self, from: storesData)
//            
//             //-> Para testar a decodificacao <-
//            guard let testeListLojas = listLojas else { return }
//            print(testeListLojas)
//        }
//        
//    }
//    
//    task.resume()
//    
//}

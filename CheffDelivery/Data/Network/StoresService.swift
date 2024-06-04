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
        let getResult = try await URLSession.shared.data(for: request)
        let data = getResult.0
        let response = getResult.1
        print(response.self)
        let listStores = try JSONDecoder().decode([Loja].self, from: data)
        
        return.success(listStores)
    }
    
    func postAOrder(produto: Product) async throws -> Result<[String: Any]?, RequestError> {
        guard let urlPost = URL(string: "https://private-501c8-rafaseron.apiary-mock.com/stores") else { return.failure(.invalidUrl)}
        
        let encondedData = try JSONEncoder().encode(produto)
        
        var postRequest = URLRequest(url: urlPost)
        postRequest.httpMethod = "POST"
        postRequest.httpBody = encondedData
        
       let result = try await URLSession.shared.data(for: postRequest)
        let data = result.0
        let urlResponse = result.1
        
        // Ao invés de fazer assim:
        //let dataDecodedTest = try JSONDecoder().decode([String: Any].self, from: data)
        
        // É feito assim:
        let dataDecoded = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        /* Isso porque o 'Any' não entra em conformidade com o Protocolo Decodable. JSONSerialization é o método ANTIGO de como era feito 'Encode' e 'Decode' em Swift.
           JSONSerialization é a maneira antiga de lidar com JSON em Swift. */
        
        return.success(dataDecoded)
        
    }
    
}


// CÓDIGO ANTERIOR DO REQUEST DE GET USANDO URLSESSION


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

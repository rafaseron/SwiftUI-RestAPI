//
//  Categoria.swift
//  CheffDelivery
//
//  Created by Rafael Seron on 25/04/24.
//

import Foundation

//Implementando o protocolo 'Identifiable', ganha propriedades relacionadas a ID de elementos, como iteracao nativa em ForEach, ID sempre unico como UUID, etc. Ler documentacao se precisar
struct Categoria: Identifiable{
    let id: Int
    let label: String
    let image: String
}

struct Loja: Identifiable, Decodable{
    let id: Int
    let label: String
    let logoImage: String
    let headerImage: String
    let address: String
    let stars: Int
    let products: [Product]
    
    private enum CodingKeys: String, CodingKey{
        case id, stars, products
        case label = "name"
        case logoImage = "logo_image"
        case headerImage = "header_image"
        case address = "location"
    }
    
}

struct Product: Identifiable, Decodable, Encodable{ //Poderia ser só o Protocolo 'Codable' -> ele é 'Decodable + Encodable' juntos
    let id: Int
    let nome: String
    let descricao: String
    let preco: Double
    let image: String
    
    private enum CodingKeys: String, CodingKey{
        case id, image
        case nome = "name"
        case descricao = "description"
        case preco = "price"
        
    }
}

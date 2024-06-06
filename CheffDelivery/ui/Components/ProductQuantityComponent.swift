//
//  ProductQuantityComponent.swift
//  CheffDelivery
//
//  Created by Rafael Seron on 11/05/24.
//

import SwiftUI

struct ProductQuantityComponent: View {
    @Binding var produtoQuantidade: Int
    
    // MARK: - Como Elevar funcoes em SwiftUI - Código didático
    //var onButtonClick: (Product) -> Void = { _ in } //Elevando Argumentos junto
    //var onActionClick: () -> Void = {}  //Sem Elevar Argumentos
    
    //var produto: Product = Product(id: 200, nome: "String", descricao: "String", preco: 2.99, image: "String")
    var body: some View {
        VStack{
            Text("Quantidade")
                .font(.title2)
                .bold()
            HStack{
                Button(action: {
                    if produtoQuantidade>1{
                        produtoQuantidade -= 1
                    }
                    //onButtonClick(produto)
                    //onActionClick()
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.colorRed)
                })
                
                Text("\(produtoQuantidade)")
                    .bold()
                    .font(.title2)
                
                Button(action: {
                    produtoQuantidade += 1
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.colorRed)
                })
            }
        }
    }
}

#Preview {
    ProductQuantityComponent(produtoQuantidade: .constant(1))
    //precisamos usar o .constant(value: ) por causa do Binding. Não da pra passar o valor literal no Preview
}

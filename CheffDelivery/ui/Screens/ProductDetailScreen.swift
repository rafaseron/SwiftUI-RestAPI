//
//  ProductDetailScreen.swift
//  CheffDelivery
//
//  Created by Rafael Seron on 09/05/24.
//

import SwiftUI

struct ProductDetailScreen: View {
    let produto: Product
    @State var produtoQuantidade: Int = 1
    
    @State var showAlert: Bool = false
    @State var serviceMessage: String?
    func showMessage() -> String{
        guard let newMessage = serviceMessage else { return "A" }
        return newMessage
    }
    
    var service = StoresService()
    
    var body: some View {
        ScrollView{
            Image(produto.image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                .frame(height: 280)
                .shadow(radius: 20)
            
            VStack(alignment: .leading, spacing: 8){
                Text(produto.nome)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                Text(produto.descricao)
                    .font(.body)
                Text("R$ \(produto.preco.toPriceFormat())")
                    .bold()
            }.offset(y: 20)
            
            VStack(spacing: 8){
                
                //Temo uma funcao onButtonClick Elevada no 'ProductQuantityComponent' para fins didáticos
                ProductQuantityComponent(produtoQuantidade: $produtoQuantidade/*, onButtonClick: {
                    product in
                    
                }, onActionClick: {}*/)
                //Precisa passar usando $ porque estamos passando uma varivel de @State para um Componente que espera uma @Binding
                
                /* A variavel de @State é a fonte unica da verdade.
                 Para passar seu Valor (e atualizacoes dele) para o Componente que espera receber um @Binding, precisa passar o valor usando '$'.
                 Dessa forma, o Componente Secundário consegue 'acessar e modificar' o 'Valor' da variável original */
                
                //Text para fins didáticos. É para ver a ligacao das variaveis que foi feita através do Binding
                //Text("\(produtoQuantidade)")
                
                Spacer()
                
                Button(action: { Task{
                    await onOrderClick()
                } }, label: {
                    HStack{
                        Image(systemName: "cart")
                            .foregroundStyle(.white)
                        Text("Fazer pedido agora")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }.foregroundStyle(.colorRed)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color("ColorRed"))
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .shadow(color: Color("ColorRed").opacity(0.5), radius: 10, x: 6, y:8)
                }).offset(y: 60)
                    .alert(isPresented: $showAlert){
                        Alert(title: Text(showMessage()), message: Text("Agora é só aguardar ..."), dismissButton: .default(Text("Esperando ansionamente")))
                    }
                
            }.offset(y: 120)
            
        }.navigationBarBackButtonHidden()
    }
    
    // MARK: - Escopo da Struct - depois do Body
    
    // A funcao service.postAOrder pode retornar uma throws, o que obrigaria 'onOrderClick' a retornar uma throws também
    // Como nao queremos retornar throws, precisamos usar o Escopo 'do-catch'
    func onOrderClick() async{
        do{
            let result = try await service.postAOrder(produto: produto)
            switch result{
                
            case .success(let message):
                print("\(String(describing: message))") //apenas para depuracao
                
                guard let valuesArray = message?.values else { return }
                // Ao pegar os values de um Dicionário, produzimos um 'array'
                
                // For para acessar o 'array de values' e conseguir mudar o valor de serviceMessage
                for values in valuesArray{
                    serviceMessage = (values as! String)
                }
                
                showAlert = true
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
}

#Preview {
    ProductDetailScreen(produto: Product(id: 21, nome: "Açaí Pequeno", descricao: "Açaí na tigela de 300ml com granola e banana", preco: 8.99, image: "small_acai"))
}

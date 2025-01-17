//
//  ContentView.swift
//  ShoppingList2
//
//  Created by Кирилл on 17.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [String] = []
    @State private var newItem: String = ""
    @State private var isAdding: Bool = false
    @State private var checkedItems: Set<String> = [] // Множество для отслеживания отмеченных элементов
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)){
                            isAdding = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                            .background(Circle().fill(Color.black)
                                .font(.caption))
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                List {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Button(action: {
                                toggleCheckedItem(item)
                            }) {
                                Image(systemName: checkedItems.contains(item) ? "checkmark.square.fill" : "square")
                                    .foregroundColor(.blue)
                            }
                            
                            
                            Text(item)
                                .strikethrough(checkedItems.contains(item), color: .black)
                        }
                        .transition(.move(edge: .top))
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            if isAdding {
                VStack(spacing: 0.5) {
                    Spacer()
                    
                    TextField("New item", text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Button("Добавить") {
                            withAnimation {
                                if !newItem.isEmpty {
                                    items.append(newItem)
                                    newItem = ""
                                    isAdding = false
                                }
                            }
                        }
                        .padding()
                        .foregroundColor(.black)
                        
                        Button("Отмена") {
                            withAnimation {
                                newItem = ""
                                isAdding = false
                            }
                        }
                        .padding()
                        .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .frame(width: 300, height: 130)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
            }
        }
    }
    
    // Функция для изменения состояния элемента (отметить/снять отметку)
    func toggleCheckedItem(_ item: String) {
        if checkedItems.contains(item) {
            checkedItems.remove(item)
            // Перемещаем элемент в начало списка
            items = items.filter { $0 != item } + [item]
        } else {
            checkedItems.insert(item)
            // Перемещаем элемент в конец списка
            items = items.filter { $0 != item } + [item]
        }
    }
}


#Preview {
    ContentView()
}

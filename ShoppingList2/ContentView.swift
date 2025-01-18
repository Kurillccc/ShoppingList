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
    @State private var selectedItem: String? = nil   // Для отслеживания элемента, который редактируется
    @State private var showOptions: Bool = false
    @State private var newText: String = ""         // Новый текст для редактирования
        
    
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
                                    .foregroundColor(.black)
                            }
                            
                            
                            Text(item)
                                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                                .background(Color.clear)
                                .cornerRadius(8)
                                .contentShape(Rectangle())
                                .strikethrough(checkedItems.contains(item), color: .black)
                                .onLongPressGesture {
                                    selectedItem = item
                                    newText = item
                                    showOptions = true
                                }

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
                        .textFieldStyle(PlainTextFieldStyle())
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
            
            if showOptions, let selectedItem = selectedItem {
                VStack(spacing: 20) {
                    TextField("Изменить текст", text: $newText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Button("Изменить") {
                            withAnimation {
                                if let index = items.firstIndex(of: selectedItem) {
                                    items[index] = newText
                                    resetOptions()
                                }
                            }
                        }
                        .padding()
                        
                        Button("Удалить") {
                            withAnimation {
                                items.removeAll { $0 == selectedItem }
                                resetOptions()
                            }
                        }
                        .padding()
                        
                        Button("Отмена") {
                            resetOptions()
                        }
                        .padding()
                    }
                }
                .frame(width: 300, height: 200)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
            }
        }
    }
        
    // Сброс состояния панели
    func resetOptions() {
        showOptions = false
        selectedItem = nil
        newText = ""
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

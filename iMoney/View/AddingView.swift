//
//  AddingView.swift
//  iMoneyPet
//
//  Created by Никита on 14.01.2023.
//

import SwiftUI

struct AddingView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.presentationMode) var presentationMode

    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    infoSection
                    categorySection
                    dateSection
                    addingSection
                }
                .navigationTitle(LocalizedStringKey("newSpend"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                viewModel.reset()
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                        .contentShape(Circle())
                        .contextMenu {
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                Label(LocalizedStringKey("leaveWithoutReset"), systemImage: "rectangle.portrait.and.arrow.forward")
                            }

                        }
                    }
                }
            }
            .onChange(of: viewModel.selectedCategory) { _ in
                hideKeyboard()
            }
            .onAppear {
                viewModel.selectedDate = Date()
            }
        }
    }
}

struct AddingView_Previews: PreviewProvider {
    static var previews: some View {
        AddingView()
            .environmentObject(ViewModel())
    }
}


extension AddingView {
    private enum FocusedField {
        case name
        case amount
    }
    private var infoSection: some View {
        Section(header: Text(LocalizedStringKey("information"))) {
            TextField(LocalizedStringKey("name"), text: $viewModel.spendingName)
                .submitLabel(.next)
                .focused($focusedField, equals: .name)
                .onSubmit {
                    focusedField = .amount
                }
            TextField(LocalizedStringKey("amount"), text: $viewModel.spendingAmount)
                .keyboardType(.numberPad)
                .textContentType(.shipmentTrackingNumber)
                .focused($focusedField, equals: .amount)
        }
    }
    private var categorySection: some View {
        Section(header: Text(LocalizedStringKey("category"))) {
            HStack {
                Text(LocalizedStringKey("category"))
                Spacer()
                Picker("", selection: $viewModel.selectedCategory) {
                    ForEach(Categories.allCases, id: \.self) { value in
                        Text(LocalizedStringKey(value.rawValue))
                    }
                }
                .pickerStyle(.menu)
            }
            HStack {
                Text(LocalizedStringKey("spendType"))
                Spacer()
                Picker("", selection: $viewModel.spendType) {
                    ForEach(SpendType.allCases, id: \.self) { value in
                        Text(LocalizedStringKey(value.rawValue))
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
    private var dateSection: some View {
        Section(header: Text(LocalizedStringKey("datentime"))) {
            DatePicker(LocalizedStringKey("datentime"), selection: $viewModel.selectedDate, in: ...Date())
        }
    }
    private var addingSection: some View {
        Section(header: Text(LocalizedStringKey("adding"))) {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.addingButton(context: managedObjContext) {
                    self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Label(LocalizedStringKey("add"), systemImage: "square.and.arrow.down.on.square")
                })
                .padding(30)
                Spacer()
            }
        }
    }
}

//
//  TodoModule.swift
//  VIPER Demo
//
//  Created by Kassim Mirza on 30/09/2025.
//

import SwiftUI

class TodoModule {
    static func build() -> TodoView {
        let viewModel = TodoViewObservable()
        let presenter = TodoPresenter()
        let interactor = TodoInteractor()
        let router = TodoRouter()
        let dataManager = TodoDataManager()
        
        // Wire up dependencies
        viewModel.presenter = presenter
        presenter.view = viewModel
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.dataManager = dataManager
        
        return TodoView(viewModel: viewModel)
    }
}

//
//  RickyMortyViewModel.swift
//  ExampleSnapkit
//
//  Created by mert can çifter on 1.11.2022.
//

import Foundation

protocol RickyMortyViewModelProtocol {
    var delegate: RickyMortyViewModelDelegate? { get set }
    func load()
}


enum RickyMortyViewModelOutput {
    case setLoading(Bool)
    case success([Result])
}

protocol RickyMortyViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: RickyMortyViewModelOutput)
}


final class RickyMortyViewModel: RickyMortyViewModelProtocol {
    
    var delegate: RickyMortyViewModelDelegate?
    var service: IRickyMortyService = RickyMortyService()
    
    func load() {
        notify(.setLoading(true))
        service.fetchAllData { (response) in
            self.notify(.setLoading(false))
            self.notify(.success(response ?? []))
        }
    }
    
    private func notify(_ output: RickyMortyViewModelOutput){
        delegate?.handleViewModelOutput(output)
    }
}

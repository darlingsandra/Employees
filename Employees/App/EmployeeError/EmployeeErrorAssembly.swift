//
//  EmployeeErrorAssembly.swift
//  Employees
//
//  Created by Александра Широкова on 10.08.2022.
//

import UIKit

final class EmployeeErrorAssembly {}

extension EmployeeErrorAssembly: Assemblying {
    
    func assembly(viewController: UIViewController, delegate: AnyObject?){
        guard let vc = viewController as? EmployeeErrorViewController,
            let delegate = delegate as? EmployeeListRouterDelegate  else { return }
        
        vc.modalPresentationStyle =  .overFullScreen
        
        let router = EmployeeErrorRouter()
        let presenter = EmployeeErrorPresenter(view: vc, router: router)
        
        router.delegate = delegate
        vc.presenter = presenter
    }
}

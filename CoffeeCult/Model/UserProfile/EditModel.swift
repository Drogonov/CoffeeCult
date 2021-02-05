//
//  EditModel.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import Foundation

protocol EditVCCellType: CustomStringConvertible {
    var cellType: [EditCellConfiguration] { get }
}

enum EditCellConfiguration {
    case editPhotoButton
    case editNameTF
    case actionButton
    case segmentedControl
    case textLabel
    
    init() {
        self = .editPhotoButton
    }
}

enum EditVCCompanySection: Int, CaseIterable, EditVCCellType {
    case CreateCompany
    case CreateCafe
    case AddBarista
    
    var description: String {
        switch self {
        case .CreateCompany: return "Создать компанию"
        case .CreateCafe: return "Добавить кафе"
        case .AddBarista: return "Добавить бариста"
        }
    }
    
    var cellArray: [String] {
        switch self {
        case .CreateCompany: return ["Добавить фото", "Название компании", "Создать компанию"]
        case .CreateCafe: return ["Название кафе", "Создать кафе"]
        case .AddBarista: return ["Отправленные приглашения"]
        }
    }
    
    var cellType: [EditCellConfiguration] {
        switch self {
        case .CreateCompany: return [.editPhotoButton, .editNameTF, .actionButton]
        case .CreateCafe: return [.editNameTF,.actionButton]
        case .AddBarista: return [.textLabel]
        }
    }
}

enum EditVCUserSection: Int, CaseIterable, EditVCCellType {
    case EditUser
    case Requests
    
    var description: String {
        switch self {
        case .EditUser: return "Изменить профиль"
        case .Requests: return "Приглашения"
        }
    }
    
    var cellArray: [String] {
        switch self {
        case .EditUser: return ["Добавить фото", "Имя профиля", "Сменить тип аккаунта", "Обновить профиль"]
        case .Requests: return ["Просмотр приглашений", "Уволиться из кафе"]
        }
    }
    
    var cellType: [EditCellConfiguration] {
        switch self {
        case .EditUser: return [.editPhotoButton, .editNameTF, .segmentedControl, .actionButton]
        case .Requests: return [.textLabel, .actionButton]
        }
    }
}

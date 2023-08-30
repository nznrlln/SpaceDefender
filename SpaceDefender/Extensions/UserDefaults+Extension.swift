//
//  UserDefaults+Extension.swift
//  SpaceDefender
//
//  Created by Нияз Нуруллин on 19.08.2023.
//

import Foundation

extension UserDefaults {

    /// Сохранить данные в UD  через encoder
    /// Данные - generic, соответсвущий протоколу Encodable, чтобы можно было сохранить в виде data
    /// 1ый параметр - входящая модель, 2ой - ключ в UD
    func set<T: Encodable>(encodable: T, forKey: String) {
        do {
            let data = try JSONEncoder().encode(encodable)
            set(data, forKey: forKey)
        } catch {
            debugPrint("Ошибка кодирования привычек для сохранения", error)
        }
    }

    /// Поплучить данные из UD через encoder (опционально)
    /// Конечные данные - generic, соответсвущий протоколу Decodable, чтобы data, полученная из UD -> каст в нужный тип
    /// 1ый параметр - тип в который надо скастить, 2ой - ключ в UD
    func value<T: Decodable>(_ type: T.Type, forKey: String) -> T? {
        guard let data = object(forKey: forKey) as? Data else { return nil }

        do {
            let value = try JSONDecoder().decode(type, from: data)
            return value
        } catch {
            debugPrint("Ошибка декодирования сохранённых данных", error)
        }

        return nil
    }
}

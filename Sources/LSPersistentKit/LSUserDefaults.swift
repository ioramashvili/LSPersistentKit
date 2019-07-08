import Foundation

@propertyWrapper
public struct LSUserDefault<T> {
    public let key: String
    public let defaultValue: T
    public let userDefaults: UserDefaults
    
    public init(_ key: String, defaultValue: T) {
        self.init(.standard, key: key, defaultValue: defaultValue)
    }
    
    public init(_ userDefaults: UserDefaults, key: String, defaultValue: T) {
        self.userDefaults = userDefaults
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var value: T {
        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            let describing = String(describing: newValue)
            let isOptionalAndNil = describing == "nil" && T.self != String.self
            
            if isOptionalAndNil {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}

@propertyWrapper
public struct LSCodableUserDefault<T: Codable> {
    public let key: String
    public let defaultValue: T
    public let decoder: JSONDecoder
    public let encoder: JSONEncoder
    public let userDefaults: UserDefaults
    
    public init(_ key: String, defaultValue: T, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
        self.init(.standard, key: key, defaultValue: defaultValue, decoder: decoder, encoder: encoder)
    }
    
    public init(_ userDefaults: UserDefaults, key: String, defaultValue: T, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
        self.userDefaults = userDefaults
        self.key = key
        self.defaultValue = defaultValue
        self.decoder = decoder
        self.encoder = encoder
    }
    
    public var value: T {
        get {
            guard let data = userDefaults.data(forKey: key) else {
                return defaultValue
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                return defaultValue
            }
        }
        set {
            do {
                let data = try encoder.encode(newValue)
                userDefaults.set(data, forKey: key)
            } catch {
                userDefaults.removeObject(forKey: key)
            }
        }
    }
}

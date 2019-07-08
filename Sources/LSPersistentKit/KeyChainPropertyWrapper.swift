import Foundation

@available(iOS 11, *)
@propertyWrapper
public struct LSRegularKeychain<T> {
    public let key: String
    public let defaultValue: T
    public let accessibility: KeychainItemAccessibility?
    public fileprivate(set) var isSuccessfullySaved = true
    public let keyChainWrapper: KeychainWrapper
    
    public init(_ keyChainWrapper: KeychainWrapper, key: String, defaultValue: T, accessibility: KeychainItemAccessibility? = nil) {
        self.keyChainWrapper = keyChainWrapper
        self.key = key
        self.defaultValue = defaultValue
        self.accessibility = accessibility
    }
    
    public var value: T {
        get {
            guard let data = keyChainWrapper.data(forKey: key, withAccessibility: accessibility) else {
                return defaultValue
            }
            
            let unarchived = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
            
            return unarchived ?? defaultValue
        }
        set {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
                isSuccessfullySaved = keyChainWrapper.set(data, forKey: key, withAccessibility: accessibility)
            } catch {
                isSuccessfullySaved = keyChainWrapper.removeObject(forKey: key, withAccessibility: accessibility)
            }
        }
    }
}

@available(iOS 11, *)
@propertyWrapper
public struct LSCodableKeychain<T: Codable> {
    public let key: String
    public let decoder: JSONDecoder
    public let encoder: JSONEncoder
    public let defaultValue: T
    public let accessibility: KeychainItemAccessibility?
    public let keyChainWrapper: KeychainWrapper
    public fileprivate(set) var isSuccessfullySaved = true
    
    public init(_ keyChainWrapper: KeychainWrapper, key: String, defaultValue: T, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder(), accessibility: KeychainItemAccessibility? = nil) {
        self.keyChainWrapper = keyChainWrapper
        self.key = key
        self.defaultValue = defaultValue
        self.decoder = decoder
        self.encoder = encoder
        self.accessibility = accessibility
    }
    
    public var value: T {
        get {
            guard let data = keyChainWrapper.data(forKey: key, withAccessibility: accessibility) else {
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
                isSuccessfullySaved = keyChainWrapper.set(data, forKey: key, withAccessibility: accessibility)
            } catch {
                isSuccessfullySaved = keyChainWrapper.removeObject(forKey: key, withAccessibility: accessibility)
            }
        }
    }
}



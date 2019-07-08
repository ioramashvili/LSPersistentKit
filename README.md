<h1 align="center">Use of new property wrapper syntax for common UserDefault and Keychain operations</h1>

## Usage

```swift
import LSPersistentKit

```
Using UserDefault property wrappers:
```swift
struct UserSession {
    @LSUserDefault("sessionId", defaultValue: nil)
    static var sessionId: String?
    
    @LSUserDefault(.standard, key: "isLoggedIn", defaultValue: false)
    static var isLoggedIn: Bool
    
    @LSUserDefault("token", defaultValue: nil)
    static var token: Data?
    
    @LSCodableUserDefault(.standard, key: "fullName", defaultValue: nil)
    static var fullName: FullName?
    
    struct FullName: Codable, Equatable {
        public let firstName: String
        public let lastName: String
    }
}
```

Using Keychain property wrappers:
```swift
struct UserSession {
    @LSRegularKeychain(KeychainContainer.shared, key: "sessionId", defaultValue: nil)
    static var sessionId: String?
    
    @LSRegularKeychain(KeychainContainer.shared, key: "isLoggedIn", defaultValue: false)
    static var isLoggedIn: Bool
    
    @LSRegularKeychain(KeychainContainer.shared, key: "token", defaultValue: nil)
    static var token: Data?
    
    @LSCodableKeychain(KeychainContainer.shared, key: "fullName", defaultValue: nil)
    static var fullName: FullName?
    
    struct FullName: Codable, Equatable {
        public let firstName: String
        public let lastName: String
    }
}
```

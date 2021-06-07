import XCTest

extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        
        //Deixando sut como weak eu permito que o método XCTAssertNil seja chamado, pois weak permite que instance seja liberada da memória e vire nil eventualmente. Esse método testa memory leaks no instance
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance)
        }
    }
}

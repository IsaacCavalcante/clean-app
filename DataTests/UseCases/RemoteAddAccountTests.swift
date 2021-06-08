import XCTest
import Domain
import Data

class DataTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() throws {
        let (sut, url, httpClientSpy) = makeSut()
        sut.add(addAccountModel: makeAddAccountModel()){_  in }
        
        XCTAssertEqual(httpClientSpy.url, url, "Url send to httpClient is wrong")
        XCTAssertEqual(httpClientSpy.callsCounter, 1, "post method from HttpClient called more than once")
    }
    
    func test_add_should_call_httpClient_with_correct_data() throws {
        let sut = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.principal.add(addAccountModel: makeAddAccountModel()){_  in }
        
        XCTAssertEqual(sut.httpClientSpy.data, addAccountModel.toData(), "Data from to httpClient is wrong")
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_error() throws {
        let sut = makeSut()
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .failure(.unexpected), when: { sut.httpClientSpy.completionWithError(.noConnectivity) })
    }
    
    func test_add_should_complete_with_account_if_client_completes_with_valid_data() throws {
        let sut = makeSut()
        let expectedAccount = makeAccountModel()
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .success(expectedAccount), when: { sut.httpClientSpy.completionWithData(expectedAccount.toData()!) })
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() throws {
        let sut = makeSut()
        let exp = expectation(description: "completion to add remote account should response until 1 second")
        expect(sut.principal, exp, completeWith: .failure(.invalidData), when: { sut.httpClientSpy.completionWithData(makeInvalidData()) })
    }
    
    func test_add_should_not_complete_with_error_if_sut_has_been_deallocated() throws {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: makeUrl(), httpClient: httpClientSpy)
        var result: Result<AccountModel, DomainError>?

        //aqui é atribuído a result o primeiro parâmetro de completion to tipo Result<AccountModel, DomainError>
        sut?.add(addAccountModel: makeAddAccountModel()) { result = $0 }
        
        //ao definir sut como nil, simulamos que houve um comportamento inesperado (como o usuário não esperar a request e sair da tela) e a instância de RemoteAddAccount acabou sendo desalocada da memória
        sut = nil

        httpClientSpy.completionWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

extension DataTests {
    
    //Já que muitos métodos chamam makeSut fica difícil saber em qual teste o erro ocorreu, os parâmetros file e line são usados para que os erros apareçam onde os métodos foram chamados no teste ao invés de aparecer em makeSut
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (principal: RemoteAddAccount, url: URL, httpClientSpy: HttpClientSpy){
        let url = makeUrl()
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: httpClientSpy)
        
        return (principal: sut, url: url, httpClientSpy: httpClientSpy)
    }
    
    func expect(_ sut: RemoteAddAccount, _ exp: XCTestExpectation, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult  in
            switch (receivedResult, expectedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)): XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) insted", file: file, line: line)
                
            }
            
            exp.fulfill()
        }
        
        //Aqui eu incitei a ocorrência de erro chamando o método action que é passado como parâmeto por que o ponto principal do teste é testar o caso, se eu chamasse o completion dentro do método post de HttpClientSpy deveria decidir o que responder já que haverá casos de sucessos e erros diferenciados, então os métodos completionWithError e completionWithData foram criados dentro de HttpClientSpy para forçar a resposta de erro ou acerto para a qual queremos no teste. Lembrando que o erro ou o model retornado está sendo definido dentro do método add de RemoteAddAccount
        action()
        wait(for: [exp], timeout: 1)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "anyName", email: "anyEmail", password: "anyPassword", passwordConfirmation: "anyPassword")
    }
}

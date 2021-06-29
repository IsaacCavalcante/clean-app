import Foundation
import Domain
import Data

func makeRemoteAddAccount() -> AddAccount {
    return makeRemoteAddAccountWith(httpClient: makeAlamofireAdapter())
}

func makeRemoteAddAccountWith(httpClient: HttpPostClient) -> AddAccount {
    let url = makeApiUrl(path: "signup")
    let remoteAddAccount = RemoteAddAccount(url: url, httpClient: httpClient)
    
    return MainQueueDispatchDecorator(remoteAddAccount)
}

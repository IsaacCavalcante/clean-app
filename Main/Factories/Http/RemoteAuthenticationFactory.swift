import Foundation
import Domain
import Data

func makeRemoteAuthentication() -> Authentication {
    return makeRemoteAuthenticationWith(httpClient: makeAlamofireAdapter())
}

func makeRemoteAuthenticationWith(httpClient: HttpPostClient) -> Authentication {
    let url = makeApiUrl(path: "login")
    let remoteAddAccount = RemoteAuthentication(url: url, httpClient: httpClient)
    
    return MainQueueDispatchDecorator(remoteAddAccount)
}

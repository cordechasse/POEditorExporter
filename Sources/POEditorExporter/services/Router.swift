//
//  File.swift
//  
//
//  Created by Nicolas Bush on 26/05/2020.
//

import Foundation
import RxSwift


struct Router {
	
	private let _api : String
	private let _token : String
	private let _projectId : String
	
	init(api: String, token: String, projectId : String){
		_api = api
		_token = token
		_projectId = projectId
	}
	
	
	private func _rx_getData<T : Codable>(api : API) -> Observable<T?> {
		Observable.create { observer in
			
			let session = URLSession.shared
			var task : URLSessionDataTask?
			
			if let urlRequest = api.getURLRequest(api: self._api, token: self._token, projectId: self._projectId) {
				task = session.dataTask(
					with: urlRequest,
					completionHandler: { data, response, error in
						if let error = error {
							observer.onError(error)
						}
						else if let data = data {
								let decoder = JSONDecoder()
								do {
									let result = try decoder.decode(Response<T>.self, from: data)
									if result.response.code == "200" {
										observer.onNext(result.result)
										observer.onCompleted()
									}
									else {
										observer.onError(POEditorError(result.response))
									}
								}
								catch let err {
									observer.onError(err)
								}
						}
						else {
							observer.onError(RuntimeError("can't read POEditor JSON"))
						}
					}
				)
				task?.resume()
			}
			else {
				observer.onError(RuntimeError("can't create URLRequest"))
			}
			
			
			return Disposables.create {
				task?.cancel()
			}
			
		}
		
	}

	
	func rx_getLanguages() -> Observable<[Language]> {
		let rxLanguages : Observable<Languages?> = _rx_getData(api: .getLanguages)
		return rxLanguages.map { $0?.languages ?? []}
	}
	
	
	func rx_exportLanguage(code: String) -> Observable<URL> {
		let rxExport : Observable<Export?> = _rx_getData(api: .exportLanguage(code: code))
		return rxExport.map {
			if let path = $0?.url, let url = URL(string: path) {
				return url
			}
			else {
				throw RuntimeError("url is empty")
			}
		}
		
	}
	
	
	
	
	func rx_downloadTranslationFile(url: URL) -> Observable<URL> {
		
		Observable.create { observer in
		
			let session = URLSession.shared
			
			let task = session.downloadTask(with: url) { url, response, error in
				if let error = error {
					observer.onError(error)
				}
				else {
					if let url = url {
						observer.onNext(url)
						observer.onCompleted()
					}
					else {
						observer.onError(RuntimeError("file url is nil"))
					}
					
				}
				
			}
			task.resume()
			
			return Disposables.create {
				task.cancel()
			}
			
		}
		
		
	}
	
	
	
}


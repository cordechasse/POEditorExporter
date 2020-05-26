import ArgumentParser
import Darwin
import Foundation
import RxSwift


struct POEditorExporter : ParsableCommand {
	@Option(help: "POEditor read token")
	var token: String
	
	@Option(help: "POEditor project id")
	var project_id: String
	
	@Option(help: "output directory")
	var output: String
	
	
	func run() throws {
		
		
		let _disposeBag = DisposeBag()
		
		let api = "https://api.poeditor.com/v2"
		
		let outputUrl = URL(fileURLWithPath: output, isDirectory: true)
		
		typealias ExportData = (code: String, url: URL)
		
		let router = Router(api: api, token: token, projectId: project_id)
		
		
		print("🚀 Starting generating POEditor translations files")
		print("> token=\(token)")
		print("> project_id=\(project_id)")
		print("> output=\(output)")
		
		router.rx_getLanguages()
			.flatMap { languages -> Observable<ExportData> in
				
				//pour chacun des languages, on recupere l'url du fichier exporté
				let rxs : [Observable<ExportData>] = languages.map { language in
					router.rx_exportLanguage(code: language.code )
						.map { url -> ExportData in
							(code: language.code, url: url)
						}
				}
				return Observable.concat(rxs)
			}
			.flatMap { exportData -> Observable<ExportData> in
				
				//pour chacunes des url, on télécharge le fichier et on l'enregistre au bon endroit
				router.rx_downloadTranslationFile(url: exportData.url)
					.flatMap { url -> Observable<ExportData> in
						do {
							print("----------------------")
							print("language: \(exportData.code)")
							//on créé un répertoire au nom du code langue
							let targetDirectory = outputUrl.appendingPathComponent("\(exportData.code).lproj", isDirectory: true)
							try FileManager.default.createDirectory(at: targetDirectory, withIntermediateDirectories: true, attributes: nil)
							
							let targetFile = targetDirectory.appendingPathComponent("Localizable.strings")
							
							//on supprime un éventuel fichier deja existant
							if FileManager.default.fileExists(atPath: targetFile.path) {
								print("> \(targetFile.path) already exists : overwriting it")
								try FileManager.default.removeItem(at: targetFile)
							}
							
							//on deplace le fichier temporaire
							try FileManager.default.moveItem(at: url, to: targetFile)
							print("> \(exportData.code).lproj/Localizable.strings copied")
							
							//on lit le fichier de trad afin d'extraire les données de l'infoPlist
							if let allTranslations = NSDictionary(contentsOfFile: targetFile.path) as? [String:Any] {
								let infoPlistTranslations = allTranslations.filter { $0.key.starts(with: "NS") || $0.key.starts(with: "CF") }
								let nsDic = NSDictionary(dictionary: infoPlistTranslations)
								let str = nsDic.descriptionInStringsFileFormat
								
								let infoPlistStringFile = targetDirectory.appendingPathComponent("InfoPlist.strings")
								try str.write(to: infoPlistStringFile, atomically: true, encoding: .utf8)
								
								print("> \(exportData.code).lproj/InfoPlist.strings copied")
							}
							
							print("✔️ translations \(exportData.code): completed")
							
							return Observable<ExportData>.just((code: exportData.code, url: targetFile))
						}
						catch {
							return Observable<ExportData>.error(error)
						}
						
						
					}
			}
			  .subscribe(
				onError: { error in
					Self.exit(withError: error)
				},
				onCompleted: {
					print("🏁 Completed successfully")
					Self.exit(withError: nil)
				}
			)
			.disposed(by: _disposeBag)
		
		
		//on lance une boucle -> les appels de endPoints sont asynchones
		RunLoop.current.run()
		
	}
	
}






struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}

struct POEditorError: Error, CustomStringConvertible {
    var description: String
    
    init(_ responseSuccess: ResponseResult) {
		self.description = "status=\(responseSuccess.status) code=\(responseSuccess.code) message=\(responseSuccess.message)"
    }
}






POEditorExporter.main()

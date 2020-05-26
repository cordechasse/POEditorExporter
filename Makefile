.PHONY : release

#release the app
release:
	swift build --configuration release
	cp .build/release/POEditorExporter /usr/local/bin/POEditorExporter
	cp .build/release/libSwiftToolsSupport.dylib /usr/local/lib/libSwiftToolsSupport.dylib
	install_name_tool -change ".build/release/libSwiftToolsSupport.dylib" "/usr/local/lib/libSwiftToolsSupport.dylib" "/usr/local/bin/POEditorExporter"

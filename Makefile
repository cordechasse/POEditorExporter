.PHONY : release

#release the app
release:
	#build the library
	swift build --configuration release
	
	#create the destination folders if they don't exist
	mkdir -p  /usr/local/bin
	mkdir -p  /usr/local/lib
	
	#copy files
	cp .build/release/POEditorExporter /usr/local/bin/POEditorExporter
	cp .build/release/libSwiftToolsSupport.dylib /usr/local/lib/libSwiftToolsSupport.dylib
	
	#include the libSwiftToolsSupport.dylib into the library
	install_name_tool -change ".build/release/libSwiftToolsSupport.dylib" "/usr/local/lib/libSwiftToolsSupport.dylib" "/usr/local/bin/POEditorExporter"

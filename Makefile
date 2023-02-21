.PHONY : release

#release the app
release:
	rm -f /usr/local/bin/poeditor
	swift build --configuration release
	cp .build/release/poeditor /usr/local/bin/poeditor

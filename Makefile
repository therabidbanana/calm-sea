compile: source/**/*.fnl
	./support/build.sh

build: compile
	pdc -k source calm-sea.pdx
	cp source/*.ldtk calm-sea.pdx/

launch: build
	playdate calm-sea.pdx

clean:
	rm ./source/main.lua ./calm-sea.pdx

win-compile: source/**/*.fnl
	powershell.exe "./support/build.ps1"

win-build: win-compile
	powershell.exe "pdc -k source calm-sea.pdx"
	powershell.exe "cp source/*.ldtk calm-sea.pdx/"

win-launch: win-build
	powershell.exe "playdate calm-sea.pdx"

win-clean:
	powershell.exe -noprofile -command "& {rm ./source/main.lua}"
	powershell.exe -noprofile -command "& {rm ./calm-sea.pdx}"

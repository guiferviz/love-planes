
HOME=$(CURDIR)
SRC=love-planes
OUT=game.love


all:
	cd $(SRC); zip -9 -r $(HOME)/android/assets/$(OUT) .
	cd android; ./build.sh

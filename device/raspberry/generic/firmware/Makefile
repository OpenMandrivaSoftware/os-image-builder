.PHONY: all clone clean copy success wipe

all: clone clean copy success wipe

clone:
	git clone https://github.com/raspberrypi/firmware.git --depth 1

clean:
	rm -f firmware/boot/*.dtb
	rm -f firmware/boot/*.img
	rm -rf firmware/boot/overlays

copy:
	cp -fv firmware/boot/* .

wipe:
	rm -rf firmware

success:
	@echo "Firmware files have been cloned and updated successfully."
	@echo "Don't forget to commit the changes."

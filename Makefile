all: led.hex

led.o: led.c
	avr-gcc -g -Os -mmcu=atmega328p -c $^ -o $@

led.elf: led.o
	avr-gcc -g -mmcu=atmega328p -o $@ $^

led.hex: led.elf
	avr-objcopy -j .text -j .data -O ihex $^ $@

.PHONY: size
size: led.elf
	avr-size --format=avr --mcu=atmega328p $^

${HOME}/.avrduderc:
	cp avrdude.conf ${HOME}/.avrduderc

.PHONY: flash-ftdi
flash-ftdi: led.hex ${HOME}/.avrduderc
	avrdude -v -p atmega328p -c ftdi -P ft0 -D -U flash:w:$^:i

.PHONY: flash
flash: led.hex
	avrdude -v -p atmega328p -c arduino -P /dev/ttyUSB0 -b 57600 -D -U flash:w:$^:i

.PHONY: clean
clean:
	rm *.o *.elf *.hex


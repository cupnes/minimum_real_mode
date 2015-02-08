AS = as

.s.o:
	$(AS) -o $*.o $<

all: fd.img

fd.img: hello.o signature.dat
	objcopy -O binary hello.o hello.bin
	dd if=/dev/zero of=zero.dat bs=1 count=$$((510 - $$(stat -c%s hello.bin)))
	cat hello.bin zero.dat signature.dat > fd.img

hello.o: hello.s

signature.dat:
	bash -c 'echo -en "\x55\xaa" > signature.dat'

clean:
	rm -f *~ *.o *.bin *.dat *.img

run: fd.img
	qemu -fda fd.img

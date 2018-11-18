all:
	echo "run make image"

image:
	time ./bootstrap.sh

build-deb:
	./mkdeb.sh

clean:
	rm -rf *.deb *.img chroot

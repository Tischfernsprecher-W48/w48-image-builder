all:
	echo "run make image"

image:
	time ./bootstrap.sh

build-deb:
	./mkdeb.sh 4

clean:
	rm -rf *.deb *.img chroot

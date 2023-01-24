certgen: 
	test -f ./cert/certificate.crt || \
	(openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout private.key -out certificate.crt &&\
	mv *.key ./cert &&\
	mv *.crt ./cert)

udf:
	docker-compose build --build-arg BUILDTGT=lib_mysqludf_sys
	
build: certgen
	docker-compose build
up:
	docker-compose up -d
down:
	docker-compose down
clean: down
	rm -rf ./{cert,tmp}/*
all: build up

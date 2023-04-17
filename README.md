# pem2jks-go
This is just a POC demo that convert PEM to JKS in golang

## Convert PEM to JKS in golang
1. Build the docker image for the go solution:
```
$ docker build -t pem-to-jks-go .
```
2. Generate JKS format certificate and write it to `/certs/output/keystore_golang.jks`:
```
$ docker run --rm -v $(pwd)/certs:/certs pem-to-jks-go
```

## Convert PEM to JKS with Java keytool
1. Pull the official OpenJDK image from Docker Hub:
```
$ docker pull openjdk:11
```
2. Run a Docker container using the OpenJDK image and mount your local `certs` directory to the container:
```
$ docker run -it --rm -v "$(pwd)/certs:/certs" openjdk:11 /bin/bash
```
3. Generate the keystore_java.jks file within the Docker container:
```
# Convert private key from PKCS#8 format to PKCS#1 format
$ openssl rsa -in /certs/input/key.pem -out /certs/output/key_pkcs1.pem

# Create a PKCS12 keystore containing the certificate and private key
$ openssl pkcs12 -export -in /certs/input/cert.pem -inkey /certs/output/key_pkcs1.pem -out /certs/output/keystore.p12 -name alias -password pass:password

# Convert the PKCS12 keystore to JKS format
$ keytool -importkeystore -srckeystore /certs/output/keystore.p12 -srcstoretype PKCS12 -srcstorepass password -destkeystore /certs/output/keystore_java.jks -deststoretype JKS -deststorepass password
```
Now you have the JKS format certificate genereate by Java keytool in `/certs/output/keystore_java.jks`

## Compare the JKS certificates generate by different methods
Still within the above docker instance, run below command lines to convert the JKS certs to plain text for comparison:
```
$ keytool -list -v -keystore /certs/output/keystore_golang.jks -storepass password > /certs/output/keystore_golang.txt
$ keytool -list -v -keystore /certs/output/keystore_java.jks -storepass password > /certs/output/keystore_java.txt
```
Now, you should have the `keystore_golang.txt` and `keystore_java.txt` files in your `/certs/output` directory in the repo. You can compare these files to check if the Golang solution generated the correct JKS file.

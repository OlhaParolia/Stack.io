ID=$(docker build -q ../dockerize )
CD=$(date +"%F")
REP_TAG=go-app:$CD
docker tag $ID $REP_TAG
sed "s/MY_NEW_IMAGE/$REP_TAG/g" ./script.yml > new-app.yaml
kubectl diff -f new-app.yaml

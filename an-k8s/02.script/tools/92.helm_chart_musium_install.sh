#s3 create
# aws s3 mb s3://s3-dev-helm-chart-musium

#install
 curl -LO https://s3.amazonaws.com/chartmuseum/release/latest/bin/linux/amd64/chartmuseum
 chmod +x chartmuseum
 ./chartmuseum --version


export s3=${s3-dev-helm-chart-musium}
docker run -d -it \
  -p 8080:8080 \
  -e DEBUG=1 \
  -e STORAGE="amazon" \
  -e STORAGE_AMAZON_BUCKET="s3-dev-helm-chart-musium" \
  -e STORAGE_AMAZON_PREFIX="" \
  -e STORAGE_AMAZON_REGION="ap-northeast-2" \
  -v ~/.aws:/home/chartmuseum/.aws:ro \
  chartmuseum/chartmuseum:latest

export s3=${s3-dev-helm-chart-musium}
./chartmuseum --storage=amazon \
storage-amazon-bucket=${s3} \
  --storage-amazon-prefix= \
  --storage-amazon-region=ap-northeast-2


docker run --rm -it \
  -p 8080:8080 \
  -e DEBUG=1 \
  -e STORAGE=local \
  -e STORAGE_LOCAL_ROOTDIR=/charts \
  -v $(pwd)/charts:/charts \
  ghcr.io/helm/chartmuseum:v0.14.0
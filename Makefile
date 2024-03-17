bucketName := statds.org
dis_id := E3DVVXYMMAN6SE

# build and publish to public/
.PHONY: build
build:
	rm html/*.html
	bash compile.sh

# push a local media copy (under static/media/) to the remote bucket
.PHONY: push
push:
	aws s3 sync html/doc/ s3://$(bucketName)/doc/ --delete \
	--exclude ".DS_Store" \
	--exclude "**/.DS_Store"

# pull a local media copy from the remote bucket to static/media/
.PHONY: pull
pull:
	aws s3 sync s3://$(bucketName)/doc/ html/doc/ --delete \
	--exclude ".DS_Store" \
	--exclude "**/.DS_Store"

.PHONY: invalidation
invalidation:
	aws configure set preview.cloudfront true
	aws cloudfront create-invalidation \
	--distribution-id $(dis_id) --paths '/*'

.PHONY: clean
clean:
	rm -rf html/doc html/*.html *~ *# *.DS_Store

# Right Touch Client Portal

## ngrok tunnel
ngrok http -subdomain=mosby-connect -host-header=local.righttouch.net 80

## Build process

Update `version` in `./web/index.html` and `./lib/widgets/Layout.dart`  they should be the same for consistency.

Finally,  run:

`flutter build web`

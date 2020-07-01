# live-streaming-server
Live Streaming Server based on NGINX and NGINX-RMTP-Module

*License:*   [GNU GPL v3 or later](http://www.gnu.org/copyleft/gpl.html)

## Docker Compose Environments
* ENABLE_SSL_CERTBOT - if set to "true" Certbot will be run to generate certificates (Default: false)
* STREAMING_SERVER_EMAIL - Email for generating certificates 
* STREAMING_SERVER_DOMAIN - Domain of the certificates (Default: _)

## Cerbot
Command: certbot certonly --standalone -d $STREAMING_SERVER_DOMAIN --email $STREAMING_SERVER_EMAIL -n --agree-tos --expand --deploy-hook "nginx -s reload"

--deploy-hook "nginx -s reload": reloads NGINX if a new certificate is generated

## Streaming

The server receives an RTMP stream and transcode it in
 
* 1920x1080
* 1280x720
* 854x480




### Send stream to server
rtmp://HOST/stream/STREAMING_KEY

### Receiving stream from server
https://HOST/live/STREAMING_KEY.m3u8 - Contains all streaming resolutions

#### Get only on resolution
* https://HOST/live/STREAMING_KEY_480/index.m3u8
* https://HOST/live/STREAMING_KEY_720/index.m3u8
* https://HOST/live/STREAMING_KEY_1080/index.m3u8

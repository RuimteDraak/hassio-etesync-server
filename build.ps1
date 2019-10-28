docker build --build-arg BUILD_FROM="homeassistant/amd64-base:latest" -t local/hassio-etesync-server .

# run: 
# create a data folder with options.json and update the volume path
# docker run --rm -it -v E:/Lars/Development/hassio/hassio-etesync-server/data:/data -p 80:8080 local/hassio-etesync-server
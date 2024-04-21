# w2d-docker

## How to use?

This docker image includes https://github.com/FKLC/WhatsAppToDiscord, here is the compose file you can use:

```yaml
services:
  w2d:
    container_name: w2d
    image: zoeyvid/w2d-docker
    restart: always
    volumes:
      - "/opt/w2d/storage:/app/storage"
      - "/opt/w2d/downloads:/app/downloads"
    environment:
      - "TZ=Europe/Berlin"
      - "WA2DC_TOKEN=your-discord-bot-token"
    user: 1000:1000
```

make sure to change WA2DC_TOKEN and the user ids to match the correct user, you can also use root

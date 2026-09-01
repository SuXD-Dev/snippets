# Docker Snippets

## Cleaning Up

```bash
docker container prune
docker image prune -a
docker volume prune
docker system prune -a --volumes
docker system df
```

## Debugging

```bash
docker exec -it <container> bash
docker logs -f <container>
docker logs --since 1h <container>
docker inspect <container>
docker stats <container>
```

## Build Optimization

```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/index.js"]
```

## Useful One-Liners

```bash
docker rm -f $(docker ps -aq)
docker rmi $(docker images -f "dangling=true" -q)
docker cp <container>:/path/to/file ./local/path
docker export <container> | gzip > backup.tar.gz
docker import backup.tar.gz my-image:latest
```

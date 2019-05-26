# docker-aria2-daemon

## 容器说明

- 将 max-connection-per-server 的限制提升至 65535
- 将 min-split-size 的限制降低至 1K，默认降低至 16M
- 默认的配置文件路径为 /etc/aria2-daemon.conf
- 默认配置文件中的下载路径为 /var/aria2/downloads
- 默认配置文件中的 RPC 端口为 6800
- 默认配置文件中的 BitTorrent 端口为 51413
- 默认配置文件中的 DHT 端口为 51415

## 构建方法

```
git clone https://github.com/MisakaMikoto-35c5/docker-aria2-daemon
docker build docker-aria2-daemon
```

## 使用方法

1. 拉取镜像

```
docker pull kelakim/aria2-daemon
```

2. 创建并启动并启动容器

```
docker run -t -d \
    -p 6800:6800 \
    -p 51413:51413 \
    -p 51415:51415 \
    -v /path/of/your/downloads_directory:/var/aria2 \
    aria2-daemon
```

3. 创建并启动一个使用自定义配置文件的容器

```
docker run -t -d \
    -p 6800:6800 \
    -p 51413:51413 \
    -p 51415:51415 \
    -v /path/of/your/downloads_directory:/var/aria2 \
    -v /path/of/your/custom/aria2-daemon.conf:/etc/aria2-daemon.conf \
    aria2-daemon
```
# 基于官方 PHP + Apache 镜像
FROM php:8.2-apache

# 安装依赖
RUN apt-get update && apt-get install -y \
    libpq-dev libzip-dev unzip git curl \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip \
    && rm -rf /var/lib/apt/lists/*

# 下载 FreshRSS
WORKDIR /var/www/html
RUN git clone --depth=1 https://github.com/FreshRSS/FreshRSS.git . \
    && chown -R www-data:www-data /var/www/html

# 修复 data/ 目录权限
RUN mkdir -p /var/www/html/data/favicons \
    && mkdir -p /var/www/html/data/cache \
    && mkdir -p /var/www/html/data/users \
    && chown -R www-data:www-data /var/www/html/data \
    && chmod -R 775 /var/www/html/data

# 启用 Apache Rewrite 模块
RUN a2enmod rewrite

# ⚡ 关键：修改 Apache 配置以监听 Zeabur 的 $PORT
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 暴露默认端口（Zeabur 会映射 $PORT）
EXPOSE 8080

# 替换 Apache 的监听端口为 Zeabur 提供的 $PORT
CMD ["sh", "-c", "sed -i 's/80/${PORT}/' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf && apache2-foreground"]


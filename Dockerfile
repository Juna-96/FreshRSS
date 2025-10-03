# 使用官方 PHP + Apache 镜像
FROM php:8.2-apache

# 安装必要依赖
RUN apt-get update && apt-get install -y \
    libpq-dev libzip-dev unzip git \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip

# 下载 FreshRSS 源码
WORKDIR /var/www/html
RUN git clone --depth=1 https://github.com/FreshRSS/FreshRSS.git . \
    && chown -R www-data:www-data /var/www/html

# 修复目录权限（关键）
RUN mkdir -p /var/www/html/data/favicons \
    && mkdir -p /var/www/html/data/cache \
    && mkdir -p /var/www/html/data/users \
    && chown -R www-data:www-data /var/www/html/data \
    && chmod -R 775 /var/www/html/data

# 启用 Apache Rewrite 模块（FreshRSS 需要）
RUN a2enmod rewrite

# ⚡ Zeabur 会传入 $PORT 环境变量，这里强制 Apache 监听它
CMD ["sh", "-c", "sed -i 's/80/${PORT}/' /etc/apache2/sites-available/000-default.conf && apache2-foreground"]

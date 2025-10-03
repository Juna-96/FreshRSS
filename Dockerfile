# 使用官方 PHP + Apache 镜像
FROM php:8.2-apache

# 安装必要扩展
RUN apt-get update && apt-get install -y \
    libpq-dev libzip-dev unzip git \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip

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

# 启用 Apache Rewrite 模块（FreshRSS 需要）
RUN a2enmod rewrite

# 开放 80 端口
EXPOSE 80

# 默认启动 Apache
CMD ["apache2-foreground"]

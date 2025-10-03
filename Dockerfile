FROM php:8.2-apache

# 安装扩展（FreshRSS 推荐）
RUN docker-php-ext-install pdo pdo_mysql

# 拷贝项目代码
COPY . /var/www/html

# 设置工作目录
WORKDIR /var/www/html

# FreshRSS 的入口在 p 目录
CMD ["php", "-S", "0.0.0.0:8080", "-t", "./p"]

# 设置 data 目录可写
RUN mkdir -p /var/www/html/data \
    && chown -R www-data:www-data /var/www/html/data \
    && chmod -R 755 /var/www/html/data

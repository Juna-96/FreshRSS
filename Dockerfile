FROM php:8.2-apache

# 安装扩展（FreshRSS 推荐）
RUN docker-php-ext-install pdo pdo_mysql

# 拷贝项目代码
COPY . /var/www/html

# 设置工作目录
WORKDIR /var/www/html

# FreshRSS 的入口在 p 目录
CMD ["php", "-S", "0.0.0.0:8080", "-t", "./p"]

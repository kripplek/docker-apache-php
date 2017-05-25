FROM outrigger/apache-php-base

RUN yum -y install \
      https://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum -y install \
      gcc-c++ \
      make \
      php70 \
      php70-php-devel \
      php70-php-gd \
      php70-php-xml \
      php70-php-pdo \
      php70-php-mysql \
      php70-php-mysqlnd \
      php70-php-mbstring \
      php70-php-fpm \
      php70-php-opcache \
      php70-php-pecl-memcache \
      php70-php-pecl-xdebug \
      php70-php-mcrypt
      # There is no PHP 7 support for XHProf yet.
      # php70-php-pecl-xhprof

ENV PHP_HOME /opt/remi/php70
RUN ln -sfv ${PHP_HOME}/root/usr/bin/* /usr/bin/ && \
    ln -sfv ${PHP_HOME}/root/usr/sbin/* /usr/sbin/ && \
    ln -svf /dev/stderr /var${PHP_HOME}/log/php-fpm/error.log

# Install phpredis
ENV PHPREDIS_VERSION 3.1.2
RUN curl -L -o /tmp/phpredis.tar.gz "https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz" && \
    tar -xzf /tmp/phpredis.tar.gz -C /tmp && \
    rm /tmp/phpredis.tar.gz && \
    cd "/tmp/phpredis-$PHPREDIS_VERSION" && \
    phpize && \
    ./configure && \
    make && \
    make install

# Cleanup the things needed to build phpredis
RUN yum -y remove gcc-c++ make php70-php-devel

COPY root /

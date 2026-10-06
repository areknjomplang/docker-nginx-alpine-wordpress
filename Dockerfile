FROM wordpress:7.1.2-php8.5-fpm-alpine

# Install PHP Extensions melalui MLocati installer
COPY --from=docker.io/mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions redis

# Install Composer
COPY --from=docker.io/library/composer:2.10.3 /usr/bin/composer /usr/local/bin/composer

# Install WP-CLI
RUN set -eux; \
    curl -fsSL -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
    EXPECTED="$(curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar.sha512)"; \
    echo "$EXPECTED  /tmp/wp-cli.phar" | sha512sum -c -; \
    chmod +x /tmp/wp-cli.phar; \
    mv /tmp/wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html/wp-content/cache

# Ensure wp-content/cache is owned by www-data
RUN chown -R www-data:www-data /var/www/html/wp-content/cache
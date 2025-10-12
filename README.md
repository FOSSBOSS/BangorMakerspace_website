<pre>
The goal of this page(s) is:
1. to be as simple** as possible to edit and maintain 
2. Keep it 80s style.

Clearly, I dont care about conventional beauty. 

<img src="https://raw.githubusercontent.com/FOSSBOSS/BangorMakerspace_website/main/img/yeah.png"
     alt="Yeah image" width="600" />
hosted / tested on nginx with php8.1 on debian 13, and ubuntu 20.04 <br>
TODO: look into rendering issues on windows
TODO: improve content loader. improve content generation ability.
TODO: write css based animations.
TODO: unify formating. I tried some stuff, and havent decided what I like best.<br>
TODO: make the code that generates sitemap.html ignore some stuff, and easier to autoformat.
TODO: include the code that generates sitemap.html lol

*Simplicity may vary

## NGINX Installation and Configs
sudo apt install nginx

allow nginx in you firewall settings.
sudo ufw allow 'Nginx HTTP' 

sudo vim /etc/nginx/mime.types
add a line to render lolcode as text. Add others as needed
text/plain                            txt lol;

*** pretty sure we dont need that second location tag but whatever Im leaving it for now.
sudo vim /etc/nginx/sites-enabled/default

server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /home/m/img;                 # edit to whatever your path is
    index index.html index.htm index.php;

    server_name _;

    location / {
        autoindex on;
        autoindex_exact_size off;     # human-readable sizes
        autoindex_localtime on;       # show local time
    }

    location ~ \.(php|html)$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}


Test config, and reload server
sudo nginx -t && sudo systemctl reload nginx

## PHP Installation and Configs<br>
sudo apt install php8.1-readline php8.1-fpm 

sudo vim /etc/php/8.1/fpm/pool.d/www.conf

Add html to this line, and uncomment
security.limit_extensions = .php .php3 .php4 .php5 .php7 .html

sudo systemctl restart php8.1-fpm

Server Config complete

</pre>

# app_marcaciones_face

Flutter version
3.38.7


## Install fvm
curl -fsSL https://fvm.app/install.sh | bash


## For bash (add to ~/.bashrc):
export PATH="/root/fvm/bin:$PATH"

## Then restart your shell or run:
source ~/.bashrc 

- fvm list
- fvm install <version>
- fvm global <version>
- fvm flutter build web --base-href /app_marcaciones_face/build/web/


## .htaccess

RewriteEngine On

RewriteRule ^$ /app_marcaciones_face/build/web/index.html [L]
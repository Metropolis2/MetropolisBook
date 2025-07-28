#!/usr/bin/sh
mdbook build --dest-dir book/
rsync -avz --delete --no-owner --no-group --no-perms --no-times book/ home:/var/www/metropolis-book

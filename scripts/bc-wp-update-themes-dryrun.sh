#!/bin/bash

vagrant ssh -c "(cd /var/www/html/; wp theme update --all --dry-run)";

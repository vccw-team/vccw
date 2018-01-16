#!/bin/bash

vagrant ssh -c "(cd /var/www/html/; wp core version)"; vagrant ssh -c "(cd /var/www/html/; wp core check-update)";

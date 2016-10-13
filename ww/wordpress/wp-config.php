<?php


// ** MySQL settings ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpress');

/** MySQL database password */
define('DB_PASSWORD', 'wordpress');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

define('AUTH_KEY',         '{%R4_1zfujf7K$hN<$ +]tnGD1pL7JgMBiF@&3Z-q/a(m#?y|ThQbxVUqDf-a!o0');
define('SECURE_AUTH_KEY',  '3QWy1|`+-ZN!&q2Unzd*ExUHoft67b?y+bMLVA%J^n/.TwB7ZqzB<|h[!LK%&rV[');
define('LOGGED_IN_KEY',    '7<qy||`gH12Z{6{[mbOC+=yE9kF+/m7EPp<.7xK.LMK39]X4/v~J|d1Nq6;Z2/bS');
define('NONCE_KEY',        'd-wR]` Qh^9FOcp1Q!b&BdK~%yaE=w-LU!NB$fjR^<tMl07P[mbLJ_o2JJCcdK-Z');
define('AUTH_SALT',        'i:9v}@L ~/j:e<PX4=qZnmTv+1g-}#,QR&&4yM)u@-Zp|-j?)/+Ina0C`x/o>s+-');
define('SECURE_AUTH_SALT', '!LU{ci6$8*r -Vl~-b:?Jtk*+kIE`YX-/0{F/w.a4`Rps=V`!)Ah1K){nmWiQ}Id');
define('LOGGED_IN_SALT',   '^n&J;3egP?[[{sA>ol$`35H!)ZnZBwWC5AOr||O6?x-@swESTN`$#o6:r*JFd`*Q');
define('NONCE_SALT',       '-RYa&P^4s6[jC)uy|hGz-o4VPiBC,SIF P#Q{ecHk+QV};U}*eG2W-BIa] w$3C5');


$table_prefix = 'wp_';


define( 'WP_HOME', 'http://vccw.dev/' );
define( 'WP_SITEURL', 'http://vccw.dev/' );
define( 'JETPACK_DEV_DEBUG', True );
define( 'WP_DEBUG', True );
define( 'FORCE_SSL_ADMIN', False );
define( 'SAVEQUERIES', False );



/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

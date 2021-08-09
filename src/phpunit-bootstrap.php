<?php

/*
Copyright Siemens AG 2014

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.  This file is offered as-is,
without any warranty.
*/

namespace TestSupport;

require_once(dirname(__DIR__, 1) . '/build/vendor/autoload.php');
require_once __DIR__ . '/lib/php/common-string.php';

\Hamcrest\Util::registerGlobalFunctions();

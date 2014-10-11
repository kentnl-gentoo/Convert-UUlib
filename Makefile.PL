use ExtUtils::MakeMaker;

use Canary::Stability Convert::UUlib => 1;

WriteMakefile(
    'dist'	=> {
	            PREOP	=> 'pod2text UUlib.pm | tee README >$(DISTVNAME)/README; chmod -R u=rwX,go=rX . ; chmod -R u=rwX,go=rX . ;',
	            COMPRESS	=> 'gzip -9v',
	            SUFFIX	=> '.gz',
	           },
    'NAME'	=> 'Convert::UUlib',
    'VERSION_FROM' => 'UUlib.pm',
    'LIBS'	=> ['-luu'],
    'DEFINE'	=> '',
    'INC'	=> '',
    CONFIGURE_REQUIRES => {
       "ExtUtils::MakeMaker" => 6.52,
       "Canary::Stability"   => 0,
    },
);

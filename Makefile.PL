use ExtUtils::MakeMaker;

sub MY::postamble {
    my $postamble =<<'END';

uulib/Makefile:
	cd uulib && ./configure --with-cc="$(CC)" --with-cflags="$(CFLAGS) $(CCCDLFLAGS) $(OPTIMIZE)"

clean::
	-cd uulib && make distclean

$(MYEXTLIB): uulib/Makefile uulib/uulib.c
	cd uulib && $(MAKE) all

END
}

WriteMakefile(
    'dist'	=> {
	            PREOP	=> 'chmod -R u=rwX,go=rX . ;',
	            COMPRESS	=> 'gzip -9v',
	            SUFFIX	=> '.gz',
	           },
    'NAME'	=> 'Convert::UUlib',
    'VERSION_FROM' => 'UUlib.pm',
    'MYEXTLIB'  => 'uulib/libuu$(LIB_EXT)',
    'LIBS'	=> [''],
    'DEFINE'	=> '',
    'INC'	=> '',
);

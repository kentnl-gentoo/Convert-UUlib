package Convert::UUlib;

use Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $AUTOLOAD);

require Exporter;
require DynaLoader;
use AutoLoader;

@ISA = qw(Exporter DynaLoader);

@_consts = qw(
	ACT_COPYING ACT_DECODING ACT_ENCODING ACT_IDLE ACT_SCANNING

	FILE_DECODED FILE_ERROR FILE_MISPART FILE_NOBEGIN FILE_NODATA
	FILE_NOEND FILE_OK FILE_READ FILE_TMPFILE

	MSG_ERROR MSG_FATAL MSG_MESSAGE MSG_NOTE MSG_PANIC MSG_WARNING

	OPT_BRACKPOL OPT_DEBUG OPT_DESPERATE OPT_DUMBNESS OPT_ENCEXT
	OPT_ERRNO OPT_FAST OPT_IGNMODE OPT_IGNREPLY OPT_OVERWRITE OPT_PREAMB
	OPT_PROGRESS OPT_SAVEPATH OPT_TINYB64 OPT_USETEXT OPT_VERBOSE
	OPT_VERSION

	RET_CANCEL RET_CONT RET_EXISTS RET_ILLVAL RET_IOERR RET_NODATA
	RET_NOEND RET_NOMEM RET_OK RET_UNSUP

	B64ENCODED BH_ENCODED PT_ENCODED QP_ENCODED
	XX_ENCODED UU_ENCODED
);

@_funcs = qw(
	Initialize CleanUp GetOption SetOption strerror
	SetMsgCallback SetBusyCallback SetFileCallback
	SetFNameFilter FNameFilter LoadFile GetFileListItem
	RenameFile DecodeToTemp RemoveTemp DecodeFile
	InfoFile Smerge QuickDecode EncodeMulti EncodePartial
	EncodeToStream EncodeToFile E_PrepSingle E_PrepPartial

        straction strencoding strmsglevel
);

@EXPORT = @_consts;
@EXPORT_OK = @_funcs;
%EXPORT_TAGS = (all => [@_consts,@_funcs], constants => \@_consts);
$VERSION = '0.05';

bootstrap Convert::UUlib $VERSION;

Initialize(); END { CleanUp() }

for (@_consts) {
   my $constant = constant($_);
   *$_ = sub () { $constant };
}

# action code -> string mapping
sub straction($) {
   return 'copying'	if $_[0] == &ACT_COPYING;
   return 'decoding'	if $_[0] == &ACT_DECODING;
   return 'encoding'	if $_[0] == &ACT_ENCODING;
   return 'idle'	if $_[0] == &ACT_IDLE;
   return 'scanning'	if $_[0] == &ACT_SCANNING;
   ();
}

# encoding type -> string mapping
sub strencoding($) {
   return 'base64'		if $_[0] == &B64ENCODED;
   return 'binhex'		if $_[0] == &BH_ENCODED;
   return 'plaintext'		if $_[0] == &PT_ENCODED;
   return 'quoted-printable'	if $_[0] == &QP_ENCODED;
   return 'xxencode'		if $_[0] == &XX_ENCODED;
   return 'uuencode'		if $_[0] == &UU_ENCODED;
   ();
}

sub strmsglevel($) {
   return 'message'	if $_[0] == &MSG_MESSAGE;
   return 'note'	if $_[0] == &MSG_NOTE;
   return 'warning'	if $_[0] == &MSG_WARNING;
   return 'error'	if $_[0] == &MSG_ERROR;
   return 'panic'	if $_[0] == &MSG_PANIC;
   return 'fatal'	if $_[0] == &MSG_FATAL;
   ();
}

1;
__END__

=head1 NAME

Convert::UUlib - Perl interface to the uulib library (a.k.a. uudeview/uuenview).

=head1 SYNOPSIS

  use Convert::UUlib;

=head1 DESCRIPTION

Read the file uulibdoc.dvi.gz and the example-decoder source. Sorry - more
to come once people use me ;)

=head1 Exported constants

Action code constants:

  ACT_COPYING
  ACT_DECODING
  ACT_ENCODING
  ACT_IDLE
  ACT_SCANNING

File status flags:

  FILE_DECODED
  FILE_ERROR
  FILE_MISPART
  FILE_NOBEGIN
  FILE_NODATA
  FILE_NOEND
  FILE_OK
  FILE_READ
  FILE_TMPFILE

Message severity levels:

  MSG_ERROR
  MSG_FATAL
  MSG_MESSAGE
  MSG_NOTE
  MSG_PANIC
  MSG_WARNING

Options:

  OPT_BRACKPOL
  OPT_DEBUG
  OPT_DESPERATE
  OPT_DUMBNESS
  OPT_ENCEXT
  OPT_ERRNO
  OPT_FAST
  OPT_IGNMODE
  OPT_IGNREPLY
  OPT_OVERWRITE
  OPT_PREAMB
  OPT_PROGRESS
  OPT_SAVEPATH
  OPT_TINYB64
  OPT_USETEXT
  OPT_VERBOSE
  OPT_VERSION

Error/Result codes:

  RET_CANCEL
  RET_CONT
  RET_EXISTS
  RET_ILLVAL
  RET_IOERR
  RET_NODATA
  RET_NOEND
  RET_NOMEM
  RET_OK
  RET_UNSUP

Encoding types:

  B64ENCODED
  BH_ENCODED
  PT_ENCODED
  QP_ENCODED
  XX_ENCODED
  UU_ENCODED


=head1 Exported functions

  int	  Initialize		() ;
  int	  GetOption		() ;
  int	  SetOption		() ;
  char *	  strerror		() ;
  int	  SetMsgCallback	() ;
  int	  SetBusyCallback	() ;
  int	  SetFileCallback	() ;
  int	  SetFNameFilter	() ;
  char *	  FNameFilter		() ;
  int	  LoadFile		() ;
  uulist *   GetFileListItem	() ;
  int	  RenameFile		() ;
  int	  DecodeToTemp		() ;
  int	  RemoveTemp		() ;
  int	  DecodeFile		() ;
  int	  InfoFile		() ;
  int	  Smerge		() ;
  int	  CleanUp		() ;
  int	  QuickDecode		() ;
  int	  EncodeMulti		() ;
  int	  EncodePartial	() ;
  int	  EncodeToStream	() ;
  int	  EncodeToFile		() ;
  int	  E_PrepSingle		() ;
  int	  E_PrepPartial	() ;


=head1 AUTHOR

Marc Lehmann <pcg@goof.com>, the uulib library was written by Frank Pilhofer <fp@informatik.uni-frankfurt.de>.

=head1 SEE ALSO

perl(1), uudeview homepage at http://www.uni-frankfurt.de/~fp/uudeview/.

=cut

package Convert::UUlib;

use Carp;

require Exporter;
require DynaLoader;
use AutoLoader;

$VERSION = 0.2;

@ISA = qw(Exporter DynaLoader);

@_consts = qw(
	ACT_COPYING ACT_DECODING ACT_ENCODING ACT_IDLE ACT_SCANNING

	FILE_DECODED FILE_ERROR FILE_MISPART FILE_NOBEGIN FILE_NODATA
	FILE_NOEND FILE_OK FILE_READ FILE_TMPFILE

	MSG_ERROR MSG_FATAL MSG_MESSAGE MSG_NOTE MSG_PANIC MSG_WARNING

	OPT_BRACKPOL OPT_DEBUG OPT_DESPERATE OPT_DUMBNESS OPT_ENCEXT
	OPT_ERRNO OPT_FAST OPT_IGNMODE OPT_IGNREPLY OPT_OVERWRITE OPT_PREAMB
	OPT_PROGRESS OPT_SAVEPATH OPT_TINYB64 OPT_USETEXT OPT_VERBOSE
	OPT_VERSION OPT_REMOVE OPT_MOREMIME

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

bootstrap Convert::UUlib $VERSION;

Initialize();

# not when < 5.005_6x
# END { CleanUp() }

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

=head1 SMALL EXAMPLE DECODER

The following code excerpt is a minimal decoder program. It reads all
files given on the commandline and decodes any files in it.

 use Convert::UUlib ':all';
 
 LoadFile($_) for @ARGV;
 
 for($i=0; $uu=GetFileListItem($i); $i++) {
    $uu->decode if $uu->state & FILE_OK;
 }

=head1 LARGE EXAMPLE DECODER

This is the file C<example-decoder> from the distribution, put here
instead of more thorough documentation.

 # decode all the files in the directory uusrc/ and copy
 # the resulting files to uudst/

 use Convert::UUlib ':all';

 sub namefilter {
    my($path)=@_;
    $path=~s/^.*[\/\\]//;
    $path;
 }

 sub busycb {
    my($action,$curfile,$partno,$numparts,$percent,$fsize)=@_;
    $_[0]=straction($action);
    print "busy_callback(",join(",",@_),")\n";
    0;
 }

 SetOption (OPT_IGNMODE, 1);
 SetOption (OPT_VERBOSE, 1);

 # show the three ways you can set callback functions
 SetFNameFilter (\&namefilter);

 SetBusyCallback ("busycb",333);

 SetMsgCallback (sub {
    my($msg,$level)=@_;
    print uc(strmsglevel($_[1])),": $msg\n";
 });

 for(<uusrc/*>) {
    my($retval,$count)=LoadFile ($_,$_,1);
    print "file($_), status(",strerror($retval),") parts($count)\n";
 }

 SetOption (OPT_SAVEPATH, "uudst/");

 $i=0;
 while($uu=GetFileListItem($i)) {
    $i++;
    print "file nr. $i";
    print " state ",$uu->state;
    print " mode ",$uu->mode;
    print " uudet ",strencoding($uu->uudet);
    print " size ",$uu->size;
    print " filename ",$uu->filename;
    print " subfname ",$uu->subfname;
    print " mimeid ",$uu->mimeid;
    print " mimetype ",$uu->mimetype;
    print "\n";

    # print additional info about all parts
    for($uu->parts) {
       while(my($k,$v)=each(%$_)) {
          print "$k > $v, ";
       }
       print "\n";
    }

    $uu->decode_temp;
    print " temporarily decoded to ",$uu->binfile,"\n";
    $uu->remove_temp;

    print strerror($uu->decode);
    print " saved as uudst/",$uu->filename,"\n";
 }

 print "cleanup...\n";

 CleanUp();

=head1 Exported constants

Action code constants:

  ACT_COPYING ACT_DECODING ACT_ENCODING
  ACT_IDLE    ACT_SCANNING

File status flags:

  FILE_DECODED FILE_ERROR  FILE_MISPART
  FILE_NOBEGIN FILE_NODATA FILE_NOEND
  FILE_OK      FILE_READ   FILE_TMPFILE

Message severity levels:

  MSG_ERROR MSG_FATAL MSG_MESSAGE
  MSG_NOTE  MSG_PANIC MSG_WARNING

Options:

  OPT_BRACKPOL OPT_DEBUG     OPT_DESPERATE OPT_DUMBNESS
  OPT_ENCEXT   OPT_ERRNO     OPT_FAST      OPT_IGNMODE
  OPT_IGNREPLY OPT_OVERWRITE OPT_PREAMB    OPT_PROGRESS
  OPT_SAVEPATH OPT_TINYB64   OPT_USETEXT   OPT_VERBOSE
  OPT_VERSION  OPT_REMOVE    OPT_MOREMIME

Error/Result codes:

  RET_CANCEL RET_CONT  RET_EXISTS RET_ILLVAL RET_IOERR
  RET_NODATA RET_NOEND RET_NOMEM  RET_OK     RET_UNSUP

Encoding types:

  B64ENCODED BH_ENCODED PT_ENCODED
  QP_ENCODED XX_ENCODED UU_ENCODED

=head1 Exported functions

Initializing and cleanup (Initialize is automatically called when the
module is loaded and allocates quite a bit of memory. CleanUp releases
that again).

  Initialize; # not normally necessary
  CleanUp;    # could be called at the end to release memory

Setting and querying options:

  $option = GetOption OPT_xxx;
  SetOption OPT_xxx, opt-value;

Error and action values => stringified:

  $msg = straction ACT_xxx;
  $msg = strerror RET_xxx;

Setting various callbacks:

  SetMsgCallback [callback-function];
  SetBusyCallback [callback-function];
  SetFileCallback [callback-function];
  SetFNameFilter [callback-function];

Call the currently selected FNameFilter:

  $file = FNameFilter $file;

Loading sourcefiles, optionally fuzzy merge and start decoding:

  ($retval, $count) = LoadFile $fname, [$id, [$delflag]];
  $retval = Smerge $pass;
  $item = GetFileListItem $item_number;

The procedural interface is undocumented, use the following methods instead:

  $retval = $item->rename($newname);
  $retval = $item->decode_temp;
  $retval = $item->remove_temp;
  $retval = $item->decode([$target_path]);
  $retval = $item->info(callback-function);

Querying (and setting) item attributes:

  $state    = $item->state;
  $mode     = $item->mode([newmode]);
  $uudet    = $item->uudet;
  $size     = $item->size;
  $filename = $item->filename([newfilename});
  $subfname = $item->subfname;
  $mimeid   = $item->mimeid;
  $mimetype = $item->mimetype;
  $binfile  = $item->binfile;

Totally undocumented and unsupported(!):

  $parts = $item->parts;

Functions below not documented and not very well tested:

  int	  QuickDecode		() ;
  int	  EncodeMulti		() ;
  int	  EncodePartial	() ;
  int	  EncodeToStream	() ;
  int	  EncodeToFile		() ;
  int	  E_PrepSingle		() ;
  int	  E_PrepPartial	() ;

=head1 AUTHOR

Marc Lehmann <pcg@goof.com>, the original uulib library was written by
Frank Pilhofer <fp@informatik.uni-frankfurt.de>.

=head1 SEE ALSO

perl(1), uudeview homepage at http://www.uni-frankfurt.de/~fp/uudeview/.

=cut

#! /usr/bin/awk
#
# $Id: uustring.awk,v 1.1 2001/06/11 19:49:00 root Exp $
#
# Extract definitions for string codes from uustring.c into uustring.h
# Does this script require GAWK?
#
BEGIN		{ i=1; }
/\$Id/		{
		  match ($0, "\\$Id.*\\$");
		  printf ("/* extracted from %s */\n",
			  substr ($0, RSTART+1, RLENGTH-2));
		}
/^[ 	]*\{[ 	]*S_[A-Z_]+.*\}[ 	]*,[ 	]*$/ {
		  match ($0, "S_[A-Z_]+");
		  printf ("#define %-20s %3d\n",
			  substr ($0, RSTART, RLENGTH),
			  i);
		  i++;
		}

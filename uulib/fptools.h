/*
 * fptools.c, some helper functions for getcgi.c and uu(en|de)view
 *
 * Distributed under the terms of the GNU General Public License.
 * Use and be happy.
 */

/*
 * Some handy, nonstandard functions. Note that the original may
 * be both faster and better. ``better'', if your compiler allows
 * cleaner use of such functions by proper use of ``const''.
 *
 * $Id: fptools.h,v 1.2 2001/06/11 20:42:36 root Exp $
 */

#ifndef FPTOOLS_H__
#define FPTOOLS_H__

typedef signed char schar;
typedef unsigned char uchar;

#ifndef TOOLEXPORT
#define TOOLEXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

void	TOOLEXPORT	FP_free		(void *);
char *	TOOLEXPORT	FP_strdup	(char *);
char *	TOOLEXPORT	FP_strncpy	(char *, char *, int);
void *	TOOLEXPORT	FP_memdup	(void *, int);
int 	TOOLEXPORT	FP_stricmp	(char *, char *);
int 	TOOLEXPORT	FP_strnicmp	(char *, char *, int);
char *	TOOLEXPORT	FP_strrstr	(char *, char *);
char *	TOOLEXPORT	FP_stoupper	(char *);
char *	TOOLEXPORT	FP_stolower	(char *);
int 	TOOLEXPORT	FP_strmatch	(char *, char *);
char *	TOOLEXPORT	FP_strstr	(char *, char *);
char *	TOOLEXPORT	FP_stristr	(char *, char *);
char *	TOOLEXPORT	FP_strirstr	(char *, char *);
char *	TOOLEXPORT	FP_strrchr	(char *, int);
char *	TOOLEXPORT	FP_fgets	(char *, int, FILE *);
char *	TOOLEXPORT	FP_strpbrk	(char *, char *);
char *	TOOLEXPORT	FP_strtok	(char *, char *);
char *	TOOLEXPORT	FP_cutdir	(char *);
char *	TOOLEXPORT	FP_strerror	(int);
char *	TOOLEXPORT	FP_tempnam	(char *, char *);

#ifdef __cplusplus
}
#endif
#endif

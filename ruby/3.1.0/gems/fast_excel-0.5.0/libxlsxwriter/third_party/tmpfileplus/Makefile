###############################################################################
#
# Simplied Makefile to build tmpfileplus for the libxlsxwriter library.
#

# Keep the output quiet by default.
Q=@
ifdef V
Q=
endif

UNAME := $(shell uname)

# Check for MinGW/MinGW64/Cygwin environments.
ifneq (,$(findstring MINGW, $(UNAME)))
MING_LIKE = y
endif
ifneq (,$(findstring MSYS, $(UNAME)))
MING_LIKE = y
endif
ifneq (,$(findstring CYGWIN, $(UNAME)))
MING_LIKE = y
endif

FPIC = -fPIC

# Change make options on MinGW/MinGW64/Cygwin.
ifdef MING_LIKE
FPIC =
CC = gcc
endif

all: tmpfileplus.o tmpfileplus.so

%.o  : %.c
	$(Q)$(CC)         -c $(CFLAGS) $(TARGET_ARCH) $<

%.so : %.c
	$(Q)$(CC) $(FPIC) -c $(CFLAGS) $(TARGET_ARCH) $< -o $@

clean:
	$(Q)rm -f *.o *.so

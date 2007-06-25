# Copyright (c) 2007, Anthony Minessale II
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# 
# * Neither the name of the original author; nor the names of any contributors
# may be used to endorse or promote products derived from this software
# without specific prior written permission.
# 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER
# OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

SRC=src
OBJS=\
$(SRC)/hashtable.o \
$(SRC)/hashtable_itr.o \
$(SRC)/zap_io.o \
$(SRC)/zap_isdn.o \
$(SRC)/zap_analog.o \
$(SRC)/zap_config.o \
$(SRC)/zap_callerid.o \
$(SRC)/fsk.o \
$(SRC)/uart.o \
$(SRC)/g711.o \
$(SRC)/libteletone_detect.o \
$(SRC)/libteletone_generate.o \
$(SRC)/zap_buffer.o \
$(SRC)/zap_threadmutex.o \
$(SRC)/isdn/EuroISDNStateNT.o \
$(SRC)/isdn/EuroISDNStateTE.o \
$(SRC)/isdn/mfifo.o \
$(SRC)/isdn/Q921.o \
$(SRC)/isdn/Q931api.o \
$(SRC)/isdn/Q931.o \
$(SRC)/isdn/Q931ie.o \
$(SRC)/isdn/Q931mes.o \
$(SRC)/isdn/Q931StateNT.o \
$(SRC)/isdn/Q931StateTE.o \
$(SRC)/isdn/nationalmes.o \
$(SRC)/isdn/nationalStateNT.o \
$(SRC)/isdn/nationalStateTE.o \
$(SRC)/isdn/DMSmes.o \
$(SRC)/isdn/DMSStateNT.o \
$(SRC)/isdn/DMSStateTE.o \
$(SRC)/isdn/Q932mes.o \
$(SRC)/zap_zt.o \
$(SRC)/zap_wanpipe.o

#SRCS=$(shell echo $(OBJS) | sed "s/\.o/\.c/g")

HEADERS= $(SRC)/include/fsk.h \
$(SRC)/include/g711.h \
$(SRC)/include/hashtable.h \
$(SRC)/include/hashtable_itr.h \
$(SRC)/include/hashtable_private.h \
$(SRC)/include/libteletone_detect.h \
$(SRC)/include/libteletone_generate.h \
$(SRC)/include/libteletone.h \
$(SRC)/include/openzap.h \
$(SRC)/include/sangoma_tdm_api.h \
$(SRC)/include/uart.h \
$(SRC)/include/wanpipe_tdm_api_iface.h \
$(SRC)/include/zap_analog.h \
$(SRC)/include/zap_buffer.h \
$(SRC)/include/zap_config.h \
$(SRC)/include/zap_isdn.h \
$(SRC)/include/zap_skel.h \
$(SRC)/include/zap_threadmutex.h \
$(SRC)/include/zap_types.h \
$(SRC)/include/zap_wanpipe.h \
$(SRC)/include/zap_zt.h \
$(SRC)/isdn/include/mfifo.h \
$(SRC)/isdn/include/national.h \
$(SRC)/isdn/include/Q921.h \
$(SRC)/isdn/include/Q931.h \
$(SRC)/isdn/include/Q931ie.h \
$(SRC)/isdn/include/Q932.h 


PWD=$(shell pwd)
INCS=-I$(PWD)/$(SRC)//include -I$(PWD)/$(SRC)//isdn/include
CFLAGS=$(ZAP_CFLAGS) $(INCS)
MYLIB=libopenzap.a
LIBPRIA=libpri.a
LIBPRI=./libpri
TMP=-I$(LIBPRI) -I$(SRC)/include -I./src -w

include general.makefile

all: $(MYLIB)

$(MYLIB): $(OBJS) $(HEADERS)
	ar rcs $(MYLIB) $(OBJS) 
	ranlib $(MYLIB)

testapp: $(SRC)/testapp.c $(MYLIB)
	$(CC) $(INCS) -L. $(SRC)/testapp.c -o testapp -lopenzap -lm -lpthread

testcid: $(SRC)/testcid.c $(MYLIB)
	$(CC) $(INCS) -L. -g -ggdb $(SRC)/testcid.c -o testcid -lopenzap -lm -lpthread

testtones: $(SRC)/testtones.c $(MYLIB)
	$(CC) $(INCS) -L. $(SRC)/testtones.c -o testtones -lopenzap -lm -lpthread

testisdn: $(SRC)/testisdn.c $(MYLIB)
	$(CC) $(INCS) $(ZAP_CFLAGS) -L. $(SRC)/testisdn.c -o testisdn -lopenzap -lm -lpthread

testanalog: $(SRC)/testanalog.c $(MYLIB)
	$(CC) $(INCS) -L. $(SRC)/testanalog.c -o testanalog -lopenzap -lm -lpthread

$(SRC)/priserver.o: $(SRC)/priserver.c
	$(CC) $(INCS) $(TMP) -c $(SRC)/priserver.c -o $(SRC)/priserver.o 

$(SRC)/sangoma_pri.o: $(SRC)/sangoma_pri.c
	$(CC) $(INCS) $(TMP) -c $(SRC)/sangoma_pri.c -o $(SRC)/sangoma_pri.o

$(LIBPRI)/$(LIBPRIA):
	cd libpri && make

priserver: $(MYLIB) $(SRC)/priserver.o $(SRC)/sangoma_pri.o $(LIBPRI)/$(LIBPRIA)
	$(CC) $(SRC)/sangoma_pri.o $(SRC)/priserver.o -L. -o priserver -lopenzap -lm -lpthread $(LIBPRI)/$(LIBPRIA)

$(SRC)/zap_io.o: $(SRC)/zap_io.c
	$(CC) $(MOD_CFLAGS) $(CC_CFLAGS) $(CFLAGS) -c $< -o $@

%.o: %.c $(HEADERS)
	$(CC) $(CC_CFLAGS) $(CFLAGS) -c $< -o $@

dox:
	cd docs && doxygen $(PWD)/docs/Doxygen.conf

mod_openzap/mod_openzap.so: $(MYLIB) mod_openzap/mod_openzap.c
	cd mod_openzap && make

mod_openzap: mod_openzap/mod_openzap.so

mod_openzap-install: mod_openzap
	cd mod_openzap && make install

mod_openzap-clean:
	@if [ -f mod_openzap/mod_openzap.so ] ; then cd mod_openzap && make clean ; fi

clean: mod_openzap-clean
	rm -f $(SRC)/*.o $(SRC)/isdn/*.o $(MYLIB) *~ \#* testapp testcid testtones priserver testisdn testanalog
	@if [ -f $(LIBPRI)/$(LIBPRIA) ] ; then cd $(LIBPRI) && make clean ; fi


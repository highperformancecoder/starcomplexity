# root directory for ecolab include files and libraries
ECOLAB_HOME=$(shell pwd)/ecolab
export LD_LIBRARY_PATH:=$(ECOLAB_HOME)/lib:$(LD_LIBRARY_PATH)

export OPENMP
export DPCPP
export DEBUG
export OPT

ifneq ($(MAKECMDGOALS),clean)
# make sure EcoLab is built first, even before starting to include Makefiles
# disable AEGIS build here, as EcoLab 6 is still a little raw
build_ecolab:=$(shell cd ecolab; if $(MAKE) $(MAKEOVERRIDES) AEGIS= $(JOBS) only-libs >build.log 2>&1; then echo "ecolab built"; fi)

$(warning $(build_ecolab))
ifneq ($(build_ecolab),ecolab built)
$(warning $(shell cat ecolab/build.log))
$(error Making ecolab failed: check ecolab/build.log)
endif
endif

include $(ECOLAB_HOME)/include/Makefile

ifdef DPCPP
# GPU may not have double precision support
FLAGS+=-DUSE_FLOAT
endif

FLAGS+=-Iabc/src -DABC_USE_STDINT_H -DABC_NAMESPACE=abc

MODELS=starComplexity

all: $(MODELS:=.so)

# This rule uses a header file of object descriptors
$(MODELS:=.o): %.o: %.cc 

# how to build a model
$(MODELS:=.so): %.so: %.o $(ECOLAB_HOME)/lib/libecolab$(ECOLIBS_EXT).a abc/libabc.a
	$(LINK) $(FLAGS) -shared -Wl,-rpath $(ECOLAB_HOME)/lib $*.o $(LIBS) abc/libabc.a -o $@

abc/libabc.a:
	env CC=$(CPLUSPLUS) $(MAKE) -C abc ABC_USE_PIC=1 ABC_NAMESPACE=abc libabc.a

# required because gcc builds do not inlcude vecBitSet.h
starComplexity.o: vecBitSet.cd

ifneq ($(MAKECMDGOALS),clean)
include $(MODELS:=.d)
endif

clean:
	$(BASIC_CLEAN)
	rm -f $(MODELS) *.cd


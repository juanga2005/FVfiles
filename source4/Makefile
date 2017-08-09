#
#	General Makefile for the 3D ADI Advec-diff problem
#
#
export PATHLINPACK= './LINPACK_lib'
export PATHCLAW3= './claw3_lib'
export PATHDIFF3= './ADIdiff3_lib'
export PATHMAIN= './main'

all:	

	$(MAKE) $(MFLAGS) -C ./thrd41 all
	$(MAKE) $(MFLAGS) -C ./thrd42 all
	$(MAKE) $(MFLAGS) -C ./thrd43 all
	$(MAKE) $(MFLAGS) -C ./thrd44 all
clean:

	$(MAKE) -C ./thrd41 clean
	$(MAKE) -C ./thrd42 clean
	$(MAKE) -C ./thrd43 clean
	$(MAKE) -C ./thrd44 clean

### DO NOT remove this line - make depends on it ### 
#
#	General Makefile for the 3D ADI Advec-diff problem
#
#
export PATHLINPACK= './LINPACK_lib'
export PATHCLAW3= './claw3_lib'
export PATHDIFF3= './ADIdiff3_lib'
export PATHMAIN= './main'

all:	

	$(MAKE) $(MFLAGS) -C ./source1 all
	$(MAKE) $(MFLAGS) -C ./source2 all
	$(MAKE) $(MFLAGS) -C ./source3 all
	$(MAKE) $(MFLAGS) -C ./source4 all

clean:

	$(MAKE) -C ./source1 clean
	$(MAKE) -C ./source2 clean
	$(MAKE) -C ./source3 clean
	$(MAKE) -C ./source4 clean

### DO NOT remove this line - make depends on it ### 
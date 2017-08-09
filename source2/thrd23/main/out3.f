c
c
c =========================================================
      subroutine out3(maxmx,maxmy,maxmz,meqn,mbc,mx,my,mz,
     &                 xlower,ylower,zlower,dx,dy,dz,q,t,iframe,
     &                 aux,maux,depo, nprocess)
c =========================================================
c
c     # Output the results for a general system of conservation laws
c     # in 3 dimensions
c
c     # Write the results to the file fort.q<iframe>
c     # Use format required by matlab script  plotclaw3.m
c     # The same format is used by the amrclaw package.
c     # Here it's adapted to output just the single grid.
c
c     # set outaux = .true. to also output the aux arrays to fort.a<iframe>
c
      implicit double precision (a-h,o-z)
      dimension    q(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &               1-mbc:maxmz+mbc, meqn)
      dimension  aux(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &               1-mbc:maxmz+mbc, maux)
c
c     ##############################################
c     Ground deposition
c     ##############################################
c
      
      dimension depo(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc)
c
c
c     depo: is a two dimensional matrix holding value of 
c           ground deposition
c
c     ##############################################
c
      character*23 fname1, fname2, fname3, fname4
      logical outaux
c      integer nprocess, t

      outaux = .true.
c
c
c     # first create the file name and open file
c
         fname1 = './solution/fort.qxxxx'
c         fname2 = './solution/fort.txxxx'
c         fname3 = './solution/fort.axxxx'
         fname4 = './solution/f.dxxxxs2xxx'
         nstp = iframe
         do 55 ipos = 18, 15, -1
            idigit = mod(nstp,10)
            fname1(ipos:ipos) = char(ichar('0') + idigit)
c            fname2(ipos:ipos) = char(ichar('0') + idigit)
c            fname3(ipos:ipos) = char(ichar('0') + idigit)
            fname4(ipos:ipos) = char(ichar('0') + idigit)
            nstp = nstp / 10
 55      continue

         nthrd= nprocess
c         write(*,*) nprocess
c         read(*,*)

         do 56 ipos = 23, 21, -1
            idigit = mod(nthrd,10)
c            fname1(ipos:ipos) = char(ichar('0') + idigit)
c            fname2(ipos:ipos) = char(ichar('0') + idigit)
c            fname3(ipos:ipos) = char(ichar('0') + idigit)
            fname4(ipos:ipos) = char(ichar('0') + idigit)
            nthrd = nthrd / 10
 56      continue

         open(unit=50,file=fname1,status='unknown',form='formatted')
c         open(unit=60,file=fname2,status='unknown',form='formatted')
         open(unit=80,file=fname4,status='unknown',form='formatted')

c
c     # the following parameters are used in amrclaw where there are
c     # multiple grids.  Here they are all set to 1:
      ngrids = 1
      mptr = 1
      level = 1

c      write(50,1001) mptr,level,mx,my,mz
c 1001 format(i5,'                 grid_number',/,
c     &       i5,'                 AMR_level',/,
c     &       i5,'                 mx',/,
c     &       i5,'                 my',/,
c     &       i5,'                 mz')

c      write(50,1002) xlower,ylower,zlower,dx,dy,dz
c 1002 format(e26.16,'    xlow', /,
c     &       e26.16,'    ylow', /,
c     &       e26.16,'    zlow', /,
c     &       e26.16,'    dx', /,
c     &       e26.16,'    dy', /,
c     &       e26.16,'    dz',/)
c
      do 30 k=1,mz
         do 20 j=1,my
            do 10 i=1,mx
               do m=1,meqn
c                 # exponents with more than 2 digits cause problems reading
c                 # into matlab... reset tiny values to zero:
                  if (dabs(q(i,j,k,m)) .lt. 1d-99) q(i,j,k,m) = 0.d0
               enddo

               write(50,1005) (q(i,j,k,m), m=1,meqn)
 1005          format(5e26.16)

   10       continue
            write(50,*) ' '
   20    continue
         write(50,*) ' '
   30 continue
      write(50,*) ' '

c      if (outaux) then 
c     # also output the aux arrays:
c      open(unit=70,file=fname3,status='unknown',form='formatted')
c      write(70,1001) mptr,level,mx,my,mz
c      write(70,1002) xlower,ylower,zlower,dx,dy,dz
c      do 130 k=1-mbc,mz+mbc
c         do 120 j=1-mbc,my+mbc
c            do 110 i=1-mbc,mx+mbc
c               do m=1,maux
c                 # exponents with more than 2 digits cause problems reading
c                 # into matlab... reset tiny values to zero:
c                  if (dabs(aux(i,j,k,m)) .lt. 1d-99) aux(i,j,k,m) = 0.d0
c               enddo
c
c               write(70,1005) (aux(i,j,k,m), m=1,maux)
c
c  110       continue
c            write(70,*) ' '
c  120    continue
c         write(70,*) ' '
c  130 continue
c      write(70,*) ' '
c      close(unit=70)
c      endif

c      write(60,1000) t,meqn,ngrids,maux

c 1000 format(e26.16,'    time', /,
c     &       i5,'                 meqn'/,
c     &       i5,'                 ngrids'/,
c     &       i5,'                 maux'/,/)
c

c     write ground deposition to file
c
      do 21 j=1,my
          do 11 i=1,mx
cc           # exponents with more than 2 digits cause problems reading
c            # into matlab... reset tiny values to zero:
               if (dabs(depo(i,j)) .lt. 1d-99) depo(i,j) = 0.d0
               write(80,1006) (depo(i,j))
 1006          format(5e26.16)
c
   11     continue
          write(80,*) ' '
   21 continue
      write(80,*) ' '

      close(unit=50)
c      close(unit=60)
      close(unit=80)

      return
      end

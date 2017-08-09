      program openMPdriver

      implicit double precision (a-h,o-z)

      include 'omp_lib.h'
     
c     size of computer design 
      parameter (mdesignsize = 64)

      dimension alphashearvec(mdesignsize)
      dimension alphaxvec(mdesignsize)
      dimension alphayvec(mdesignsize)
      dimension alphazvec(mdesignsize)
      dimension diffLvec(mdesignsize)
      dimension ucutoffvec(mdesignsize)
      dimension z_0vec(mdesignsize)


      real, dimension(2)::  tarray
      real :: result
      integer id


c      read design parameters 
        open(unit=7,file='../../alphashear.dat',status='old',
     &                   form='formatted')
        open(unit=8,file='../../alphax.dat',status='old',
     &                   form='formatted')
        open(unit=9,file='../../alphay.dat',status='old',
     &                   form='formatted')
        open(unit=10,file='../../alphaz.dat',status='old',
     &                   form='formatted')
        open(unit=11,file='../../diffL.dat',status='old',
     &                   form='formatted')
        open(unit=12,file='../../u_cutoff.dat',status='old',
     &                   form='formatted')
        open(unit=13,file='../../z_0.dat',status='old',
     &                   form='formatted')
        do 31 i=1, mdesignsize
            read(7,*) alphashearvec(i)
            read(8,*) alphaxvec(i)
            read(9,*) alphayvec(i)
            read(10,*) alphazvec(i)
            read(11,*) diffLvec(i)
            read(12,*) ucutoffvec(i)
            read(13,*) z_0vec(i)
 31      continue

        close (unit=7) !finished reading designs 
        close (unit=8)
        close (unit=9)
        close (unit=10)
        close (unit=11)
        close (unit=12)
        close (unit=13)

c        call dtime(tarray, result)

        do 193 j=1, 1

           write(*,*) 'design: ', j
           write(*,*) alphashearvec(j)
           write(*,*) alphaxvec(j)
           write(*,*) alphayvec(j)
           write(*,*)  alphazvec(j)
           write(*,*) diffLvec(j)
           write(*,*) ucutoffvec(j)
           write(*,*) z_0vec(j)
c           read(*,*)

          call driver( alphashearvec(j), alphaxvec(j),
     &     alphayvec(j), alphazvec(j), diffLvec(j), ucutoffvec(j),
     &     z_0vec(j), j )

c     alphashearV = 0.3
c           alphaXV = 0.1108
c           alphaYV = 0.1108
c           alphaZV = 0.1141
c           alphaXV = .62
c           alphaYV = .62
c           alphaZV = .078
c           diffLV = -8 
c           ucutoffV = 2.0
c           z_0V = 0.1

c          call driver( alphashearV, alphaXV,
c     &     alphaYV, alphaZV, diffLV, ucutoffV,
c     &     z_0V, 1 )

c          call dtime(tarray, result)
c          write(*,*) result/60
c          read(*,*)
 193   continue 
        stop
        end

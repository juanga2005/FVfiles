     
c     
c     this is a subroutine to read the setprob.data file and
c     store parameter values in common blocks for various
c     features added to CLAWPACK.
c
c     Vertical wind correction, Vertical Eddy diffusivity correction
c     nad other parameter values are read here.


      subroutine setprob( alphashearval, alphaXval, alphaYval,
     & alphaZval, diffLval, ucutoffval, z_0val )

      implicit double precision (a-h,o-z)
      common /comrp/ ubar,vbar, wbar
      common /diffslv3/ z_0, z_low, alphax, alphay, alphaz, 
     &                  diffL, k_zz_option, alphaxbar, alphaybar,
     &  alphazbar
      common /diffbound/ moptionx, moptiony, moptionz
      common /diffrobin/ W_dep, W_cor, u_set 
      common /srctrm/ G, posx, posy, posz, n_src
      common /winddata/ windvel, winddir, windtime, readwindfromfile,
     &                  verticalcorrection, alphashear, maxwind, 
     & u_cutoff                 

      integer moptionx, moptiony, moptionz, n_src
      integer k_zz_option
      dimension moptionx(2)
      dimension moptiony(2)
      dimension moptionz(2)
      dimension G(10)
      dimension posx(10)
      dimension posy(10)
      dimension posz(10)
c     change these so that variable sized data can be read
      dimension windvel(6000)
      dimension winddir(6000)
      dimension windtime(6000)
      integer readwindfromfile, maxwind, verticalcorrection
c
c     # Set the velocity for scalar advection
c     # These values are passed to the Riemann solvers rpn2.f and rpt2.f
c     # in a common block
c

      open(unit=7,file='../setprob.data',status='old',
     &                   form='formatted')
      read(7,*) ubar
      read(7,*) vbar
      read(7,*) wbar ! initial wind speeds
      read(7,*) readwindfromfile ! read wind from file?
      read(7,*) maxwind ! maximum number of entries in wind data
      read(7,*) verticalcorrection ! do we want vertical wind speed profile correction?
      read(7,*) u_cutoff ! cut off height of velocity profile
      read(7,*) u_set           ! settling velocity (only used with variable wind)
      read(7,*) alphashear ! alpha parameter for correction
      read(7,*) alphax 
      read(7,*) alphay
      read(7,*) alphaz ! diffusion coefficients
      read(7,*) k_zz_option ! use vertical eddy diffusivity correction?
      read(7,*) z_0 ! parameter for k_zz correction
      read(7,*) z_low ! height of constant k_zz layer at ground
      read(7,*) diffL ! stability parameter L 
      read(7,*) moptionx(1)
      read(7,*) moptionx(2)
      read(7,*) moptiony(1)
      read(7,*) moptiony(2)
      read(7,*) moptionz(1)
      read(7,*) moptionz(2) ! diffusion boundary conditions
      read(7,*) W_dep ! ground deposition coefficient
      read(7,*) n_src ! number of sources (up to 10)
      do 10 i=1, n_src
        read(7,*) G(i) ! source intensity
        read(7,*) posx(i) 
        read(7,*) posy(i)
        read(7,*) posz(i) ! position of sources
   10 continue

      close (unit=7)
c      write(*,*) '***in set prob***'
c      write(*,*) 'alphax= ', alphax
c      write(*,*) 'alphay= ', alphay
c      write(*,*) 'alphaz= ', alphaz

c      alphaxbar = alphax
c      alphaybar = alphay
c      alphazbar = alphaz

c     pass values that are sent to the driver from the experiment
c     design
      alphaxbar = alphaXval
      alphaybar = alphaYval
      alphazbar = alphaZval
      alphashear = alphashearval
      z_0 = Z_0val
      diffL = diffLval
      ucutoff = ucutoffval

      if (readwindfromfile .eq. 0) then
        write(*,*) 'Constant wind, press enter to continue'
      else if (readwindfromfile .eq. 1) then
        write(*,*) 'Reading wind data from file'
c       read wind time data
        open(unit=7,file='../../windtime.dat',status='old',
     &                   form='formatted')
        do 20 i=1, maxwind
            read(7,*) windtime(i)
   20   continue

        close (unit=7) !finished reading wind time data

c       read wind direction data
        open(unit=7,file='../../winddir.dat',status='old',
     &                   form='formatted')
        do 30 i=1, maxwind
            read(7,*) winddir(i)
   30   continue

        close (unit=7) !finished reading wind direction data

c       read wind speed
        open(unit=7,file='../../windvel.dat',status='old',
     &                   form='formatted')
        do 40 i=1, maxwind
            read(7,*) windvel(i)
   40   continue

        close (unit=7)!finished reading wind velocity data

      else
        write(*,*) 'ADIdiff: Problem in setprob.data'
        read(*,*)
      endif

      write(*,*) 'in set prob: '
c      read(*,*)

      return
      end

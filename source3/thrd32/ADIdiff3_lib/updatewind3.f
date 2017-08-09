c
c     subroutine for updating wind data in each time step
c
      subroutine updatewind3 (maxmx, maxmy, maxmz
     &                       , mbc, mx, my, mz, maux, aux)

      implicit double precision (a-h,o-z)

      dimension  aux(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &               1-mbc:maxmz+mbc, maux)
c
c     ##################################################
c     wind data common block
c     ##################################################
      common /winddata/ windvel, winddir, windtime, readwindfromfile,
     &                  verticalcorrection, alphashear, maxwind,
     & u_cutoff 

      dimension windvel(6000)
      dimension winddir(6000)
      dimension windtime(6000)
      ! notice the constant size of these arrays !
      integer readwindfromfile, maxwind, verticalcorrection

c
c     ##################################################
c
      common /diffslv3/ z_0, z_low, alphax, alphay, alphaz, 
     &                  diffL, k_zz_option, alphaxbar, alphaybar,
     & alphazbar

      common /diffrobin/ W_dep, W_cor, u_set

c
c     ##################################################
c     comxyzt block from claw3.f
c     ##################################################

      common /comxyzt/ dtcom,dxcom,dycom,dzcom,tcom,icom,jcom,kcom
c
c     ##################################################
c

c      write(*,*) 'in wind update: ', u_set
c      read(*,*)

c     find index of wind data needed at this time
      do 10 l=1, maxwind-1

        if ( (tcom .ge. windtime(l)) .and.
     &       (tcom .lt. windtime(l+1)) ) then
c       calculate x and y components of new wind speed
            ubar = (+1)*windvel(l)*sin(winddir(l) - 3.14)
            vbar = (+1)*windvel(l)*cos(winddir(l) - 3.14)
            wbar = u_set !no vertical velocity
	write(*,*) 'dir:= ', winddir(l)
c	read(*,*)
c

c       We also need to update reference diffusion coefficients 
c       as they all change linearly with the velocity
        alphax = alphaxbar*sqrt(ubar*ubar + vbar*vbar)
        alphay = alphaybar*sqrt(ubar*ubar + vbar*vbar)
        alphaz = alphazbar*sqrt(ubar*ubar + vbar*vbar)

c       update aux values
c
            if (verticalcorrection .eq. 0) then
c
c       use no vertical profile correction for vertical wind profile
c
                do  k = 1-mbc,mz+mbc
                    do j = 1-mbc,my+mbc
                        do i = 1-mbc,mx+mbc
                            aux(i,j,k,1) = ubar
                            aux(i,j,k,2) = vbar
                            aux(i,j,k,3) = wbar
                        enddo
                    enddo
                enddo
c       done updating values, exit loop
                goto 999

            else if (verticalcorrection .eq. 1) then
c
c       use powerlaw for vertical shear profile
c
                do  k = 1-mbc,mz+mbc
                    z = dzcom*k-0.5*dzcom
                    if (z .lt. u_cutoff) then
                        z = u_cutoff
                    endif
                    wmult = (z/10.0)**alphashear

                    do j = 1-mbc,my+mbc
                        do i = 1-mbc,mx+mbc
                            aux(i,j,k,1) = ubar*wmult
                            aux(i,j,k,2) = vbar*wmult
                            aux(i,j,k,3) = wbar
                        enddo
                    enddo
                enddo
c       done updating values, exit loop
                goto 999

            else if (verticalcorrection .eq. 2) then
c
c       use logarithmic vertical shear profile
c       #####################################
c       this is not complete yet
c       ###################################
c
                do  k = 1-mbc,mz+mbc
                    do j = 1-mbc,my+mbc
                        do i = 1-mbc,mx+mbc
                            aux(i,j,k,1) = ubar
                            aux(i,j,k,2) = vbar
                            aux(i,j,k,3) = wbar
                        enddo
                    enddo
                enddo
c       done updating values, exit loop
                goto 999

            else
c
c       problem with input, print error
c
                write(*,*) 'UPDATEWIND3: Input problem'
                read(*,*)
            endif

        endif

   10 continue
  999 continue
      end

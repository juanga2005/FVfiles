c     ==================================================================
      subroutine setaux(maxmx,maxmy,maxmz,mbc,mx,my,mz,xlower,ylower,
     &                  zlower,dx,dy,dz,maux,aux)
c     ==================================================================
c
c     # set auxiliary arrays
c
c     # advection
c     #    aux(i,j,k,1) is u velocity on left face of cell
c     #    aux(i,j,k,2) is v velocity on bottom face of cell
c     #    aux(i,j,k,3) is w velocity on back face of cell
c
c
      implicit none

      integer maxmx, maxmy, maxmz, mx, my, mz, mbc, maux, i,j,k
      double precision xlower, ylower, zlower, dx, dy, dz,
     &      pi, pi2, dx2, dy2, dz2, compute_u, compute_v, compute_w
      double precision aux(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &               1-mbc:maxmz+mbc, maux)
      double precision xc(1-mbc:maxmx+mbc)
      double precision yc(1-mbc:maxmy+mbc)
      double precision zc(1-mbc:maxmz+mbc)

      common /piconstants/ pi, pi2
      double precision ubar, vbar, wbar
      common /comrp/ ubar,vbar, wbar

      pi = 4.d0*atan(1.d0)
      pi2 = 2.d0*pi

c

      do i = 1-mbc,mx+mbc
         xc(i) = xlower + (i-0.5d0)*dx
      enddo

      do j = 1-mbc,my+mbc
         yc(j) = ylower + (j-0.5d0)*dy
      enddo

      do k = 1-mbc,mz+mbc
         zc(k) = zlower + (k-0.5d0)*dz
      enddo

      dx2 = 0.5d0*dx
      dy2 = 0.5d0*dy
      dz2 = 0.5d0*dz
      do  k = 1-mbc,mz+mbc
	  do j = 1-mbc,my+mbc
	    do i = 1-mbc,mx+mbc
               aux(i,j,k,1) = ubar
               aux(i,j,k,2) = vbar
               aux(i,j,k,3) = wbar
         enddo
      enddo
      enddo

      return
      end
c     
c     these functions are not used for the atmospheric problem
c 
      double precision function compute_u(x,y,z)
      implicit none
      double precision x,y,z,pi, pi2

      common /piconstants/ pi, pi2

      compute_u = 2.d0 * dsin(pi*x)**2 * dsin(pi2*y) * dsin(pi2*z)
      end

      double precision function compute_v(x,y,z)
      implicit none
      double precision x,y,z,pi, pi2

      common /piconstants/ pi, pi2

      compute_v = -dsin(pi2*x) * dsin(pi*y)**2 * dsin(pi2*z)
      end

      double precision function compute_w(x,y,z)
      implicit none
      double precision x,y,z,pi, pi2

      common /piconstants/ pi, pi2

      compute_w = -dsin(pi2*x) * dsin(pi2*y) * dsin(pi*z)**2
      end

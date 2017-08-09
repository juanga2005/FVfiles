
c
c     this subroutine can be used for setting all kinds of 
c     initial conditions, at this moment it sets all values
c     to zero.
c
c     =====================================================
       subroutine qinit(maxmx,maxmy,maxmz,meqn,mbc,mx,my,mz,
     &                   xlower,ylower,zlower,dx,dy,dz,q,maux,aux)
c     =====================================================
c
c     # Set initial conditions for q.
c
       implicit double precision (a-h,o-z)
c
       dimension q(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &             1-mbc:maxmz+mbc, meqn)
       dimension x(1-mbc:maxmx+mbc)
       dimension y(1-mbc:maxmy+mbc)
       dimension z(1-mbc:maxmz+mbc)
       dimension aux(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &       1-mbc:maxmz+mbc, maux)
c
c     # set concentration profile
c     ---------------------------
c

       pi = 3.141592653;
       do i = 1-mbc,mx+mbc
          x(i) = xlower + (i-0.5d0)*dx
       enddo
       do j = 1-mbc,my+mbc
          y(j) = ylower + (j-0.5d0)*dy
       enddo
       do k = 1-mbc,mz+mbc
          z(k) = zlower + (k-0.5d0)*dz
       enddo
       do 20 i = 1,mx
        do 21 j=1, my
         do 22 k=1, mz
                q(i,j,k,1) = 0.0
           
   22    continue
   21   continue
   20  continue

      return
      end

c
c      =======================================================
       subroutine src3(maxmx,maxmy,maxmz,meqn,mbc,mx,my,mz,
     &                 xlower,ylower,zlower,dx,dy,dz,q,maux,aux,t,dt)
c      =======================================================
c
       implicit double precision (a-h,o-z)
       dimension    q(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc, 
     &               1-mbc:maxmz+mbc, meqn)

      common /srctrm/ G, posx, posy, posz, n_src
      integer n_src
      dimension G(10)
      dimension posx(10)
      dimension posy(10)
      dimension posz(10)

c     subroutine for implementing point sources in adv-diff
c     resembling pollution outputs

      do 10 m=1, n_src
c       find position of lower faces intersecting the 
c       support of delta source term
        i = abs(floor((posx(m)+dx/2-xlower)/dx))
        j = abs(floor((posy(m)+dy/2-ylower)/dy))
        l = abs(floor((posz(m)+dz/2-zlower)/dz))
        
        centx = xlower + i*dx
        centy = ylower + j*dy
        centz = zlower + l*dz
c        write(*,*) 'center = ', centx, centy, centz
c       

c       loop over all equations in the system
        do 40 k=1, meqn
           totvol = 0
c        write(*,*) 'source: ', m, G(m)
c        write(*,*) posx(m), posy(m), posz(m)
c        write(*,*) xlower + (i)*dx, ylower+ (j)*dy, zlower+(l)*dz
c        read(*,*)
c       find vertices of the support cube
c       there are 8 of these guys
        
        do 15 nindx_x=-1, 1, 2
           do 25 nindx_y = -1, 1, 2
              do 35 nindx_z = -1 , 1, 2
                 
                 vertx = posx(m) + nindx_x*dx/2 - centx
                 verty = posy(m) + nindx_y*dy/2 - centy
                 vertz = posz(m) + nindx_z*dz/2 - centz
c                 write(*,*)
c                 write(*,*) dx, dy, dz
c                 write(*,*) posx(m) + nindx_x*dx/2,
c     & posy(m) + nindx_y*dy/2, posz(m) + nindx_z*dz/2
c                 write(*,*) vertx, verty, vertz
c                 read(*,*)
c       volume of intersect of support of delta source is 
c       volume of the cube having a vertex on (centx, centy, centz)
c       and the other at (vertx, verty, vertz)
                 
c       compute ratio of volume to entire volume of a cell
                 volratio = abs(vertx*verty*vertz)/(dx*dy*dz)
                 totvol = totvol + volratio
c                 write(*,*) 'ratio= ', volratio
c                 read(*,*)
c       find index of cell to inject the portion of source
                 ii = i + (-1 + indx_x)/2
                 jj = j + (-1 + indx_y)/2
                 ll = l + (-1 + indx_z)/2

                 q(ii, jj,ll,k) = q(ii,jj,ll,k) + 
     &                          volratio*(G(m)/(dx*dy*dz))*dt
                 
   35         continue
   25      continue
   15   continue
     
c        write(*,*) 'update done, total vol =',totvol
c        read(*,*)

c       

c                q(i,j,l,k) = q(i,j,l,k) + (G(m)/(dx*dy*dz))*dt

   40   continue
   10 continue

       return
       end

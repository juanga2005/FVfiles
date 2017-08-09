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

      pi = 3.14159265359
      do 10 m=1, n_src
c       h is half the width of support of the cos source

        h = 1
        upfacex = posx(m) + h
        dfacex = posx(m) - h
        upfacey = posy(m) + h
        dfacey = posy(m) - h
        upfacez = posz(m) + h
        dfacez = posz(m) - h

        iup = abs(floor((upfacex-xlower)/dx))
        jup = abs(floor((upfacey-ylower)/dy))
        lup = abs(floor((upfacez-zlower)/dz))

        idown = abs(floor((dfacex-xlower)/dx))
        jdown = abs(floor((dfacey-ylower)/dy))
        ldown = abs(floor((dfacez-zlower)/dz))

c       loop over all equations in the system
        do 40 k=1, meqn
           do 15 i = idown, iup
              do 25 j = jdown, jup
                 do 35 l = ldown, lup
c                loop over vertices of the current cube cell
c                
                    do 155 indx = 0, 1
                       do 255 indy = 0, 1
                          do 355 indz = 0, 1
                             vx = (i+indx)*dx + xlower
                             vy = (j + indy)*dy + ylower
                             vz = (l + indz)*dz + zlower
c                             write(*,*) 'upper: '
c                             write(*,*) upfacex, upfacey, upfacez
c                             write(*,*) 'facepos:'
c                             write(*,*) vx, vy, vz
c                             write(*,*) 'lower: '

c                             write(*,*) dfacex, dfacey, dfacez
c                             read(*,*)
                             
                   if ( (vx .gt. dfacex) .and. (vx .lt. upfacex) ) then
                   if ( (vy .gt. dfacey) .and. (vy .lt. upfacey) ) then
                   if ( (vz .gt. dfacez) .and. (vz .lt. upfacez) ) then
                      
                      vvx = posx(m) - vx
                      vvy = posy(m) - vy
                      vvz = posz(m) - vz
                           
                           vinj = 1.0/8*G(m)*dt*
     &                 (1/(8*h*h*h))*(1+ cos( pi*vvx/(h)))       
     &                     *(1 + cos( pi*vvy/(h)))*(1+ cos( pi*vvz/(h)))
                           q(i,j,l,k) = q(i,j,l,k) + vinj
                           vtotinj = vtotinj + vinj

c                           write(*,*) 'inject: ', vinj
c                           write(*,*) 'pi: ', pi
c                           write(*,*) (1/(8*h*h*h))*cos( pi*vvx/(2*h))*
c     &          cos( pi*vvz/(2*h))*cos( pi*vvz/(2*h))*(dx*dy*dz)*dt*G(m)
c                           read(*,*)

                        endif
                        endif
                        endif
                             
                             
  355                     continue
  255                  continue
  155               continue
c                    write(*,*) 'done', i, j, l, vtotinj, totinj
c                    read(*,*)

                    totinj = totinj + vtotinj
                    vtotinj = 0
                    
c
c                done updating for this cell
                    
   35            continue
   25         continue
   15      continue
c           write(*,*) 'inj comp'
c           read(*,*)

c                 q(ii, jj,ll,k) = q(ii,jj,ll,k) + 
c     &                          volratio*(G(m)/(dx*dy*dz))*dt


   40   continue
   10 continue
      write(*,*) 'total output= ', totinj/dt*(dx*dy*dz), dx
c      read(*,*)
       return
       end

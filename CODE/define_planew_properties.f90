subroutine define_planew_properties (Tdomain)

! Modified by Elise Delavaud 17/06/05

use sdomain
implicit none

type(Domain), intent (INOUT) :: Tdomain

integer :: ngll,ngll1,ngll2,mat_index,nf,ne,nv

open (24,file=Tdomain%super_object_file,status="old", form="formatted")
read (24,*) 
read (24,*) mat_index
read (24,*) Tdomain%sPlaneW%pParam%wtype
read (24,*) Tdomain%sPlaneW%pParam%lx
read (24,*) Tdomain%sPlaneW%pParam%ly
read (24,*) Tdomain%sPlaneW%pParam%lz
read (24,*) Tdomain%sPlaneW%pParam%xs
read (24,*) Tdomain%sPlaneW%pParam%ys
read (24,*) Tdomain%sPlaneW%pParam%zs
read (24,*) Tdomain%sPlaneW%pParam%f0
close(24)
!stop
do nf = 0, Tdomain%sPlaneW%n_faces-1
  ngll1 = Tdomain%sPlaneW%pFace(nf)%ngll1
  ngll2 = Tdomain%sPlaneW%pFace(nf)%ngll2
  Tdomain%sPlaneW%pFace(nf)%mat_index = mat_index  
  allocate (Tdomain%sPlaneW%pFace(nf)%Btn(0:ngll1-1,0:ngll2-1,0:2))
  allocate (Tdomain%sPlaneW%pFace(nf)%MassMat_Up(1:ngll1-2,1:ngll2-2))
  allocate (Tdomain%sPlaneW%pFace(nf)%MassMat_Down(1:ngll1-2,1:ngll2-2))
  allocate (Tdomain%sPlaneW%pFace(nf)%Forces_Up(1:ngll1-2,1:ngll2-2,0:2))
  allocate (Tdomain%sPlaneW%pFace(nf)%Forces_Down(1:ngll1-2,1:ngll2-2,0:2))
enddo

do ne = 0, Tdomain%sPlaneW%n_edges-1
  ngll = Tdomain%sPlaneW%pEdge(ne)%ngll
  Tdomain%sPlaneW%pEdge(ne)%mat_index =  mat_index
  allocate (Tdomain%sPlaneW%pEdge(ne)%Btn(1:ngll-2,0:2))
  allocate (Tdomain%sPlaneW%pEdge(ne)%MassMat_Up(1:ngll-2))
  allocate (Tdomain%sPlaneW%pEdge(ne)%MassMat_Down(1:ngll-2))
  allocate (Tdomain%sPlaneW%pEdge(ne)%Forces_Up(1:ngll-2,0:2))
  allocate (Tdomain%sPlaneW%pEdge(ne)%Forces_Down(1:ngll-2,0:2))
  Tdomain%sPlaneW%pEdge(ne)%Btn = 0
enddo

do nv = 0, Tdomain%sPlaneW%n_vertices-1
  Tdomain%sPlaneW%pVertex(nv)%mat_index =  mat_index 
  Tdomain%sPlaneW%pVertex(nv)%Btn = 0
enddo
!stop

Tdomain%sPlaneW%pParam%Lambda = Tdomain%sSubDomain(mat_index)%DLambda
Tdomain%sPlaneW%pParam%Mu = Tdomain%sSubDomain(mat_index)%DMu

if (Tdomain%sPlaneW%pParam%wtype == 'S') then
   Tdomain%sPlaneW%pParam%speed = Tdomain%sSubDomain(mat_index)%Sspeed
else
   Tdomain%sPlaneW%pParam%speed = Tdomain%sSubDomain(mat_index)%Pspeed
endif

print*,"PW Speed",Tdomain%sPlaneW%pParam%speed

return
end subroutine define_planew_properties

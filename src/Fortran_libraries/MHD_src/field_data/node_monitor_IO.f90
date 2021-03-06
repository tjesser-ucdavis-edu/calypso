!
!      module node_monitor_IO
!
!        programmed by H.Matsui and H.Okuda
!                                    on July 2000 (ver 1.1)
!        Modified by H. Matsui on Aug., 2007
!
!      subroutine allocate_monitor_group
!      subroutine allocate_monitor_local
!      subroutine deallocate_monitor_local
!
!      subroutine set_local_node_id_4_monitor(nod_grp)
!      subroutine output_monitor_control
!      subroutine skip_monitor_data
!
      module node_monitor_IO
!
      use m_precision
!
      use m_control_parameter
!
      implicit none
!
      integer(kind=kint), parameter :: id_monitor_file = 47
      character(len=kchara), parameter :: node_monitor_head = 'node'
!
      integer (kind=kint) :: num_monitor
      character (len=kchara), allocatable :: monitor_grp(:)
!
      integer (kind=kint) :: num_monitor_local
      integer (kind=kint), allocatable :: monitor_local(:)
!
      integer (kind = kint) :: num_field_monitor
      integer (kind = kint) :: ntot_comp_monitor
      integer (kind = kint), allocatable :: num_comp_phys_monitor(:)
      character (len = kchara), allocatable :: phys_name_monitor(:)
!
      private :: id_monitor_file, node_monitor_head
      private :: num_monitor_local, monitor_local
      private :: num_comp_phys_monitor, phys_name_monitor
      private :: allocate_monitor_local
      private :: open_node_monitor_file
!
!  ---------------------------------------------------------------------
!
      contains
!
!  ---------------------------------------------------------------------
!
      subroutine allocate_monitor_group
!
!
      allocate( monitor_grp(num_monitor) )
!
      end subroutine allocate_monitor_group
!
!  ---------------------------------------------------------------------
!
      subroutine allocate_monitor_local
!
!
      allocate( monitor_local(num_monitor_local) )
      if(num_monitor_local .gt. 0) monitor_local = 0
!
      end subroutine allocate_monitor_local
!
!  ---------------------------------------------------------------------
!
      subroutine deallocate_monitor_local
!
!
      deallocate(monitor_grp, monitor_local)
!
      end subroutine deallocate_monitor_local
!
!  ---------------------------------------------------------------------
!  ---------------------------------------------------------------------
!
      subroutine open_node_monitor_file(my_rank)
!
      use m_node_phys_data
      use m_geometry_data
      use set_parallel_file_name
!
      integer (kind=kint), intent(in) :: my_rank
      character(len=kchara) :: fname_tmp, file_name
      integer (kind=kint) :: i, j
!
!
      call add_int_suffix(my_rank, node_monitor_head, fname_tmp)
      call add_dat_extension(fname_tmp, file_name)
      open (id_monitor_file,file=file_name, status='old',               &
     &    position='append', err = 99)
      return
!
  99  continue
      open(id_monitor_file, file=file_name, status='replace')
!
      allocate(num_comp_phys_monitor(num_field_monitor))
      allocate(phys_name_monitor(num_field_monitor))
!
      j = 0
      do i = 1, nod_fld1%num_phys
        if (nod_fld1%iflag_monitor(i) .eq. 1 ) then
          j = j + 1
          num_comp_phys_monitor(j) = nod_fld1%num_component(i)
          phys_name_monitor(j) =     nod_fld1%phys_name(i)
        end if
      end do
!
        write(id_monitor_file,'(a)') num_monitor_local
        write(id_monitor_file,'(a)') 'ID step time x y z '
        write(id_monitor_file,1001)  num_field_monitor
        write(id_monitor_file,1002)                                     &
     &        nod_fld1%num_component(1:num_field_monitor)
 1001   format('number_of_fields: ',i16)
 1002   format('number_of_components: ',200i3)
!
        do i = 1, num_field_monitor
          write(id_monitor_file,*) trim(phys_name_monitor(i))
        end do
!
      deallocate(num_comp_phys_monitor)
      deallocate(phys_name_monitor)
!
      end subroutine open_node_monitor_file
!
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
!
      subroutine set_local_node_id_4_monitor(nod_grp)
!
      use calypso_mpi
      use m_control_parameter
      use m_geometry_data
      use t_group_data
!
      type(group_data), intent(in) :: nod_grp
      integer (kind = kint) :: i, k, inum
!
!
!  count number of local nodes for monitor
!
      num_monitor_local = 0
!
      if ( num_monitor .gt. 0 ) then
        do i = 1, nod_grp%num_grp
!
          do inum = 1, num_monitor
            if (nod_grp%grp_name(i) .eq. monitor_grp(inum)) then
               num_monitor_local = num_monitor_local                    &
     &                            + nod_grp%istack_grp(i)               &
     &                            - nod_grp%istack_grp(i-1)
               exit
            end if
          end do
        end do
      end if
!
!   allocate local node ID
      call allocate_monitor_local
!
      if (num_monitor_local .eq. 0) return
!
      num_monitor_local = 0
      do i=1, nod_grp%num_grp
        do inum = 1, num_monitor
          if (nod_grp%grp_name(i) .eq. monitor_grp(inum)) then
            do k= nod_grp%istack_grp(i-1)+1, nod_grp%istack_grp(i)
              if( nod_grp%item_grp(k) .le. node1%internal_node ) then 
                num_monitor_local = num_monitor_local + 1
                monitor_local(num_monitor_local) = nod_grp%item_grp(k)
              end if
            end do
            exit
          end if
        end do
      end do
!
      end subroutine set_local_node_id_4_monitor
!
! -----------------------------------------------------------------------
! -----------------------------------------------------------------------
!
      subroutine output_monitor_control
!
      use calypso_mpi
      use m_geometry_data
      use m_node_phys_address
      use m_node_phys_data
      use m_t_step_parameter
!
      integer (kind = kint) :: i, inod, i_fld, ist, ied
!
!
      if (i_step_output_monitor .eq. 0) return
      if(mod(istep_max_dt, i_step_output_monitor) .ne. 0) return
!
      if (num_monitor .eq. 0 .or. num_monitor_local .eq. 0) return
!
      call open_node_monitor_file(my_rank)
!
      do i = 1, num_monitor_local
        inod = monitor_local(i)
        write(id_monitor_file,'(2i16,1pe25.15e3)',                      &
     &             advance='NO') i_step_MHD, inod, time
        write(id_monitor_file,'(1p3e25.15e3)',                          &
     &             advance='NO') node1%xx(inod,1:3)
        do i_fld = 1, nod_fld1%num_phys
          if(nod_fld1%iflag_monitor(i_fld) .gt. 0) then
            ist = nod_fld1%istack_component(i_fld-1) + 1
            ied = nod_fld1%istack_component(i_fld)
            write(id_monitor_file,'(1p6E25.15e3)',                      &
     &             advance='NO')  nod_fld1%d_fld(inod,ist:ied)
          end if
        end do
        write(id_monitor_file,'(a)') ''
      end do
!
      close(id_monitor_file)
!
      end subroutine output_monitor_control
!
!  ---------------------------------------------------------------------
!
      subroutine skip_monitor_data
!
      use m_node_phys_data
      use m_t_step_parameter
!
      integer (kind = kint) :: i, k, itmp
      integer (kind = kint) :: i_read_step
      real(kind = kreal) :: rtmp
!
!
      if (num_monitor .ne. 0 .and. num_monitor_local .ne. 0) then
        do
          do i = 1, num_monitor_local
           read(id_monitor_file,*) i_read_step, itmp, rtmp,       &
     &         (rtmp,k=1,3), (rtmp,k=1,ntot_comp_monitor)
          end do
          if (i_read_step.ge.i_step_init) exit
        end do
      end if
!
      end subroutine skip_monitor_data
!
!  ---------------------------------------------------------------------
!
      end module node_monitor_IO

!>@file  gz_MPI_spherical_model_IO.f90
!!       module gz_MPI_spherical_model_IO
!!
!!@author H. Matsui
!!@date        programmed by H.Matsui in July, 2007
!
!> @brief  Data IO routines for spectrum data
!!
!!@verbatim
!!      subroutine gz_mpi_read_rank_4_sph(IO_param, sph_IO)
!!      subroutine gz_mpi_read_gl_reso_sph(IO_param, sph_IO)
!!      subroutine gz_mpi_read_gl_nodes_sph(IO_param, sph_IO)
!!        type(calypso_MPI_IO_params), intent(inout) :: IO_param
!!        type(sph_IO_data), intent(inout) :: sph_IO
!!
!!      subroutine gz_mpi_write_rank_4_sph(IO_param, sph_IO)
!!      subroutine gz_mpi_write_gl_reso_sph(IO_param, sph_IO)
!!      subroutine gz_mpi_write_gl_nodes_sph(IO_param, sph_IO)
!!        type(calypso_MPI_IO_params), intent(inout) :: IO_param
!!        type(sph_IO_data), intent(inout) :: sph_IO
!!@endverbatim
!
      module gz_MPI_spherical_model_IO
!
      use m_precision
!
      use t_node_id_spherical_IO
      use t_calypso_mpi_IO_param
      use m_sph_modes_grid_labels
      use gz_MPI_ascii_data_IO
      use gz_MPI_domain_data_IO
      use gz_MPI_integer_list_IO
      use data_IO_to_textline
!
      implicit none
!
! -----------------------------------------------------------------------
!
      contains
!
! -----------------------------------------------------------------------
!
      subroutine gz_mpi_read_rank_4_sph(IO_param, sph_IO)
!
      type(calypso_MPI_IO_params), intent(inout) :: IO_param
      type(sph_IO_data), intent(inout) :: sph_IO
!
      integer(kind = kint) ::  num_tmp
!
!
      call gz_mpi_skip_header(IO_param, len(hd_segment()))
      call gz_mpi_read_num_of_data(IO_param, num_tmp)
      call gz_mpi_read_comm_table(IO_param,                             &
     &    sph_IO%numdir_sph, sph_IO%numdir_sph, sph_IO%sph_rank)
!
      end subroutine gz_mpi_read_rank_4_sph
!
! -----------------------------------------------------------------------
!
      subroutine gz_mpi_read_gl_reso_sph(IO_param, sph_IO)
!
      type(calypso_MPI_IO_params), intent(inout) :: IO_param
      type(sph_IO_data), intent(inout) :: sph_IO
!
      integer(kind = kint) ::  num_tmp
!
!
      call gz_mpi_skip_header(IO_param, len(hd_trunc()))
      call read_integer_textline                                        &
     &   (gz_mpi_read_charahead(IO_param, len_int_txt), sph_IO%ltr_gl)
!
      call gz_mpi_read_num_of_data(IO_param, num_tmp)
      call gz_mpi_read_comm_table(IO_param,                             &
     &    sph_IO%numdir_sph, sph_IO%numdir_sph, sph_IO%nidx_gl_sph)
!
      end subroutine gz_mpi_read_gl_reso_sph
!
! -----------------------------------------------------------------------
!
      subroutine gz_mpi_read_gl_nodes_sph(IO_param, sph_IO)
!
      type(calypso_MPI_IO_params), intent(inout) :: IO_param
      type(sph_IO_data), intent(inout) :: sph_IO
!
!
      call gz_mpi_read_num_of_data(IO_param, sph_IO%numnod_sph)
!
      call alloc_nod_id_sph_IO(sph_IO)
      call gz_mpi_read_ele_connect                                      &
     &   (IO_param, sph_IO%numnod_sph, sph_IO%numdir_sph,               &
     &    sph_IO%inod_gl_sph, sph_IO%idx_gl_sph)
!
      end subroutine gz_mpi_read_gl_nodes_sph
!
! -----------------------------------------------------------------------
! -----------------------------------------------------------------------
!
      subroutine gz_mpi_write_rank_4_sph(IO_param, sph_IO)
!
      type(calypso_MPI_IO_params), intent(inout) :: IO_param
      type(sph_IO_data), intent(inout) :: sph_IO
!
!
      call gz_mpi_write_charahead                                       &
     &   (IO_param, len(hd_segment()), hd_segment())
      call gz_mpi_write_comm_table(IO_param,                            &
     &    sph_IO%numdir_sph, sph_IO%numdir_sph, sph_IO%sph_rank)
!
      end subroutine gz_mpi_write_rank_4_sph
!
! -----------------------------------------------------------------------
!
      subroutine gz_mpi_write_gl_reso_sph(IO_param, sph_IO)
!
      type(calypso_MPI_IO_params), intent(inout) :: IO_param
      type(sph_IO_data), intent(inout) :: sph_IO
!
!
      call gz_mpi_write_charahead                                       &
     &   (IO_param, len(hd_trunc()), hd_trunc())
      call gz_mpi_write_charahead(IO_param, len_int_txt,                &
     &    integer_textline(sph_IO%ltr_gl))
      call gz_mpi_write_comm_table(IO_param,                            &
     &    sph_IO%numdir_sph, sph_IO%numdir_sph, sph_IO%nidx_gl_sph)
!
      end subroutine gz_mpi_write_gl_reso_sph
!
! -----------------------------------------------------------------------
!
      subroutine gz_mpi_write_gl_nodes_sph(IO_param, sph_IO)
!
      type(calypso_MPI_IO_params), intent(inout) :: IO_param
      type(sph_IO_data), intent(inout) :: sph_IO
!
      integer(kind = kint) ::  nvect
!
!
      call gz_mpi_write_num_of_data(IO_param, sph_IO%numnod_sph)
      call gz_mpi_write_ele_connect(IO_param,                           &
     &    sph_IO%numnod_sph, sph_IO%numdir_sph,                         &
     &    sph_IO%inod_gl_sph, sph_IO%idx_gl_sph)
!
      call dealloc_nod_id_sph_IO(sph_IO)
!
      end subroutine gz_mpi_write_gl_nodes_sph
!
! -----------------------------------------------------------------------
!
      end module gz_MPI_spherical_model_IO

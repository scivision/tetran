program test_key

  use cinter, only: initscr,getch, usleep,endwin
  use, intrinsic:: iso_fortran_env, only: stdout=>output_unit, stdin=>input_unit
  use, intrinsic:: iso_c_binding, only: c_int

  implicit none

  integer(c_int) :: ic,x,y
  logical :: lastEsc=.false.

  call getmaxyx(y,x)
  print *,'terminal width x height:',x,y
  
  print *,'press Esc twice to exit. Prints keys pressed and their code'
  call usleep(2000000)
  
  call initscr()
  
  do
    ic = getch()  ! 4-byte integer, automatically prints character!
  ! read(stdin,*) ic !Nope
    write(stdout,'(I4,A1,A1)',advance='no') ic,' ',achar(13)
    flush(stdout)
    
    if(lastEsc) then
      if(ic==27) exit
      lastEsc=.false.
    else
      if(ic==27) lastEsc=.true.
    endif
    
    call usleep(200000)
  end do
  
  call endwin()

end program

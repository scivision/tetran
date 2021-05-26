! Copyright 2021 Michael Hirsch

! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!   http://www.apache.org/licenses/LICENSE-2.0

! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.
   
program BlockTran

use random, only: rand_init
use game, only : cmd_parse, main_game

implicit none (type, external)

integer :: W, H

call rand_init(.false., .false.)

call cmd_parse(W=W, H=H)

call main_game(W=W, H=W)

end program

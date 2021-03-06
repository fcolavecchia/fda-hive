
DROP PROCEDURE IF EXISTS `reqSubmit`;

DELIMITER //

CREATE PROCEDURE `reqSubmit`(IN lsvcnm char (64), IN linParallel int, IN lpriority int, IN lsubip bigint, IN lusrid bigint)
    MODIFIES SQL DATA
begin
/*
 *  ::718604!
 * 
 * Copyright(C) November 20, 2014 U.S. Food and Drug Administration
 * Authors: Dr. Vahan Simonyan (1), Dr. Raja Mazumder (2), et al
 * Affiliation: Food and Drug Administration (1), George Washington University (2)
 * 
 * All rights Reserved.
 * 
 * The MIT License (MIT)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
   declare l_cd int;
   declare l_id int;
   select svcID into l_id from QPSvc where name = lsvcnm;
   select cleanUpDays into l_cd from QPSvc where svcID=l_id;
     if l_cd = 0 then select cleanUpDays from QPSvc where svcID=1;
   end if;
   insert QPReq(svcID,userID,inParallel,priority,subIp,purgeTm) values (l_id ,lusrid,linParallel, lpriority, lsubip, NOW() + interval l_cd DAY ) ;
   select LAST_INSERT_ID();
end //
DELIMITER ;

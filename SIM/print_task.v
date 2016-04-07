//----------------------------------------------------------------------------
//
// *File Name      :       print_task.v
// *Version        :
//                         输出任务
// *Module Description:
//                         1.0
// *Author(s)      :
//                         Guodezheng cxhy1981@gmail.com,
// *LastChangeBy   :      guodezheng
// *CreatTime      :      2016-03-22 10:12:07
// *LastChangeTime :      2016-04-01 17:04:05
//----------------------------------------------------------------------------
//
module print_task();

task warning;
    input [80*8 : 1]       msg;
    begin
        $write("WARNING at %t : %s ", $time,msg);
        $display(" ===============================================");
        $display("|               SIMULATION FAILED               |");
        $display(" ===============================================");
    end
endtask


task error;
    input [80*8 : 1]       msg;
    begin
        $write("ERROR at %t : %s", $time,msg);
        $display(" ===============================================");
        $display("|               SIMULATION FAILED               |");
        $display(" ===============================================");
    end
endtask

task fatal;
    input [80*8 : 1]       msg;
    begin
        $write("FATAL at %t : %s", $time,msg);
        $display(" ===============================================");
        $display("|               SIMULATION FAILED               |");
        $display(" ===============================================");
        $stop;
    end
endtask

task terminate;
    begin
        $display(" ===============================================");
        $display("|               SIMULATION PASSED               |");
        $display(" ===============================================");
        $stop;
    end
endtask


endmodule

/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000000500054586_2202260495_init();
    work_m_00000000003928468644_0721988197_init();
    work_m_00000000001671476621_2858095548_init();
    work_m_00000000000984184716_2866410756_init();
    work_m_00000000004076538370_3683860065_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000004076538370_3683860065");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}

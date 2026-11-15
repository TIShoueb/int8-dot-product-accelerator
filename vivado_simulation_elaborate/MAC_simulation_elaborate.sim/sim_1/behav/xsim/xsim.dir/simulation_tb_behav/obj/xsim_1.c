/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
IKI_DLLESPEC extern void execute_29(char*, char *);
IKI_DLLESPEC extern void execute_44(char*, char *);
IKI_DLLESPEC extern void execute_16(char*, char *);
IKI_DLLESPEC extern void execute_17(char*, char *);
IKI_DLLESPEC extern void execute_52(char*, char *);
IKI_DLLESPEC extern void execute_53(char*, char *);
IKI_DLLESPEC extern void execute_19(char*, char *);
IKI_DLLESPEC extern void execute_54(char*, char *);
IKI_DLLESPEC extern void execute_21(char*, char *);
IKI_DLLESPEC extern void execute_22(char*, char *);
IKI_DLLESPEC extern void execute_23(char*, char *);
IKI_DLLESPEC extern void execute_27(char*, char *);
IKI_DLLESPEC extern void execute_28(char*, char *);
IKI_DLLESPEC extern void execute_55(char*, char *);
IKI_DLLESPEC extern void execute_56(char*, char *);
IKI_DLLESPEC extern void svlog_sampling_process_execute(char*, char*, char*);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_1(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_2(char*, char *);
IKI_DLLESPEC extern void vlog_sv_sequence_execute_0 (char*, char*, char*);
IKI_DLLESPEC extern void assertion_action_m_6188da74_ab17bf92_1(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_3(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_4(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_6188da74_ab17bf92_2(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_6(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_7(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_6188da74_ab17bf92_3(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_5(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_9(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_10(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_6188da74_ab17bf92_4(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_8(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_12(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_13(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_6188da74_ab17bf92_5(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_11(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_15(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_16(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_6188da74_ab17bf92_6(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_14(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_18(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_19(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_20(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_6188da74_ab17bf92_7(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_17(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_22(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_23(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_6188da74_ab17bf92_8(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_6188da74_ab17bf92_21(char*, char *);
IKI_DLLESPEC extern void execute_26(char*, char *);
IKI_DLLESPEC extern void execute_48(char*, char *);
IKI_DLLESPEC extern void execute_49(char*, char *);
IKI_DLLESPEC extern void execute_50(char*, char *);
IKI_DLLESPEC extern void execute_51(char*, char *);
IKI_DLLESPEC extern void execute_106(char*, char *);
IKI_DLLESPEC extern void execute_107(char*, char *);
IKI_DLLESPEC extern void execute_108(char*, char *);
IKI_DLLESPEC extern void execute_109(char*, char *);
IKI_DLLESPEC extern void execute_110(char*, char *);
IKI_DLLESPEC extern void execute_111(char*, char *);
IKI_DLLESPEC extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
IKI_DLLESPEC extern void transaction_31(char*, char*, unsigned, unsigned, unsigned);
IKI_DLLESPEC extern void vlog_transfunc_eventcallback_2state(char*, char*, unsigned, unsigned, unsigned, char *);
IKI_DLLESPEC extern void transaction_71(char*, char*, unsigned, unsigned, unsigned);
IKI_DLLESPEC extern void transaction_72(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[64] = {(funcp)execute_29, (funcp)execute_44, (funcp)execute_16, (funcp)execute_17, (funcp)execute_52, (funcp)execute_53, (funcp)execute_19, (funcp)execute_54, (funcp)execute_21, (funcp)execute_22, (funcp)execute_23, (funcp)execute_27, (funcp)execute_28, (funcp)execute_55, (funcp)execute_56, (funcp)svlog_sampling_process_execute, (funcp)sequence_expr_m_6188da74_ab17bf92_1, (funcp)sequence_expr_m_6188da74_ab17bf92_2, (funcp)vlog_sv_sequence_execute_0 , (funcp)assertion_action_m_6188da74_ab17bf92_1, (funcp)sequence_expr_m_6188da74_ab17bf92_3, (funcp)sequence_expr_m_6188da74_ab17bf92_4, (funcp)assertion_action_m_6188da74_ab17bf92_2, (funcp)sequence_expr_m_6188da74_ab17bf92_6, (funcp)sequence_expr_m_6188da74_ab17bf92_7, (funcp)assertion_action_m_6188da74_ab17bf92_3, (funcp)sequence_expr_m_6188da74_ab17bf92_5, (funcp)sequence_expr_m_6188da74_ab17bf92_9, (funcp)sequence_expr_m_6188da74_ab17bf92_10, (funcp)assertion_action_m_6188da74_ab17bf92_4, (funcp)sequence_expr_m_6188da74_ab17bf92_8, (funcp)sequence_expr_m_6188da74_ab17bf92_12, (funcp)sequence_expr_m_6188da74_ab17bf92_13, (funcp)assertion_action_m_6188da74_ab17bf92_5, (funcp)sequence_expr_m_6188da74_ab17bf92_11, (funcp)sequence_expr_m_6188da74_ab17bf92_15, (funcp)sequence_expr_m_6188da74_ab17bf92_16, (funcp)assertion_action_m_6188da74_ab17bf92_6, (funcp)sequence_expr_m_6188da74_ab17bf92_14, (funcp)sequence_expr_m_6188da74_ab17bf92_18, (funcp)sequence_expr_m_6188da74_ab17bf92_19, (funcp)sequence_expr_m_6188da74_ab17bf92_20, (funcp)assertion_action_m_6188da74_ab17bf92_7, (funcp)sequence_expr_m_6188da74_ab17bf92_17, (funcp)sequence_expr_m_6188da74_ab17bf92_22, (funcp)sequence_expr_m_6188da74_ab17bf92_23, (funcp)assertion_action_m_6188da74_ab17bf92_8, (funcp)sequence_expr_m_6188da74_ab17bf92_21, (funcp)execute_26, (funcp)execute_48, (funcp)execute_49, (funcp)execute_50, (funcp)execute_51, (funcp)execute_106, (funcp)execute_107, (funcp)execute_108, (funcp)execute_109, (funcp)execute_110, (funcp)execute_111, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_31, (funcp)vlog_transfunc_eventcallback_2state, (funcp)transaction_71, (funcp)transaction_72};
const int NumRelocateId= 64;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/simulation_tb_behav/xsim.reloc",  (void **)funcTab, 64);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/simulation_tb_behav/xsim.reloc");
}

void simulate(char *dp)
{
iki_register_root_pointers(2, 13664, 2,0,0,12416, -7,0) ; 
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/simulation_tb_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void subprog_m_a67fb29_3fe4e5c4_10() ;
void subprog_m_a67fb29_3fe4e5c4_9() ;
void subprog_m_a67fb29_3fe4e5c4_8() ;
void subprog_m_a67fb29_3fe4e5c4_7() ;
void subprog_m_a67fb29_3fe4e5c4_6() ;
void subprog_m_a67fb29_3fe4e5c4_5() ;
void subprog_m_a67fb29_3fe4e5c4_4() ;
void subprog_m_a67fb29_3fe4e5c4_3() ;
void subprog_m_a67fb29_3fe4e5c4_2() ;
static char* ng20[] = {(void *)subprog_m_a67fb29_3fe4e5c4_10, (void *)subprog_m_a67fb29_3fe4e5c4_9, (void *)subprog_m_a67fb29_3fe4e5c4_8, (void *)subprog_m_a67fb29_3fe4e5c4_7, (void *)subprog_m_a67fb29_3fe4e5c4_6, (void *)subprog_m_a67fb29_3fe4e5c4_5, (void *)subprog_m_a67fb29_3fe4e5c4_4, (void *)subprog_m_a67fb29_3fe4e5c4_3, (void *)subprog_m_a67fb29_3fe4e5c4_2};
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_xsimdir_location_if_remapped(argc, argv)  ;
    iki_set_sv_type_file_path_name("xsim.dir/simulation_tb_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/simulation_tb_behav/xsim.crvsdump");
    iki_svlog_initialize_virtual_tables(1, 2, ng20);
    void* design_handle = iki_create_design("xsim.dir/simulation_tb_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, (void*)0, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}

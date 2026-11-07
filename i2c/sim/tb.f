+incdir+${APB_VIP_VERIF_PATH}/sequences
+incdir+${APB_VIP_VERIF_PATH}/testcases
+incdir+${APB_VIP_VERIF_PATH}/tb
+incdir+${APB_VIP_VERIF_PATH}/regmodel
+incdir+${APB_VIP_VERIF_PATH}/regmodel/register

+incdir+${I2C_VIP_VERIF_PATH}/sequences
+incdir+${I2C_VIP_VERIF_PATH}/testcases
+incdir+${I2C_VIP_VERIF_PATH}/tb

+define+APB_ADDR_WIDTH=8
+define+APB_DATA_WIDTH=8
// Compilation VIP design (agent) list
-f ${APB_VIP_ROOT}/apb_vip.f
-f ${I2C_VIP_ROOT}/i2c_vip.f

// Compilation Environment
${APB_VIP_VERIF_PATH}/regmodel/register/i2c_register_pkg.sv
${APB_VIP_VERIF_PATH}/regmodel/i2c_regmodel_pkg.sv
${APB_VIP_VERIF_PATH}/tb/env_pkg.sv
${APB_VIP_VERIF_PATH}/sequences/seq_pkg.sv
${APB_VIP_VERIF_PATH}/testcases/test_pkg.sv
${APB_VIP_VERIF_PATH}/tb/testbench.sv


// Compilation Environment


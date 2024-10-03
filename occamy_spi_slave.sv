// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Yunhao Deng <yunhao.deng@kuleuven.be>

module occamy_spi_slave #(
    parameter type axi_lite_req_t = logic,
    parameter type axi_lite_rsp_t = logic
) (
    input  logic          clk_i,
    input  logic          rst_ni,
    output axi_lite_req_t axi_lite_req_o,
    input  axi_lite_rsp_t axi_lite_rsp_i,

    input  logic       spi_sclk_i,
    input  logic       spi_cs_i,
    output logic [3:0] spi_oen_o,
    input  logic [3:0] spi_sdi_i,
    output logic [3:0] spi_sdo_o
);
  localparam int AXI_ADDR_WIDTH = $bits(axi_lite_req_o.aw.addr);
  localparam int AXI_DATA_WIDTH = $bits(axi_lite_rsp_i.r.data);

  axi_spi_slave #(
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
      .AXI_USER_WIDTH(1),
      .AXI_ID_WIDTH  (1)
  ) i_axi_spi_slave (
      // SPI Interface
      .test_mode(1'b0),
      .spi_sclk(spi_sclk_i),
      .spi_cs(spi_cs_i),
      .spi_sdi0(spi_sdi_i[0]),
      .spi_sdi1(spi_sdi_i[1]),
      .spi_sdi2(spi_sdi_i[2]),
      .spi_sdi3(spi_sdi_i[3]),
      .spi_sdo0(spi_sdo_o[0]),
      .spi_sdo1(spi_sdo_o[1]),
      .spi_sdo2(spi_sdo_o[2]),
      .spi_sdo3(spi_sdo_o[3]),
      .spi_oen0_o(spi_oen_o[0]),
      .spi_oen1_o(spi_oen_o[1]),
      .spi_oen2_o(spi_oen_o[2]),
      .spi_oen3_o(spi_oen_o[3]),

      // AXI4 MASTER
      .axi_aclk(clk_i),
      .axi_aresetn(rst_ni),
      // WRITE ADDRESS CHANNEL
      .axi_master_aw_valid(axi_lite_req_o.aw_valid),
      .axi_master_aw_addr(axi_lite_req_o.aw.addr),
      .axi_master_aw_prot(axi_lite_req_o.aw.prot),
      .axi_master_aw_region(),
      .axi_master_aw_len(),
      .axi_master_aw_size(),  // Only 32bit aw / ar is supported. Be careful
      .axi_master_aw_burst(),
      .axi_master_aw_lock(),
      .axi_master_aw_cache(),
      .axi_master_aw_qos(),
      .axi_master_aw_id(),
      .axi_master_aw_user(),
      .axi_master_aw_ready(axi_lite_rsp_i.aw_ready),

      // READ ADDRESS CHANNEL
      .axi_master_ar_valid(axi_lite_req_o.ar_valid),
      .axi_master_ar_addr(axi_lite_req_o.ar.addr),
      .axi_master_ar_prot(axi_lite_req_o.ar.prot),
      .axi_master_ar_region(),
      .axi_master_ar_len(),
      .axi_master_ar_size(),  // Only 32bit aw / ar is supported. Be careful
      .axi_master_ar_burst(),
      .axi_master_ar_lock(),
      .axi_master_ar_cache(),
      .axi_master_ar_qos(),
      .axi_master_ar_id(),
      .axi_master_ar_user(),
      .axi_master_ar_ready(axi_lite_rsp_i.ar_ready),

      // WRITE DATA CHANNEL
      .axi_master_w_valid(axi_lite_req_o.w_valid),
      .axi_master_w_data (axi_lite_req_o.w.data),
      .axi_master_w_strb (axi_lite_req_o.w.strb),
      .axi_master_w_user (),
      .axi_master_w_last (),
      .axi_master_w_ready(axi_lite_rsp_i.w_ready),

      // READ DATA CHANNEL
      .axi_master_r_valid(axi_lite_rsp_i.r_valid),
      .axi_master_r_data(axi_lite_rsp_i.r.data),
      .axi_master_r_resp(axi_lite_rsp_i.r.resp),
      .axi_master_r_last('1),
      .axi_master_r_id(1),
      .axi_master_r_user('0),
      .axi_master_r_ready(axi_lite_req_o.r_ready),

      // WRITE RESPONSE CHANNEL
      .axi_master_b_valid(axi_lite_rsp_i.b_valid),
      .axi_master_b_resp(axi_lite_rsp_i.b.resp),
      .axi_master_b_id(1),
      .axi_master_b_user('0),
      .axi_master_b_ready(axi_lite_req_o.b_ready)
  );

endmodule

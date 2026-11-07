`timescale 1ns / 1ps
module test_top;

   	reg sys_clk;
	reg sys_rst_n;
	reg psel;
	reg penable;
	reg pwrite;
	reg [11:0] paddr;
	reg [31:0] pwdata;
    wire [31:0] prdata;
	wire pready;
	reg [31:0] read_tmp;
	wire [7:0] data_out_top;
	
//	wire tr_cmp_int;
    wire tx_fifo_full_int;
    wire tx_fifo_empty_int;
    wire rx_fifo_full_int;
    wire rx_fifo_empty_int;
    wire nack_error_int;
 //   wire abort_ack_int;
 //   wire arb_lost_int;
//    wire timeout_int;
	wire i2c_scl;
    wire i2c_sda;
    reg [7:0] data_in;
        
    pullup(i2c_sda);
    
	module_top uut ( 
	    .sys_clk(sys_clk), 
		.sys_rst_n(sys_rst_n), 
		.psel(psel), 
		.penable(penable), 
		.pwrite(pwrite), 
		.paddr(paddr), 
		.pwdata(pwdata),
		.prdata(prdata), 
		.pready(pready),
		.data_in(data_in),
		.data_out_top(data_out_top),
	//	.tr_cmp_int(tr_cmp_int),
        .tx_fifo_full_int(tx_fifo_full_int),
        .tx_fifo_empty_int(tx_fifo_empty_int),
        .rx_fifo_full_int(rx_fifo_full_int),
        .rx_fifo_empty_int(rx_fifo_empty_int),
        .nack_error_int(nack_error_int),
    //    .abort_ack_int(abort_ack_int),
   //     .arb_lost_int(arb_lost_int),
   //     .timeout_int(timeout_int),
		
		.sda(i2c_sda),
		.scl(i2c_scl)
		
    );
    initial begin
        sys_clk = 0;
        forever #20 sys_clk = ~sys_clk;
    end
    
    initial begin
		sys_clk = 0;
		sys_rst_n = 0;
		psel = 0;
		penable = 0;  
		data_in = 8'hA5;
		@(posedge sys_clk);
		sys_rst_n = 1;
	 /*	
	 // Default value	
		@(posedge sys_clk);
		apb_read(12'h04, read_tmp);   
        
        if (read_tmp == 32'h00) begin
            $display("PASSED rd_data_reg");
		end else begin
		    $display("FAILED rd_data_reg");
		end
		
		apb_read(12'h08, read_tmp);   
        
        if (read_tmp == 32'h00) begin
            $display("PASSED target_addrl_reg");
		end else begin
		    $display("FAILED target_addrl_reg");
		end
		
		apb_read(12'h0C, read_tmp);   
        
        if (read_tmp == 32'h00) begin
            $display("PASSED target_addrh_reg");
		end else begin
		    $display("FAILED target_addrh_reg");
		end
		
		apb_read(12'h14, read_tmp);   
        
        if (read_tmp == 32'h00) begin
            $display("PASSED byte_cnt_reg");
		end else begin
		    $display("FAILED byte_cnt_reg");
		end
		
		apb_read(12'h18, read_tmp);   
        
        if (read_tmp == 32'h00) begin
            $display("PASSED mode_reg");
		end else begin
		    $display("FAILED mode_reg");
		end
		
		apb_read(12'h1C, read_tmp);   
        
        if (read_tmp == 32'h00) begin
            $display("PASSED clk_prescl_reg");
		end else begin
		    $display("FAILED clk_prescl_reg");
		end		
		
		apb_read(12'h1C, read_tmp);   
        
        if (read_tmp == 32'h00) begin
            $display("PASSED clk_prescl_reg");
		end else begin
		    $display("FAILED clk_prescl_reg");
		end
		
		apb_read(12'h24, read_tmp);   
        
        if (read_tmp == 32'h00) begin
            $display("PASSED int1_enable_reg");
		end else begin
		    $display("FAILED int1_enable_reg");
		end
		
		apb_read(12'h2C, read_tmp);   
        
        if (read_tmp == 32'h00) begin
            $display("PASSED int2_enable_reg");
		end else begin
		    $display("FAILED int2_enable_reg");
		end
		
		apb_read(12'h30, read_tmp);   
        
        if (read_tmp == 32'h05) begin
            $display("PASSED ff_status_reg");
		end else begin
		    $display("FAILED ff_status_reg");
		end
		
	*/
   /*
   // Write data = 8'h3c ( 7 bit addr )
        @(posedge sys_clk);
        apb_write(12'h00, 32'h3c); // data_in
        apb_write(12'h08, 32'h55); // addr
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h18, 32'h00); // write
        apb_write(12'h1C, 32'd4);  // prescl
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h11); //start = 1 tx_enable = 1
        apb_write(12'h10, 32'h00); // tx_enable = 0  
        repeat(180)@(posedge sys_clk);
        if (data_out_top == 32'h3c) begin
            $display("PASSED Write");
		end else begin
		    $display("FAILED Write");
		end
    */
        
   /*  
   //  Read data = 0xa5 from slave      
        @(posedge sys_clk);
        apb_write(12'h00, 32'h3c); // data_in
        apb_write(12'h08, 32'h55); // addr
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h18, 32'h08); // read
        apb_write(12'h1C, 32'd4);  // prescl
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h11); //start = 1 tx_enable = 1
        apb_write(12'h10, 32'h00); // tx_enable = 0     
        repeat(180)@(posedge sys_clk);
        apb_read(12'h04, read_tmp);   
        
        if (read_tmp == 32'ha5) begin
            $display("PASSED Read");
		end else begin
		    $display("FAILED Read");
		end
    */
 
    /*
    // Write - Repeat_start - Read               
      
        @(posedge sys_clk);
        apb_write(12'h00, 32'h3c); // data_in
        apb_write(12'h08, 32'h55); // addr
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h18, 32'h00); // write
        apb_write(12'h1C, 32'd4);  // prescl
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h19); //start = 1 tx_enable = 1 // repeat_start = 1
        apb_write(12'h10, 32'h09); // tx_enable = 0
        @(posedge sys_clk);
        repeat(150)@(posedge sys_clk);     
        apb_write(12'h18, 32'h08); // read
        repeat(200)@(posedge sys_clk);
        apb_write(12'h10, 32'h00);   // start = 0 repeat_start= 0;
         
    */
     
    // Read - Repeat_start - Write               
     
        @(posedge sys_clk);
        apb_write(12'h00, 32'h3c); // data_in
        apb_write(12'h08, 32'h55); // addr
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h18, 32'h08); // read
        apb_write(12'h1C, 32'd4);  // prescl
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h19); //start = 1 tx_enable = 1 // repeat_start = 1
        apb_write(12'h10, 32'h09); // tx_enable = 0
        @(posedge sys_clk);
        repeat(150)@(posedge sys_clk);     
        apb_write(12'h18, 32'h00); // write
        repeat(200)@(posedge sys_clk);    
        apb_write(12'h10, 32'h00);   // start = 0 repeat_start= 0;
        
     /*   
    // byte_cnt = 3 ( write 3 byte lien tiep )
       @(posedge sys_clk);
        apb_write(12'h00, 32'h3c); // data_in
        apb_write(12'h08, 32'h55); // addr
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h18, 32'h00); // read
        apb_write(12'h1C, 32'd4);  // prescl
        apb_write(12'h14, 32'h03); // byte_cnt = 3
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h11); //start = 1 tx_enable = 1 
        apb_write(12'h10, 32'h00); // tx_enable = 0
        
        
        apb_write(12'h00, 32'h11); // data_in
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h10, 32'h00); // tx_enable = 0
        
        apb_write(12'h00, 32'h22); // data_in
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h10, 32'h00); // tx_enable = 0
        @(posedge sys_clk);
      */
     /*
     // tr_cmp_int
        @(posedge sys_clk);
        apb_write(12'h00, 32'h3c); // data_in
        apb_write(12'h08, 32'h55); // addr
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h18, 32'h00); // write
        apb_write(12'h1C, 32'd4);  // prescl
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h11); //start = 1 tx_enable = 1
        apb_write(12'h10, 32'h01); // tx_enable = 0  
        repeat(190)@(posedge sys_clk);
        apb_write(12'h24, 32'h10);  // tr_cmp_int_en;
        @(posedge sys_clk);
        if (tr_cmp_int == 1'b1) begin
            $display("PASSED tr_cmp_int ");
		end else begin
		    $display("FAILED tr_cmp_int");
		end  
        apb_write(12'h20,32'h10);  // W1C tr_cmp_int
        @(posedge sys_clk);
        if (tx_fifo_full_int == 1'b0) begin
            $display("PASSED tr_cmp_int ");
		end else begin
		    $display("FAILED tr_cmp_int");
		end
       */ 

		
	/*	
    
   //full_fifo_tx - full_fifo_int and empty
        apb_write(12'h24, 32'h04);  // tx_fifo_empty_en;
        $display("Cho phep ngat khi fifo rong");
        @(posedge sys_clk);
        if (tx_fifo_empty_int == 1'b1) begin
            $display("PASSED tx_fifo_empty_int ");
		end else begin
		    $display("FAILED tx_fifo_empty_int");
		end  
        apb_write(12'h20,32'h04);  // W1C tx_fifo_full_int
        $display("Ghi 1 de xoa co ngat  ");
        @(posedge sys_clk);
        if (tx_fifo_full_int == 1'b0) begin
            $display("PASSED clear tx_fifo_empty_int ");
		end else begin
		    $display("FAILED tx_fifo_empty_int");
		end
		apb_write(12'h24, 32'h00);  // tx_fifo_empty_en;
		
        @(posedge sys_clk);
        apb_write(12'h08, 32'h55); // addr
        apb_write(12'h1C, 32'd4);  // prescl
        apb_write(12'h00, 32'h11); // data1
        $display("Ghi du lieu thu 1 ");
        apb_write(12'h10, 32'h10); // tx_enable = 1
        apb_write(12'h10, 32'h00); // tx_enable = 0
        
        apb_write(12'h00, 32'h22); // data2
        $display("Ghi du lieu thu 2 ");
        apb_write(12'h10, 32'h10); // tx_enable = 1
        apb_write(12'h10, 32'h00); // tx_enable = 0
        
        apb_write(12'h00, 32'h33); // data3
        $display("Ghi du lieu thu 3 ");
        apb_write(12'h10, 32'h10); // tx_enable = 1
        apb_write(12'h10, 32'h00); // tx_enable = 0
        
        apb_write(12'h00, 32'h44); // data4
        $display("Ghi du lieu thu 4 ");
        apb_write(12'h10, 32'h10); // tx_enable = 1
        apb_write(12'h10, 32'h00); // tx_enable = 0
        
        apb_write(12'h24, 32'h08);  // tx_fifo_full_en;
        $display("Cho phep ngat khi fifo_full ");
        @(posedge sys_clk);
        if (tx_fifo_full_int == 1'b1) begin
            $display("PASSED tx_fifo_full_int ");
		end else begin
		    $display("FAILED tx_fifo_full_int");
		end  
        apb_write(12'h20,32'h08);  // W1C tx_fifo_full_int
        $display("Ghi 1 de xoa co ngat ");
        @(posedge sys_clk);
        if (tx_fifo_full_int == 1'b0) begin
            $display("PASSED clear tx_fifo_full_int ");
		end else begin
		    $display("FAILED tx_fifo_full_int");
		end  
     */   
     
     //full_fifo_rx - full_fifo_int  rx_empty_fifo_int
      /*
        data_in = 8'hA5; //data1
        @(posedge sys_clk);
        apb_write(12'h00, 32'h3c); // data_in
        apb_write(12'h08, 32'h55); // addr
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h18, 32'h08); // read
        apb_write(12'h1C, 32'd4);  // prescl
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h11); //start = 1 tx_enable = 1
        apb_write(12'h10, 32'h00); // tx_enable = 0     
        repeat(200)@(posedge sys_clk);
        data_in = 8'h33;  //data2     
        apb_write(12'h10, 32'h01); //start = 1 tx_enable = 1
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h00); // 
        repeat(200)@(posedge sys_clk);
        data_in = 8'h44;//data3
        apb_write(12'h10, 32'h01); //start = 1 tx_enable = 1
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h00); // 
        repeat(200)@(posedge sys_clk);
        data_in = 8'h55;//data4
        apb_write(12'h10, 32'h01); //start = 1 tx_enable = 1
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h00); // 
        
        repeat(200)@(posedge sys_clk);
        apb_write(12'h24, 32'h02);  // rx_fifo_full_en;
        @(posedge sys_clk);
        if (rx_fifo_full_int == 1'b1) begin
            $display("PASSED rx_fifo_full_int ");
		end else begin
		    $display("FAILED rx_fifo_full_int");
		end  
        apb_write(12'h20,32'h02);  // W1C rx_fifo_full_int
        @(posedge sys_clk);
        if (rx_fifo_full_int == 1'b0) begin
            $display("PASSED rx_fifo_full_int ");
		end else begin
		    $display("FAILED rx_fifo_full_int");
		end  
        
        apb_read(12'h04, read_tmp);
        if (read_tmp == 32'ha5) begin
            $display("PASSED data1");
		end else begin
		    $display("FAILED data1");
		end     
        apb_write(12'h10, 32'h20); // rx_enable =1
        apb_write(12'h10, 32'h00); // rx_enable = 0
        
        
        apb_read(12'h04, read_tmp);
        if (read_tmp == 32'h33) begin
            $display("PASSED data2");
		end else begin
		    $display("FAILED data2");
		end     
        apb_write(12'h10, 32'h20); // rx_enable
        apb_write(12'h10, 32'h00); // rx_enable = 0
        
        apb_read(12'h04, read_tmp);
        if (read_tmp == 32'h44) begin
            $display("PASSED data3");
		end else begin
		    $display("FAILED data3");
		end     
        apb_write(12'h10, 32'h20); // rx_enable
        apb_write(12'h10, 32'h00); // rx_enable = 0
        
        apb_read(12'h04, read_tmp);
        if (read_tmp == 32'h55) begin
            $display("PASSED data4");
		end else begin
		    $display("FAILED data4");
		end     
        apb_write(12'h10, 32'h20); // rx_enable
        apb_write(12'h10, 32'h00); // rx_enable = 0
        
        apb_write(12'h24, 32'h01);  // rx_fifo_empty_en;
        @(posedge sys_clk);
        if (rx_fifo_empty_int == 1'b1) begin
            $display("PASSED rx_fifo_empty_int ");
		end else begin
		    $display("FAILED rx_fifo_empty_int");
		end  
        apb_write(12'h20,32'h01);  // W1C rx_fifo_empty_int
        @(posedge sys_clk);
        if (rx_fifo_empty_int == 1'b0) begin
            $display("PASSED rx_fifo_empty_int ");
		end else begin
		    $display("FAILED rx_fifo_empty_int");
		end
       */ 
        
               
		
     /*
      // nack_error, nack interupt
      @(posedge sys_clk);
        apb_write(12'h00, 32'h3c); // data_in
        apb_write(12'h08, 32'h33); // addr
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h18, 32'h00); // write
        apb_write(12'h1C, 32'd4);  // prescl
        apb_write(12'h2C, 32'h08);  // nack_error_en = 1
        repeat(5) @(posedge sys_clk);      
        apb_write(12'h10, 32'h11); //start = 1 tx_enable = 1
        apb_write(12'h10, 32'h01); // tx_enable = 0  
        repeat(100)@(posedge sys_clk);
        if (nack_error_int == 1'b1) begin
            $display("PASSED nack_error_int ");
		end else begin
		    $display("FAILED nack_error_int");
		end  
		repeat(5) @(posedge sys_clk); 		
		apb_write(12'h28,32'h08);  // W1C nack_error_int
		@(posedge sys_clk)
		if (nack_error_int == 1'b0) begin
            $display("PASSED W1C ");
		end else begin
		    $display("FAILED W1C ");
		end 
      */   
      /*
      // Write data = 8'h3c ( 10 bit addr )
        @(posedge sys_clk);
        apb_write(12'h00, 32'h3c); // data_in
        apb_write(12'h08, 32'h55); // addr_l
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h0C, 32'h03); // addr_h
        
        apb_write(12'h18, 32'h10); // write , 10bit 
        apb_write(12'h1C, 32'd4);  // prescl
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h11); //start = 1 tx_enable = 1
        apb_write(12'h10, 32'h00); // tx_enable = 0  
        repeat(180)@(posedge sys_clk);
        if (data_out_top == 32'h3c) begin
            $display("PASSED Write");
		end else begin
		    $display("FAILED Write");
		end        
      */
      
      /*
     // Read data = 8'ha5 ( 10 bit addr )
        @(posedge sys_clk);
        apb_write(12'h00, 32'h3c); // data_in
        apb_write(12'h08, 32'h55); // addr_l
        apb_write(12'h10, 32'h10); // tx_enable
        apb_write(12'h0C, 32'h03); // addr_h
        
        apb_write(12'h18, 32'h18); // write , 10bit 
        apb_write(12'h1C, 32'd4);  // prescl
        repeat(5) @(posedge sys_clk);
        apb_write(12'h10, 32'h11); //start = 1 tx_enable = 1
        apb_write(12'h10, 32'h00); // tx_enable = 0  
        repeat(280)@(posedge sys_clk);
        
        apb_read(12'h04, read_tmp);   
        
        if (read_tmp == 32'ha5) begin
            $display("PASSED Read");
		end else begin
		    $display("FAILED Read");
		end 
        */
        
        
    end
   
    
    task apb_write (
        input [11:0] address,
        input [31:0] data
    );
        begin 
            psel    = 1;
            pwrite  = 1;
            paddr   = address;
            pwdata  = data;
            penable = 0;
            @(posedge sys_clk);
            penable = 1;
            #1;
            @(posedge sys_clk);
            psel    = 0;
            penable = 0;
        end
    endtask
    
    task apb_read(
		input  [11:0] address,
		output reg [31:0] read_data
    );
        begin
            psel = 1;
            pwrite = 0;
            paddr = address;
		    penable =0;
            @(posedge sys_clk); 
            penable = 1;
		    #1;
            read_data = prdata;
            @(posedge sys_clk);
            psel = 0;
            penable = 0;
        end
	endtask
endmodule
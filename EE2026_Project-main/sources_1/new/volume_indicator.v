module volume_indicator(
    input cs, 
    input [11:0] sample,
    output reg [15:0] volume_level = 0
    );
    
    reg [10:0]counter = 0;
    reg [11:0] max_so_far = 0;
    reg [11:0] max = 0;
    
    always @ (posedge cs) begin
    
        counter <= counter + 1;
              
        if (counter == 2000) begin  
            max <= max_so_far;                      //set max as the max_so_far, don't touch the max otherwise, hence max only updates every 2000 counts

            volume_level[0] <= (max > 2000) ? 1 : 0;
            volume_level[1] <= (max > 2100) ? 1 : 0;
            volume_level[2] <= (max > 2300) ? 1 : 0; 
            volume_level[3] <= (max > 2500) ? 1 : 0;
            volume_level[4] <= (max > 2700) ? 1 : 0;
            volume_level[5] <= (max > 2900) ? 1 : 0;
            volume_level[6] <= (max > 3100) ? 1 : 0;
            volume_level[7] <= (max > 3300) ? 1 : 0;
            volume_level[8] <= (max > 3400) ? 1 : 0;
            volume_level[9] <= (max > 3500) ? 1 : 0;
            volume_level[10] <= (max > 3600) ? 1 : 0;
            volume_level[11] <= (max > 3700) ? 1 : 0;
            volume_level[12] <= (max > 3800) ? 1 : 0;
            volume_level[13] <= (max > 3900) ? 1 : 0;
            volume_level[14] <= (max > 4000) ? 1 : 0;
            volume_level[15] <= (max > 4000) ? 1 : 0;
            
            max_so_far <= sample;
            counter <= 0;                           //reset counter when it reaches 2000
        end
        
        else if ((max_so_far <= sample)) begin
            max_so_far <= sample;                   //set max_so_far if sample is greater than its value 
        end
 end
    
endmodule

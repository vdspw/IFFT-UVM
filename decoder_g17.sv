//This is decoder block which is going to scoreboard 

class decoder_g17 extends uvm_component;
    `uvm_component_utils(decoder_g17)

    seqitem_g17 dec;
    uvm_analysis_port #(seqitem_g17) dsend;
    uvm_blocking_put_imp #(seqitem_g17, decoder_g17) drec; 

    real tpoints[0:3] = '{0.0, 0.333, 0.666, 1.0};

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drec = new("put_imp", this);
        dsend = new("put_port", this);
        dec = new("decoder message");
    endfunction

    function new(string name="decoder_g17", uvm_component parent=null);
        super.new(name, parent);
    endfunction;

    virtual task put(ref seqitem_g17 dec1);
        decode(dec1);
        dsend.write(dec1);
        $display(" ~~~~~~ Decoder Output : %0h", dec1.DataOut1);
    endtask

    function real returnsquare(real square);
    	return square*square;
    endfunction 

    virtual function void decode(seqitem_g17 dec1);
        real full_scale, fsq, dp[0:2];
        int bv, dx;
        longint result, sft;

	full_scale = $max(returnsquare(dec1.temp[55]), returnsquare(dec1.temp[57]));

        dp[0] = returnsquare(0.166666 * full_scale);
        dp[1] = returnsquare((0.166666 + 0.333333) * full_scale);
        dp[2] = returnsquare((0.166666 + 0.666666) * full_scale);

        for (longint x = 4; x < 52; x = x + 2) begin
            fsq = returnsquare(dec1.temp[x]);
            bv = 3;
            for (int dx = 0; dx < 3; dx = dx + 1) begin
                if (fsq < dp[dx]) begin
                    bv = dx;
                    break;
                end
            end
            
            if ((x-4)>=0 && (x-4) < $bits(result)) begin
            	result = result | bv << x-4;
            end
            
        end
        dec1.DataOut1= result;
    endfunction
    
endclass : decoder_g17

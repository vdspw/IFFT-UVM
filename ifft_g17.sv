//This is the IFFT Block, which is doing the ifft and bit reversal

class ifft_g17 extends uvm_component;

	`uvm_component_utils(ifft_g17)
	uvm_blocking_put_port #(seqitem_g17) ifftsend; 
	uvm_blocking_put_imp #(seqitem_g17, ifft_g17) ifftrec;

	real realtwid[64];
	real imagtwid[64];
	int index;
	int revindex;
	int i,j;
	
	 function new(string name = "ifft_g17", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		
	  function void build_phase(uvm_phase phase);
		 super.build_phase(phase);
		 ifftsend = new("ifftsend", this); 
		 ifftrec = new("ifftrec", this); 
		 twidfactors();
	  endfunction
		
	  function void twidfactors();
		 realtwid = '{1, 0.9987954562051724, 0.9951847266721969, 0.989176509964781, 
          		0.9807852804032304, 0.970031253194544, 0.9569403357322088, 0.9415440651830208, 
			  0.9238795325112867, 0.9039892931234433, 0.881921264348355, 0.8577286100002721, 
			  0.8314696123025452, 0.8032075314806449, 0.773010453362737, 0.7409511253549591, 
			  0.7071067811865476, 0.6715589548470183, 0.6343932841636455, 0.5956993044924335, 
			  0.5555702330196023, 0.5141027441932217, 0.4713967368259978, 0.4275550934302822, 
			  0.38268343236508984, 0.33688985339222005, 0.29028467725446233, 0.24298017990326398, 
			  0.19509032201612833, 0.14673047445536175, 0.09801714032956077, 0.049067674327418126, 
			  6.123233995736766e-17, -0.04906767432741801, -0.09801714032956065, 
			  -0.14673047445536164, -0.1950903220161282, -0.24298017990326387, 
			  -0.29028467725446216, -0.33688985339221994, -0.3826834323650897, 
			  -0.42755509343028186, -0.4713967368259977, -0.5141027441932217, 
			  -0.555570233019602, -0.5956993044924334, -0.6343932841636454, 
			  -0.6715589548470184, -0.7071067811865475, -0.7409511253549589, 
			  -0.773010453362737, -0.8032075314806448, -0.8314696123025453, 
			  -0.857728610000272, -0.8819212643483549, -0.9039892931234433, 
			  -0.9238795325112867, -0.9415440651830207, -0.9569403357322088, 
			  -0.970031253194544, -0.9807852804032304, -0.989176509964781, 
			  -0.9951847266721968, -0.9987954562051724};
    
		  imagtwid = '{0, 0.049067674327418015, 0.0980171403295606, 0.14673047445536175, 
			  0.19509032201612825, 0.24298017990326387, 0.29028467725446233, 0.33688985339222005, 
			  0.3826834323650898, 0.4275550934302821, 0.47139673682599764, 0.5141027441932217, 
			  0.5555702330196022, 0.5956993044924334, 0.6343932841636455, 0.6715589548470183, 
			  0.7071067811865475, 0.7409511253549591, 0.773010453362737, 0.8032075314806448, 
			  0.8314696123025452, 0.8577286100002721, 0.8819212643483549, 0.9039892931234433, 
			  0.9238795325112867, 0.9415440651830208, 0.9569403357322089, 0.970031253194544, 
			  0.9807852804032304, 0.989176509964781, 0.9951847266721968, 0.9987954562051724, 
			  1, 0.9987954562051724, 0.9951847266721969, 0.989176509964781, 
			  0.9807852804032304, 0.970031253194544, 0.9569403357322089, 0.9415440651830208, 
			  0.9238795325112867, 0.9039892931234434, 0.881921264348355, 0.8577286100002721, 
			  0.8314696123025455, 0.8032075314806449, 0.7730104533627371, 0.740951125354959, 
			  0.7071067811865476, 0.6715589548470186, 0.6343932841636455, 0.5956993044924335, 
			  0.5555702330196022, 0.5141027441932218, 0.47139673682599786, 0.42755509343028203, 
			  0.3826834323650899, 0.33688985339222033, 0.2902846772544624, 0.24298017990326407, 
			  0.1950903220161286, 0.1467304744553618, 0.09801714032956083, 0.049067674327417966};
	    endfunction

	    virtual task put(ref seqitem_g17 mes1);
			$display("----> Now IFFT Block Running <-----");
			ifft(mes1);
			#100;
		 	ifftsend.put(mes1);
		 	//$display("IFFT output: %0f", mes1.timeout);
	    endtask
		
	    function int bitreversal(int index);
                        revindex = 0;
                        i = 0;
                        while (i < 7) begin
                              revindex = (revindex << 1) | (index & 1);
                              index = index >> 1;
                              i++;
                        end
                      return revindex;
              endfunction
              
	   function void ifft(seqitem_g17 mes1);
	    		
	    		typedef struct {
				real re; 
				real im;
			} complextype;

			complextype temp;
			complextype wk[128];

			int ix, bs, i1, i2, twix, i, j, x;
			int spread = 2;
			real temp_re, temp_img, v_re, v_im, real_a, img_a, real_b, img_b;
			real max = 1e-15; 
			
		  	 for (int i = 0; i < 128; i++) begin
				int j = bitreversal(i);
				wk[j].re = mes1.complexout[i].re;
				wk[j].im = mes1.complexout[i].im;
			end

			for (x = 0; x < 7; x++) begin
				bs = 0;
				while (bs<128) begin
					for (ix = bs; ix < bs + spread/2; ix++) begin
						twix = (ix % spread) * (128 / spread);
						i1 = ix;
						i2 = ix + spread/2;
						temp_re = realtwid[twix];
						temp_img = imagtwid[twix];

						v_re = wk[i2].re * temp_re - wk[i2].im * temp_img;
						v_im = wk[i2].re * temp_img + wk[i2].im * temp_re;

						real_a = wk[i1].re + v_re;
						img_a = wk[i1].im + v_im;
						real_b = wk[i1].re - v_re;
						img_b = wk[i1].im - v_im;

					       wk[i1].re = real_a;
                                               if ($abs(img_a) < 1e-15) begin
                                               wk[i1].im = 0;
                                               end 
                                               else begin
                                                   wk[i1].im = img_a;
                                               end
                                               wk[i2].re = real_b;
                                               if ($abs(img_b) < 1e-15) begin
                                                   wk[i2].im = 0;
                                               end 
                                               else begin
                                                    wk[i2].im = img_b;
                                               end
                                          end
                                   	bs += spread;
				end
			     spread *= 2;
			end
			
			i=0;
			while (i<128) begin 
				mes1.timeout[i].re = wk[i].re / 128;
				mes1.timeout[i].im = wk[i].im / 128;
				mes1.timeout[i].im = ($abs(mes1.timeout[i].im) < max) ? 0 : mes1.timeout[i].im;
				i++;
			end
			
	endfunction : ifft

endclass:ifft_g17


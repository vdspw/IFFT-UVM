//This is the FFT component which acts as a reference model 

class fft_g17 extends uvm_component;

	`uvm_component_utils(fft_g17)
	uvm_blocking_put_port #(seqitem_g17) ffts; //to send decoder
	uvm_blocking_put_imp #(seqitem_g17, fft_g17) fft_rec; //receive from drv

	real realtwid[64];
	real imgtwid[64];
	int i,j, revindex;
	
	function new(string name = "fft_g17", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ffts = new("ffts", this); 
		fft_rec = new("fft_rec", this);
		twidfactor();
	endfunction

	function void twidfactor();
		realtwid = '{1.0, 0.9987954562051724, 0.9951847266721969, 0.989176509964781, 0.9807852804032304, 
			       0.970031253194544, 0.9569403357322088, 0.9415440651830208, 0.9238795325112867, 
			   0.9039892931234433, 0.881921264348355, 0.8577286100002721, 0.8314696123025452, 
			   0.8032075314806449, 0.773010453362737, 0.7409511253549591, 0.7071067811865476, 
			   0.6715589548470183, 0.6343932841636455, 0.5956993044924335, 0.5555702330196023, 
			   0.5141027441932217, 0.4713967368259978, 0.4275550934302822, 0.38268343236508984, 
			   0.33688985339222005, 0.29028467725446233, 0.24298017990326398, 0.19509032201612833, 
			   0.14673047445536175, 0.09801714032956077, 0.049067674327418126, 6.123233995736766e-17, 
			   -0.04906767432741801, -0.09801714032956065, -0.14673047445536164, -0.1950903220161282, 
			   -0.24298017990326387, -0.29028467725446216, -0.33688985339221994, -0.3826834323650897, 
			   -0.42755509343028186, -0.4713967368259977, -0.5141027441932217, -0.555570233019602, 
			   -0.5956993044924334, -0.6343932841636454, -0.6715589548470184, -0.7071067811865475, 
			   -0.7409511253549589, -0.773010453362737, -0.8032075314806448, -0.8314696123025453, 
			   -0.857728610000272, -0.8819212643483549, -0.9039892931234433, -0.9238795325112867, 
			   -0.9415440651830207, -0.9569403357322088, -0.970031253194544, -0.9807852804032304, 
			   -0.989176509964781, -0.9951847266721968, -0.9987954562051724};
			   
		imgtwid = '{0, -0.049067674327418015, -0.0980171403295606, -0.14673047445536175, 
			      -0.19509032201612825, -0.24298017990326387, -0.29028467725446233, 
			  -0.33688985339222005, -0.3826834323650898, -0.4275550934302821, 
			  -0.47139673682599764, -0.5141027441932217, -0.5555702330196022, -0.5956993044924334, 
			  -0.6343932841636455, -0.6715589548470183, -0.7071067811865475, -0.7409511253549591, 
			  -0.773010453362737, -0.8032075314806448, -0.8314696123025452, -0.8577286100002721, 
			  -0.8819212643483549, -0.9039892931234433, -0.9238795325112867, -0.9415440651830208,
			  -0.9569403357322089, -0.970031253194544, -0.9807852804032304, -0.989176509964781, 
			  -0.9951847266721968, -0.9987954562051724, -1.0, -0.9987954562051724, -0.9951847266721969, 
			  -0.989176509964781, -0.9807852804032304, -0.970031253194544, -0.9569403357322089, 
			  -0.9415440651830208, -0.9238795325112867, -0.9039892931234434, -0.881921264348355,
			  -0.8577286100002721, -0.8314696123025455, -0.8032075314806449, -0.7730104533627371,
			  -0.740951125354959, -0.7071067811865476, -0.6715589548470186, -0.6343932841636455, 
			  -0.5956993044924335, -0.5555702330196022, -0.5141027441932218, -0.47139673682599786,
			  -0.42755509343028203, -0.3826834323650899, -0.33688985339222033, -0.2902846772544624,
			  -0.24298017990326407, -0.1950903220161286, -0.1467304744553618, -0.09801714032956083, 
			  -0.049067674327417966};
	endfunction

	virtual task put(ref seqitem_g17 mes1);
		$display("----> Now FFT Block Running <-----");
		fft(mes1);
		#100;
		ffts.put(mes1);
		for(int i=0;i<128;i++) begin
			//$display("fft out = %f" ,mes1.complexout[i].re );
		end
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

	function void fft(seqitem_g17 mes1);
		typedef struct {
			real re;
			real im;
		} complextype;

		complextype temp;
		complextype wk [128];	

		int ix, bs, i1, i2, twix, i, j, x;
		int spread = 2;
		real temp_re, temp_img, v_re, v_im, real_a, img_a, real_b, img_b;
		real max = 1e-15;

		for (i = 0; i < 128; i++) begin
			j = bitreversal(i);
			wk[j].re = mes1.timeout[i].re;
			wk[j].im = mes1.timeout[i].im;
		end

		for (x = 0; x < 7; x++) begin
			bs = 0;
			while (bs < 128) begin
				for (ix = bs; ix < bs + spread/2; ix++) begin
					twix = (ix % spread) * (128 / spread);
					i1 = ix;
					i2 = ix + spread/2;
					temp_re = realtwid[twix];
					temp_img = imgtwid[twix];

					v_re = wk[i2].re * temp_re - wk[i2].im * temp_img;
					v_im = wk[i2].re * temp_img + wk[i2].im * temp_re;

					real_a = wk[i1].re + v_re;
					img_a = wk[i1].im + v_im;
					real_b = wk[i1].re - v_re;
					img_b = wk[i1].im - v_im;

					wk[i1].re = real_a;
					wk[i1].im = img_a;
					wk[i2].re = real_b;
					wk[i2].im = img_b;
				end
			     bs += spread;
			end
		     spread *= 2;
		end

		i=0;
		while (i<128) begin  
			mes1.complexout[i].im = 0;
			if ($abs(wk[i].re) < max) begin
				mes1.complexout[i].re = 0;
				mes1.temp[i] = 0;
			end 
			else begin
				mes1.complexout[i].re = wk[i].re;
				mes1.temp[i] = wk[i].re;
			end
			i++;
		end
	endfunction
endclass : fft_g17

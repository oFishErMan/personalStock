package com.pentas.mb.mj.ctl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cmm.utils.common.PentasMap;
import com.pentas.mb.mj.svc.MBMJ0100P01Svc;

@RequestMapping("/mb/mj/MBMJ0100P01")
@Controller
public class MBMJ0100P01Ctl {
	
	@Autowired
	MBMJ0100P01Svc mBMJ0100P01Svc;
	
	@RequestMapping ("MBMJ0100P0101")
	public PentasMap selectTC(PentasMap params) {
		PentasMap pm = mBMJ0100P01Svc.selectTC(params);
		return pm;
	}
}

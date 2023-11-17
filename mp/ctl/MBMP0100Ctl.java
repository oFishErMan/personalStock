package com.pentas.mb.mp.ctl;


import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cmm.utils.common.PentasMap;
import com.pentas.mb.cm.svc.CommonSvc;
import com.pentas.mb.mp.svc.MBMP0100Svc;

@RequestMapping("/mb/mp")
@Controller
public class MBMP0100Ctl {
	
	@Autowired
	MBMP0100Svc mBMP0100Svc;
	
	@Autowired
	CommonSvc commonSvc;
	/*
	 * 대상 ID 및 닉네임 불러오기
	 * 페이지 출력 
	 */
	@GetMapping ("/MBMP0100")
	public String openPage(Model model, @RequestBody PentasMap params) {
		PentasMap rs = mBMP0100Svc.selecTargetNick(params);
		model.addAttribute("pageTitle", rs.getString("NICKNM"));
		model.addAttribute("tgtId",params.getString("tgtId"));
		return "mb/mp/MBMP0100";
	}
	
	/*
	 * 대상 ID의 공개피스 목록 불러오기 
	 */
	@RequestMapping("/MBMP0101")
	public List<PentasMap> getList(HttpSession session,PentasMap params) {
		params.put("mbrId", session.getAttribute("MBR_ID"));
		return mBMP0100Svc.selectPieceList(params);
	}
	
	
	
}

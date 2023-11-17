package com.pentas.mb.sb.ctl;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cmm.utils.common.PentasMap;
import com.pentas.mb.sb.svc.MBSB0100Svc;

@RequestMapping("/mb/sb")
@Controller
public class MBSB0100Ctl {
	
	@Autowired
	MBSB0100Svc mBSB0100Svc;
	
	@RequestMapping("/MBSB0100") 
	public String openPage(Model model) {
		model.addAttribute("pageTitle","회원 차단관리");
		return "mb/sb/MBSB0100";
	}
	
	//차단 목록 불러오기
	@RequestMapping("/MBSB0101") 
	public List<PentasMap> getBlockList(HttpSession session,PentasMap params) {
		params.put("MBR_ID", session.getAttribute("MBR_ID"));
		List<PentasMap> pList = mBSB0100Svc.selectBlockList(params);
		if(pList.size() == 0) {
			params.put("chkEmpty", 0);
			pList.add(params);
			return pList;
		} else { 
			return pList;
		}
	}
	
	//차단 목록 삭제
	@RequestMapping("/MBSB0102")
	public void deleteBlock(HttpSession session, PentasMap params) {
		params.put("MBR_ID", session.getAttribute("MBR_ID"));
		mBSB0100Svc.deleteBlock(params);
	}
}

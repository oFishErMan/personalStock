package com.pentas.mb.pi.ctl;


import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cmm.utils.common.PentasMap;
import com.cmm.utils.common.PentasMapBuilder;
import com.pentas.mb.cm.svc.CommonSvc;
import com.pentas.mb.pi.svc.MBPI0100P01Svc;

@RequestMapping("/mb/pi/MBPI0100P01")
@Controller
public class MBPI0100P01Ctl {
	
	@Autowired
	MBPI0100P01Svc mBPI0100P01Svc;
	
	@Autowired
	CommonSvc commonSvc;
	
	/*
     * 비밀번호 일치 체크
     */
	@RequestMapping ("/checkPassword")
	public PentasMap updatePassword(HttpSession session, PentasMap params) {
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		params.put("MBR_ID", session.getAttribute("MBR_ID"));
		
		//입력한 비밀번호와 DB에 있는 비밀번호의 일치 확인
		if(encoder.matches(params.getString("password"), mBPI0100P01Svc.selectCurrentPassword(params).getString("LOGIN_PW"))) {
			return new PentasMapBuilder().put("result", "success").build();
		} else {
			return new PentasMapBuilder().put("result", "fail").build();
		}
	}
	
	/*
     * 회원 탈퇴
     */
	@RequestMapping ("/goWithdrawal")
	public PentasMap goWithdrawal(HttpSession session, PentasMap params) {
		params.put("MBR_ID", session.getAttribute("MBR_ID"));
		mBPI0100P01Svc.updateMemberQuit(params);
		mBPI0100P01Svc.insertReasonWithdrawal(params);
		
		return new PentasMapBuilder().put("result", "success").build();
	}
	
	/*
     * 탈퇴 이유 목록 가져오기
     */
	@RequestMapping ("/getCode")
	public List<PentasMap> getCode(PentasMap params) {
		return mBPI0100P01Svc.selectWithdrawalCode(params);
	}
	
}

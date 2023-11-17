package com.pentas.mb.mj.ctl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cmm.exception.UserBizException;
import com.cmm.utils.common.PentasMap;
import com.cmm.utils.common.PentasMapBuilder;
import com.cmm.utils.uuid.UuidUtil;
import com.pentas.mb.cm.svc.EmailSvc;
import com.pentas.mb.mj.svc.MBMJ0100Svc;


@RequestMapping("/mb/mj")
@Controller
public class MBMJ0100Ctl {
	
	@Autowired
	MBMJ0100Svc mBMJ0100Svc;

	@Autowired
	EmailSvc emailSvc;	
	
	@RequestMapping ("MBMJ0100")
	public String openPage(Model model) {
		model.addAttribute("pageTitle","회원가입");
		return "mb/mj/MBMJ0100";
	}
	
	/*
     * 이메일 인증번호 전송
     */
	@RequestMapping ("MBMJ0101")
	public PentasMap sendEmailCertificationNumber(PentasMap params) {
		String emailCrtNo = "";
		for (int i = 0; i < 6; i++) { // 이메일인증번호 난수생성
			emailCrtNo += String.valueOf((int)(Math.random()*9));
		}
		LocalDateTime now = LocalDateTime.now().plusHours(2);
		DateTimeFormatter dtf1 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		DateTimeFormatter dtf2 = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		params.put("emailCrtNo", emailCrtNo);
		params.put("emailCrtDue", now.format(dtf1));
		PentasMap pm1 = mBMJ0100Svc.selectEmailCheckDuplication(params);
		if(pm1.getInt("result") == 1) {
			return new PentasMapBuilder().put("result", "duplicated").build();
		}
		emailSvc.sendUserVerificationEmail(params);
		params.replace("emailCrtDue", now.format(dtf2));
		mBMJ0100Svc.insertEmailInfomation(params);
		return new PentasMapBuilder().put("result", "sucess").build();
	}
	
	/*
     * 이메일 인증번호 확인
     */
	@RequestMapping ("MBMJ0102")
	public PentasMap checkCertificationNumber(PentasMap params) {
		PentasMap pm = mBMJ0100Svc.selectEmailCertificationNumber(params);
		return pm;
	}
	
	/*
     * 닉네임 중복확인
     */
	@RequestMapping ("MBMJ0103")
	public PentasMap checkNickDuplicate(PentasMap params) {
		PentasMap pm = mBMJ0100Svc.selectNickCheckDuplication(params);
		return pm;
	}
	
	/*
     * 회원가입
     */
	@RequestMapping ("MBMJ0104")
	public PentasMap addAccount(PentasMap params) {
		String regExp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[~!@#$%^&*()+|=])[A-Za-z\\d~!@#$%^&*()+|=]{8,20}$";
		Matcher matcher = Pattern.compile(regExp).matcher(params.getString("userPassword"));;
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		LocalDateTime now = LocalDateTime.now();
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		//이하 2차검증
		//비밀번호와 비밀번호 다시입력 확인
		if(params.getString("userPassword").equals(params.getString("userPasswordCheck"))) {
			//변경 할 비밀번호의 정규식 유효성 검사
			if(!matcher.find())
				return new PentasMapBuilder().put("result", "regexp").build();
			else {
				String MBR_ID = "MBR-" + UuidUtil.getUuidOnlyString();
				params.put("MBR_ID", MBR_ID);
				params.put("LOGIN_PW", encoder.encode(params.getString("userPassword")));
				params.put("NICKNM_UPD_DTM", now.format(dtf));
				
				// 기본포켓을 생성하기 위한 ID
				String GRP_ID = "GRP-" + UuidUtil.getUuidOnlyString();
				params.put("GRP_ID", GRP_ID);
				
				mBMJ0100Svc.insertAccount(params);
				return new PentasMapBuilder().put("result", "sucess").build();
			}
		} else {
			return new PentasMapBuilder().put("result", "password").build();
		}
	}
}

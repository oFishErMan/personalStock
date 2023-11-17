package com.pentas.mb.pr.ctl;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
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
import com.pentas.mb.cm.svc.EmailSvc;
import com.pentas.mb.pr.svc.MBPR0100Svc;


@RequestMapping("/mb/pr")
@Controller
public class MBPR0100Ctl {
	
	@Autowired
	MBPR0100Svc mBPR0100Svc;
	
	@Autowired
	EmailSvc emailSvc;
	
	@RequestMapping ("MBPR0100")
	public String openPage(Model model) {
		model.addAttribute("pageTitle","비밀번호 찾기");
		return "mb/pr/MBPR0100";
	}
	
	/*
     * 이메일 인증번호 전송
     */
	@RequestMapping ("MBPR0101")
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
		emailSvc.sendUserVerificationEmail(params);
		params.replace("emailCrtDue", now.format(dtf2));
		mBPR0100Svc.insertEmailInfomation(params);
		return new PentasMapBuilder().put("result", "sucess").build();
	}
	
	/*
     * 이메일 인증번호 체크
     */
	@RequestMapping ("MBPR0102")
	public PentasMap checkCertificationNumber(PentasMap params) {
		PentasMap pm = mBPR0100Svc.selectEmailCertificationNumber(params);
		return pm;
	}
	
	/*
     * 비밀번호 업데이트
     */
	@RequestMapping ("MBPR0103")
	public PentasMap updatePassword(HttpSession session, PentasMap params) {
		String regExp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[~!@#$%^&*()+|=])[A-Za-z\\d~!@#$%^&*()+|=]{8,20}$";
		Matcher matcher = Pattern.compile(regExp).matcher(params.getString("LOGIN_PW"));;
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		
		//변경 할 비밀번호의 정규식 유효성 검사
		if(!matcher.find())
			throw new UserBizException("정규식 오류");
		else {
			params.replace("LOGIN_PW", encoder.encode(params.getString("LOGIN_PW")));
			mBPR0100Svc.updatePassword(params);
			return new PentasMapBuilder().put("result", 1).build();
		}
	}
	
	/*
	 * //비밀번호 난수 생성 및 초기화
	 * 
	 * @RequestMapping ("MBPR0101") public void updateTemporaryPassword(PentasMap
	 * params, HttpSession session) { String regEmail =
	 * "^[0-9a-zA-z]([-_\\.]?[0-9a-zA-z])*@[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$";
	 * String regPwd = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*\\W).{8,20}$"; Matcher
	 * emailMatcher = Pattern.compile(regEmail).matcher(params.getString("email"));;
	 * 
	 * char[] charSet = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8',
	 * '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
	 * 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c',
	 * 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
	 * 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '!', '@', '#', '$', '%', '^', '&',
	 * '*', '(', ')', '|', ':', '\\', '\"', '?', '\'', '`', ',', '.', '/', '-', '=',
	 * '+', '_' }; BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
	 * StringBuffer sb = new StringBuffer(); SecureRandom sr = new SecureRandom();
	 * sr.setSeed(new Date().getTime()); while (true) { for (int i = 0; i < 8; i++)
	 * { int idx = sr.nextInt(charSet.length); sb.append(charSet[idx]); }
	 * System.out.println("생성 "+sb.toString()); if(Pattern.matches(regPwd,
	 * sb.toString())) { break; } if(!Pattern.matches(regPwd, sb.toString())) {
	 * System.out.println("오류오류"+sb.toString()); sb.delete(0, 8); } }
	 * params.put("loginPw", encoder.encode(sb.toString())); //이하 2차검증 //변경 할 비밀번호의
	 * 정규식 유효성 검사 if(!emailMatcher.find()) throw new UserBizException("정규식 오류");
	 * else { int result = mBPR0100Svc.updateTemporaryPassword(params); if(result ==
	 * 1) { params.put("nicknm", mBPR0100Svc.selectUserEmail(params).get("NICKNM"));
	 * params.replace("loginPw", sb.toString());
	 * emailSvc.sendUserTempPasswordEmail(params); } } }
	 */
}

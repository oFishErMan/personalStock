package com.pentas.mb.pc.ctl;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cmm.exception.UserBizException;
import com.cmm.utils.common.PentasMap;
import com.cmm.utils.common.PentasMapBuilder;
import com.pentas.mb.pc.svc.MBPC0100Svc;


@RequestMapping("/mb/pc")
@Controller
public class MBPC0100Ctl {
	
	@Autowired
	MBPC0100Svc mBPC0100Svc;
	
	@RequestMapping ("MBPC0100")
	public String openPage(Model model) {
		model.addAttribute("pageTitle","비밀번호 변경");
		return "mb/pc/MBPC0100";
	}
	
	/*
     * 비밀번호 업데이트
     */
	@RequestMapping ("MBPC0101")
	public PentasMap updatePassword(HttpSession session, PentasMap params) {
		String regExp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[~!@#$%^&*()+|=])[A-Za-z\\d~!@#$%^&*()+|=]{8,20}$";
		Matcher matcher = Pattern.compile(regExp).matcher(params.getString("newPassword"));;
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		params.put("MBR_ID", session.getAttribute("MBR_ID"));
		
		//이하 2차검증
		//현재 비밀번호와 변경 할 비밀번호가 같다면 예외
		if(params.get("newPassword")!=params.get("oldPassword")) {
			//변경 할 비밀번호의 정규식 유효성 검사
			if(!matcher.find())
				throw new UserBizException("정규식 오류");
			else {
				//비밀번호 변경 페이지에서 입력한 현재 비밀번호와 DB에 있는 비밀번호의 일치 확인
				params.replace("newPassword", encoder.encode(params.getString("newPassword")));
				mBPC0100Svc.updatePassword(params);
				return new PentasMapBuilder().put("result", "sucess").build();
			}
		} else {
			throw new UserBizException("현재 비밀번호와 변경 할 비밀번호가 같음");
		}
	}
	
	/*
     * 현재 비밀번호 일치 체크
     */
	@RequestMapping ("MBPC0102")
	public PentasMap checkPassword(HttpSession session, PentasMap params) {
		String regExp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[~!@#$%^&*()+|=])[A-Za-z\\d~!@#$%^&*()+|=]{8,20}$";
		Matcher matcher = Pattern.compile(regExp).matcher(params.getString("oldPassword"));;
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		params.put("MBR_ID", session.getAttribute("MBR_ID"));
		//입력한 비밀번호와 DB상의 비밀번호 매칭 확인
		boolean check = encoder.matches(params.getString("oldPassword"), mBPC0100Svc.selectCurrentPassword(params).getString("LOGIN_PW"));
		//현재 비밀번호와 변경 할 비밀번호가 같다면 예외
		if(!matcher.find()) { //현재 비밀번호 정규식 2차 검증
			return new PentasMapBuilder().put("result", "regFail").build();
		} else {
			if(check) {
				return new PentasMapBuilder().put("result", "sucess").build();
			} else {
				return new PentasMapBuilder().put("result", "fail").build();
			}
		}
	}
}

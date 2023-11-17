package com.pentas.mb.pi.ctl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.springframework.web.servlet.view.RedirectView;

import com.cmm.utils.common.CmmnUtil;
import com.cmm.utils.common.MultipartFileList;
import com.cmm.utils.common.PentasMap;
import com.cmm.utils.common.PentasMapBuilder;
import com.cmm.utils.json.JsonUtil;
import com.cmm.utils.string.StringUtil;
import com.pentas.mb.cm.svc.CommonSvc;
import com.pentas.mb.cm.svc.EmailSvc;
import com.pentas.mb.pi.svc.MBPI0100Svc;

import lombok.extern.slf4j.Slf4j;

@RequestMapping("/mb/pi")
@Controller
public class MBPI0100Ctl {

	@Autowired
	MBPI0100Svc mBPI0100Svc;

	@Autowired
	EmailSvc emailSvc;

	@Autowired
	CommonSvc commonSvc;

	// 메인페이지
	@RequestMapping(value = "/MBPI0100", method=RequestMethod.GET)
	public String mBPI0100(HttpSession session, Model model) throws Exception {
		String result = (String) session.getAttribute("SNS_TYP");
		model.addAttribute("pageTitle", "내정보");
		model.addAttribute("NICKNM", session.getAttribute("NICKNM"));
		model.addAttribute("PF_IMG", session.getAttribute("PF_IMG"));
		model.addAttribute("EMAIL", session.getAttribute("EMAIL"));
		model.addAttribute("SNS_TYP", result);
		session.removeAttribute("SNS_TYP");
		
		return "mb/pi/MBPI0100";
	}

	/*
	 * 내정보 불러오기
	 */
	@RequestMapping("/MBPI0101")
	public PentasMap getUserInformation(HttpSession session, PentasMap params) {
		params.put("MBR_ID", session.getAttribute("MBR_ID"));
		return mBPI0100Svc.selectUserInformation(params);
	}

	/*
	 * 닉네임 중복체크
	 */
	@RequestMapping("MBPI0102")
	public PentasMap checkNickDuplicate(PentasMap params) {
		PentasMap pm = mBPI0100Svc.selectNickCheckDuplication(params);
		return pm;
	}

	/*
	 * 이메일 인증번호 전송
	 */
	@RequestMapping("MBPI0103")
	public PentasMap sendEmailCertificationNumber(PentasMap params) {
		String emailCrtNo = "";
		for (int i = 0; i < 6; i++) { // 이메일인증번호 난수생성
			emailCrtNo += String.valueOf((int) (Math.random() * 9));
		}
		LocalDateTime now = LocalDateTime.now().plusHours(2);
		DateTimeFormatter dtf1 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		DateTimeFormatter dtf2 = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		params.put("emailCrtNo", emailCrtNo);
		params.put("emailCrtDue", now.format(dtf1));
		PentasMap pm1 = mBPI0100Svc.selectEmailCheckDuplication(params);
		if (pm1.getInt("result") == 1) {
			return new PentasMapBuilder().put("result", "duplicated").build();
		}
		emailSvc.sendUserVerificationEmail(params);
		params.replace("emailCrtDue", now.format(dtf2));
		mBPI0100Svc.insertEmailInfomation(params);
		return new PentasMapBuilder().put("result", "sucess").build();
	}

	/*
	 * 이메일 인증번호 체크
	 */
	@RequestMapping("MBPI0104")
	public PentasMap checkCertificationNumber(PentasMap params) {
		PentasMap pm = mBPI0100Svc.selectEmailCertificationNumber(params);
		return pm;
	}

	/*
	 * 변경된 내정보 저장
	 */
	@RequestMapping("MBPI0105")
	public PentasMap updateUserAccount(HttpSession session, PentasMap params,
			MultipartFileList fileList/* , Model model */) {
		params.put("MBR_ID", session.getAttribute("MBR_ID"));

		String uploadRelativePath = StringUtil.join("/static_resources/images/",
				CmmnUtil.getTodayString().substring(0, 6), '/');
		for (int i = 0; i < fileList.size(); i++) {
			PentasMap fileInfo = commonSvc.uploadFile(fileList.get(i), uploadRelativePath);

			params.put("PF_IMG", fileInfo.getString("STOR_FILE_NM"));
		}

		int result = mBPI0100Svc.updateUserAccount(params);

		if (result == 1) {
			session.removeAttribute("NICK");
			session.removeAttribute("EMAIL");
			session.setAttribute("NICKNM", params.getString("NICKNM"));
			session.setAttribute("EMAIL", params.getString("EMAIL"));

			// ChoiJY 프로필 이미지 변경하면 세션에서도 변경되고, 전체메뉴에서도 변경되서 나오도록..
			session.setAttribute("PF_IMG", params.getString("PF_IMG"));
			session.setAttribute("DEF_IMG", params.getString("DEF_IMG"));

			// model.addAttribute("NICK", params.getString("NICKNM"));
			// model.addAttribute("EMAIL", params.getString("EMAIL"));

			return new PentasMapBuilder().put("result", "sucess").build();
		} else {
			return new PentasMapBuilder().put("result", "fail").build();
		}
	}

	/*
	 * // 1번 카카오톡에 사용자 코드 받기(jsp의 a태그 href에 경로 있음)
	 * 
	 * @RequestMapping(value = "/MBPI0200", method = RequestMethod.GET) public
	 * String kakaoLogin(@RequestParam(value = "code", required = false) String
	 * code) throws Throwable {
	 * 
	 * // 1번 System.out.println("code:" + code); return "/mb/pi/MBPI0100" null; //
	 * return에 페이지를 해도 되고, 여기서는 코드가 넘어오는지만 확인할거기 때문에 따로 return 값을 두지는 않았음
	 * 
	 * }
	 */

	@GetMapping ("/MBPI0200")
	public RedirectView kakaoLogin(HttpSession session, Model model,  @RequestBody PentasMap params) {
		params.put("MBR_ID", session.getAttribute("MBR_ID"));
		model.addAttribute("code", params.get("code"));
		System.out.println("코드:" + params.get("code"));
		String access_Token = mBPI0100Svc.getKakaoAccessToken(params);
		params.put("access_Token", access_Token);
		session.setAttribute("access_Token", access_Token);
		mBPI0100Svc.createKakaoUser(params);
		session.setAttribute("SNS_TYP","KAKAO");
		RedirectView rv = new RedirectView("/mb/pi/MBPI0100");
		rv.setExposeModelAttributes(false);
		return rv;
	}
	
	@RequestMapping ("/MBPI0201")
	public PentasMap kakaoLogout(HttpSession session, PentasMap params) {
		params.put("MBR_ID", session.getAttribute("MBR_ID"));
		String access_Token = "";
		if(session.getAttribute("access_Token") != null) {
			access_Token = session.getAttribute("access_Token").toString();
			params.put("access_Token", access_Token);
		}
		PentasMap pm = mBPI0100Svc.kakaoLogout(params);
		session.removeAttribute("access_Token");
		return pm;
	}
}

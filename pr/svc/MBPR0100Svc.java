package com.pentas.mb.pr.svc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PentasMap;

@Service
public class MBPR0100Svc {
	
	@Autowired
	CmmnDao cmmnDao;
	
	//비밀번호 업데이트
	public int updateTemporaryPassword(PentasMap params) {
		return cmmnDao.update("com.pentas.mb.pr.MBPR0100.updateTemporaryPassword", params);
	}
	
	//유저 닉네임 선택
	public PentasMap selectUserNick(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.pr.MBPR0100.selectUserNick", params);
	}
	
	public PentasMap selectEmailCertificationNumber(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.pr.MBPR0100.selectEmailCertificationNumber",params);
	}
	
	public void insertEmailInfomation(PentasMap params) {
		cmmnDao.insert("com.pentas.mb.pr.MBPR0100.insertEmailInfomation", params);
	}
	
	//비밀번호 업데이트
		public void updatePassword(PentasMap params) {
			cmmnDao.update("com.pentas.mb.pr.MBPR0100.updatePassword", params);
		}
}

package com.pentas.mb.pc.svc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PentasMap;

@Service
public class MBPC0100Svc {
	
	@Autowired
	CmmnDao cmmnDao;
	
	//현재 비밀번호 셀렉트
	public PentasMap selectCurrentPassword(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.pc.MBPC0100.selectCurrentPassword",params);
	}
	
	//비밀번호 업데이트
	public void updatePassword(PentasMap params) {
		cmmnDao.update("com.pentas.mb.pc.MBPC0100.updatePassword", params);
	}
	
}

package com.pentas.mb.mj.svc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PentasMap;

@Service
public class MBMJ0100Svc {
	
	@Autowired
	CmmnDao cmmnDao;
	
	public PentasMap selectEmailCheckDuplication(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.mj.MBMJ0100.selectEmailCheckDuplicate",params);
	}
	
	public PentasMap selectNickCheckDuplication(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.mj.MBMJ0100.selectNickCheckDuplicate",params);
	}
	
	public PentasMap selectEmailCertificationNumber(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.mj.MBMJ0100.selectEmailCertificationNumber",params);
	}
	
	public void insertEmailInfomation(PentasMap params) {
		cmmnDao.insert("com.pentas.mb.mj.MBMJ0100.insertEmailInfomation", params);
	}
	
	public void insertAccount(PentasMap params) {
		cmmnDao.update("com.pentas.mb.mj.MBMJ0100.insertAccount", params);
		cmmnDao.update("com.pentas.mb.mj.MBMJ0100.insertDefaultPocket", params);
	}
	
}

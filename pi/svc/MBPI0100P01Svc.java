package com.pentas.mb.pi.svc;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PentasMap;

@Service
public class MBPI0100P01Svc {
	
	@Autowired
	CmmnDao cmmnDao;
	
	//현재 비밀번호 셀렉트
	public PentasMap selectCurrentPassword(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.pi.MBPI0100P01.selectCurrentPassword",params);
	}
	
	public void updateMemberQuit(PentasMap params) {
		cmmnDao.update("com.pentas.mb.pi.MBPI0100P01.updateMemberQuit",params);
	}
	
	public void insertReasonWithdrawal(PentasMap params) {
		cmmnDao.insert("com.pentas.mb.pi.MBPI0100P01.insertReasonWithdrawal",params);
	}
	
	public List<PentasMap> selectWithdrawalCode(PentasMap params) {
		return cmmnDao.selectList("com.pentas.mb.pi.MBPI0100P01.selectWithdrawalCode",params);
	}
}

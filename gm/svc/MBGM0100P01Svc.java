package com.pentas.mb.gm.svc;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PentasMap;

@Service
public class MBGM0100P01Svc {
	
	@Autowired
	CmmnDao cmmnDao;
	
	public PentasMap selectIsNtecr(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.gm.MBGM0100P01.selectIsNtecr", params);
	}
	
	public List<PentasMap> selectUserGrp(PentasMap params) {
		return cmmnDao.selectList("com.pentas.mb.gm.MBGM0100P01.selectUserGrp", params);
	}
	
	public PentasMap selectNteInfo(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.gm.MBGM0100P01.selectNteInfo", params);
	}
	
	public void updateNteMaster(PentasMap params) {
		cmmnDao.update("com.pentas.mb.gm.MBGM0100P01.updateNteMaster", params);
	}
	
	public void updateMyNte(PentasMap params) {
		cmmnDao.update("com.pentas.mb.gm.MBGM0100P01.updateMyNte", params);
	}

}

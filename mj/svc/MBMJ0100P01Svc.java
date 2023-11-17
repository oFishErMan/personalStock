package com.pentas.mb.mj.svc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PentasMap;

@Service
public class MBMJ0100P01Svc {
	
	@Autowired
	CmmnDao cmmnDao;
	
	public PentasMap selectTC(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.mj.MBMJ0100P01.selectTC",params);
	}
	
}

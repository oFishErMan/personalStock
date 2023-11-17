package com.pentas.mb.mp.svc;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PentasMap;

@Service
public class MBMP0100Svc {
	
	@Autowired
	CmmnDao cmmnDao;
	
	public PentasMap selecTargetNick(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.mp.MBMP0100.selecTargetNick", params);
	}
	
	public List<PentasMap> selectPieceList(PentasMap params) {
		return cmmnDao.selectList("com.pentas.mb.mp.MBMP0100.selectPieceList",params);
	}
	
	
}

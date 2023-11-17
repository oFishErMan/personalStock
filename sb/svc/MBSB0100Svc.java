package com.pentas.mb.sb.svc;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PentasMap;

@Service
public class MBSB0100Svc {
	
	@Autowired
	CmmnDao cmmnDao;
	
	//사용자의 차단목록 가져오기
	public List<PentasMap> selectBlockList(PentasMap params) {
		return cmmnDao.selectList("com.pentas.mb.sb.MBSB0100.selectBlockList",params);
	}
	
	//차단목록 1개 삭제
	public void deleteBlock(PentasMap params) {
		cmmnDao.delete("com.pentas.mb.sb.MBSB0100.deleteBlock", params);
	}
	
}

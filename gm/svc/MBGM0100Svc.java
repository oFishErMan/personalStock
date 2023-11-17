package com.pentas.mb.gm.svc;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PentasMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

@Service
public class MBGM0100Svc {

    @Autowired
    CmmnDao cmmnDao;

    /**
     * 서랍 리스트 조회
     * @param pentasMap
     * @return
     */
    public List<PentasMap> selectGonggiList(PentasMap pentasMap) {
        return cmmnDao.selectList("com.pentas.mb.gm.MBGM0100.selectGonggiList", pentasMap);
    }

    public List<PentasMap> selectPiecesCount(PentasMap pentasMap) {
        return cmmnDao.selectList("com.pentas.mb.gm.MBGM0100.selectPiecesCount", pentasMap);
    }
    
    public List<PentasMap> selectPieceList(PentasMap pentasMap) {
        return cmmnDao.selectList("com.pentas.mb.gm.MBGM0100.selectPieceList", pentasMap);
    }
    
    /**
     * 서랍 삭제
     * @param pentasMap
     */
    public void deleteGonggi(PentasMap pentasMap) {
        cmmnDao.delete("com.pentas.mb.gm.MBGM0100.deleteGonggi", pentasMap);
    }
    
    /**
     * 서랍 삭제
     * @param pentasMap
     */
    public void updateGonggiOrdNo(PentasMap pentasMap) {
		cmmnDao.update("com.pentas.mb.gm.MBGM0100.updateGonggiOrdNo",pentasMap);
    }
    
    public void updatePieceGonggi(PentasMap pentasMap) {
		cmmnDao.update("com.pentas.mb.gm.MBGM0100.updatePieceGonggi",pentasMap);
    }
    
    /**
     * 서랍 삭제
     * @param pentasMap
     */
    public void setFavPiece(PentasMap pentasMap) {
		cmmnDao.update("com.pentas.mb.gm.MBGM0100.setFavPiece",pentasMap);
    }
    
    public void updateGonggiDetail(PentasMap pentasMap) {
		cmmnDao.update("com.pentas.mb.gm.MBGM0100.updateGonggiDetail",pentasMap);
    }
    
    public void deletePiece(PentasMap pentasMap) {
		cmmnDao.update("com.pentas.mb.gm.MBGM0100.deletePiece",pentasMap);
    }

	public void updateSubCnt(PentasMap params) {
		cmmnDao.update("com.pentas.mb.gm.MBGM0100.updateSubCnt", params);
	}
	
    public void updateMyPieceDelete(PentasMap pentasMap) {
    	cmmnDao.update("com.pentas.mb.gm.MBGM0100.updateMyPieceDelete",pentasMap);
    }
    
    public void backupPiece(PentasMap pentasMap) {
		cmmnDao.insert("com.pentas.mb.gm.MBGM0100.backupPiece",pentasMap);
    }
    
    
}

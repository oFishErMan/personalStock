package com.pentas.mb.gm.ctl;

import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cmm.utils.common.PentasMap;
import com.cmm.utils.common.PentasMapBuilder;
import com.pentas.mb.gm.svc.MBGM0100Svc;


@Controller
@RequestMapping("/mb/gm")
public class MBGM0100Ctl {

    @Autowired
    MBGM0100Svc mBGM0100Svc;

    @RequestMapping("/MBGM0100")
    public String openPage(HttpSession session, Model model) {
        model.addAttribute("mbrId", session.getAttribute("MBR_ID"));
        model.addAttribute("nickNm", session.getAttribute("NICKNM"));
        model.addAttribute("pageTitle", "포켓 &amp; 피스관리");
        return "mb/gm/MBGM0100";
    }

    /**
     * 공기 리스트 조회
     * @param pentasMap
     * @return
     */
    @RequestMapping("/MBGM0101")
    public List<PentasMap> getGonggiList(PentasMap pentasMap) {
        return mBGM0100Svc.selectGonggiList(pentasMap);
    }
    
    /**
     * 공기 리스트 조회
     * @param pentasMap
     * @return
     */
    @RequestMapping("/MBGM0102")
    public List<PentasMap> getPiecesCount(PentasMap pentasMap) {
        return mBGM0100Svc.selectPiecesCount(pentasMap);
    }

    /**
     * 공기 수정
     * @param pentasMap
     */
	@RequestMapping("/MBGM0103")
    public void modifyGonggiOrdNo(PentasMap pentasMap) {
		mBGM0100Svc.updateGonggiOrdNo(pentasMap);
    }
	
	/**
     * 피스 불러오기
     * @param pentasMap
     */
	@RequestMapping("/MBGM0104")
    public List<PentasMap> getPieceList(PentasMap pentasMap) {
        return mBGM0100Svc.selectPieceList(pentasMap);
    }
	
	/**
     * 피스 삭제
     * @param pentasMap
     */
	@RequestMapping("/MBGM0105")
    public PentasMap deletePiece(PentasMap pentasMap) {
		//삭제한 노트가 내 노트면 노트마스터 테이블에서 노트삭제YN을 업데이트
		if(pentasMap.getString("mbrId").equals(pentasMap.getString("NTECR_ID"))) {
			// 노트 상태 업데이트
			mBGM0100Svc.updateMyPieceDelete(pentasMap);
			
			// 내노트백업 테이블에 추가.
			mBGM0100Svc.backupPiece(pentasMap);
		} else if (!pentasMap.getString("mbrId").equals(pentasMap.getString("NTECR_ID"))) {
			// 내노트백업 테이블에 추가.
			mBGM0100Svc.backupPiece(pentasMap);
			
			// 구독자 카운트 변경
			mBGM0100Svc.updateSubCnt(pentasMap);
		}
		// 내노트 row 삭제
		mBGM0100Svc.deletePiece(pentasMap);
		
		return new PentasMapBuilder()
				.put("rsltStatus", "SUCC")
				.put("type", pentasMap.getString("type"))
				.build();
    }
    /**
     * 공기 상세 수정
     * @param pentasMap
     */
	@RequestMapping("/MBGM0106")
    public void modifyGonggiDetail(PentasMap pentasMap) {
		mBGM0100Svc.updateGonggiDetail(pentasMap);
    }
	
	/**
     * 피스의 공기위치 수정
     * @param pentasMap
     */
	@RequestMapping("/MBGM0107")
    public void updatePieceGonggi(PentasMap pentasMap) {
		mBGM0100Svc.updatePieceGonggi(pentasMap);
    }
	
	/**
     * 피스 즐겨찾기
     * @param pentasMap
     */
	@RequestMapping("/MBGM0108")
    public void setFavPiece(PentasMap pentasMap) {
		mBGM0100Svc.setFavPiece(pentasMap);
    }
	
    /**
     * 공기 삭제
     * @param pentasMap
     */
	@RequestMapping("/MBGM0109")
    public void deleteGonggi(PentasMap pentasMap) {
		mBGM0100Svc.deleteGonggi(pentasMap);
    }
	
}


package com.pentas.mb.gm.ctl;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.cmm.utils.common.CmmnUtil;
import com.cmm.utils.common.MultipartFileList;
import com.cmm.utils.common.PentasMap;
import com.cmm.utils.common.PentasMapBuilder;
import com.cmm.utils.string.StringUtil;
import com.pentas.mb.cm.svc.CommonSvc;
import com.pentas.mb.gm.svc.MBGM0100P01Svc;
import com.pentas.mb.nd.svc.MBND0100P02Svc;

@RequestMapping("/mb/gm/MBGM0100P01")
@Controller
public class MBGM0100P01Ctl {
	
	@Autowired
	CommonSvc commonSvc;
	
	@Autowired
	MBGM0100P01Svc mbgm0100p01Svc;
	
	@RequestMapping("/initData")
	public PentasMap initData(HttpSession session, PentasMap params) {
		String mbrId = StringUtil.defaultString((String) session.getAttribute("MBR_ID"));
		params.put("mbrId", mbrId);
		
		/* 카테고리 목록 */
		List<PentasMap> categoryList = commonSvc.getCmmnCdList("NTE_CAT", false);
		
		/* 사용자 서랍 목록 */
		List<PentasMap> userGrpList = mbgm0100p01Svc.selectUserGrp(params);

		/* 노트 상세정보 */
		PentasMap nteInfo = mbgm0100p01Svc.selectNteInfo(params);
		
		return new PentasMapBuilder()
				.put("rsltStatus", "SUCC")
				.put("categoryList", categoryList)
				.put("rsltList", userGrpList)
				.put("rsltData", nteInfo)
				.build();
	}
	
	@RequestMapping("/uploadImage")
	public PentasMap uploadImage(HttpSession session, PentasMap params, MultipartFileList fileList) {
		List<PentasMap> fileInfoList = new ArrayList<PentasMap>();
		
		String uploadRelativePath = StringUtil.join("/prj23/", CmmnUtil.getTodayString().substring(0,6), '/');
		
		for (MultipartFile file : fileList) {
			PentasMap fileInfo = commonSvc.uploadFile(file, uploadRelativePath);
			fileInfoList.add(fileInfo);
		}
		
		return new PentasMapBuilder()
				.put("rsltStatus", "SUCC")
				.put("dataList", fileInfoList)
				.build();
	}
	
	@RequestMapping("/saveModNote")
	public PentasMap saveModNote(HttpSession session, PentasMap params) {
		String mbrId = StringUtil.defaultString((String) session.getAttribute("MBR_ID"));
		params.put("mbrId", mbrId);
		
		mbgm0100p01Svc.updateNteMaster(params);
		mbgm0100p01Svc.updateMyNte(params);
		
		return new PentasMapBuilder()
				.put("rsltStatus", "SUCC")
				.build();
	}

}

package com.pentas.mb.on.ctl;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cmm.utils.common.PagingConfig;
import com.cmm.utils.common.PentasMap;
import com.cmm.utils.json.JsonUtil;
import com.cmm.utils.mybatis_paginator.domain.PageList;
import com.pentas.mb.on.svc.MBON0100Svc;

@RequestMapping("/mb/on")
@Controller
public class MBON0100Ctl {
	
	@Autowired
	MBON0100Svc mBON0100Svc;
	
	/*
     * 핫피스 접속
     */
	@GetMapping ("/MBON0100")
	public String MBON0100(Model model, @RequestBody PentasMap pentasMap) {
		model.addAttribute("pageTitle","HOT 인기피스");
		model.addAttribute("cate", pentasMap.get("cate"));
		List<PentasMap> lpm = mBON0100Svc.MBON0101();
		model.addAttribute("noteCateList", JsonUtil.toJsonStr(lpm));
		return "mb/on/MBON0100";
	}
	
	/*
     * 핫피스 목록 불러오기
     */
	@RequestMapping("/MBON0102")
    public PageList<PentasMap> MBON0102(HttpSession session,PentasMap pentasMap, PagingConfig pagingConfig) {
		pentasMap.put("mbrId", session.getAttribute("MBR_ID"));
        return mBON0100Svc.MBON0102(pentasMap, pagingConfig);
    }
}

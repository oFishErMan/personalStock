package com.pentas.mb.on.svc;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PagingConfig;
import com.cmm.utils.common.PentasMap;
import com.cmm.utils.mybatis_paginator.domain.PageList;

@Service
public class MBON0100Svc {

	@Autowired
	CmmnDao cmmnDao;

	public List<PentasMap> MBON0101() {
		return cmmnDao.selectList("com.pentas.mb.on.MBON0100.selectCategory");
	}

	public PageList<PentasMap> MBON0102(PentasMap pentasMap, PagingConfig pagingConfig) {
		return cmmnDao.selectListPage("com.pentas.mb.on.MBON0100.selectPieceList", pentasMap, pagingConfig);
	}

}

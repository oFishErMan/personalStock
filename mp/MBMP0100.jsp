<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="vueapp">
	<template>
		<div id="container">
        <div id="content" class="sub_content">
            <section class="piece_wrap">
	            <div class="piece_none" v-if="dataList.length === 0">
	                <p>공개된 피스가 없어요.</p>
	            </div>
	            <div class="piece_list" v-else>
	                <div class="piece_item" v-for="item in dataList">
	                    <div class="piece_item__image" @click="cf_movePage('/mb/nd/MBND0100?nteId='+ item.NTE_ID)">
	                        <img :src="cf_isEmpty(item.NTE_IMG) ? '/static_resources/images/no_img.svg' : '/common/fileDn?p=' + item.NTE_IMG"
	                        	alt="핫피스 대표이미지" :style="cf_isEmpty(item.NTE_IMG) ? hotNoImgStyles : {}">
	                        <span class="category">{{item.SUB_CAT_NM.split(',')[1]}}</span>
	                        <button type="button" class="like"><strong>{{item.LIKE_CNT}}명</strong>이 하트했어요.</button>
	                    </div>
	                    <div class="piece_item__content">
	                        <div class="comment_area">
	                            <div class="comment_box">
	                                <span v-if="!cf_isEmpty(item.PF_IMG)" class="comment_thumb"><img :src="'/common/fileDn?p=' + item.PF_IMG" alt="프로필 사진"></span>
	                                <span v-else-if="!cf_isEmpty(item.DEF_IMG)"  class="comment_thumb"><img :src="'/static_resources/images/character' + item.DEF_IMG + '.svg'" alt="프로필 사진"></span>
	                                <div class="comment_nick">
	                                    <strong>{{item.NTE_NM}}</strong>
	                                    <span class="text">{{item.NICKNM}} <i>구독자 {{item.SUB_CNT}}명</i></span>
	                                </div>
	                            </div>
	                            <div class="comment_text">{{item.NTE_DESC}}</div>
	                        </div>
	                    </div>
	                </div>
	            </div>
            </section>
        </div>
    </div>
	</template>
</div>
</div>
<script>
var vueapp = new Vue({
    el : "#vueapp",
    mounted : function() {
        this.getList();
    },
    data : {
    	tgtId : '${tgtId}',
    	tgtNick : '',
    	pf_img : '',
    	def_img : '',
    	hotNoImgStyles : { position: 'absolute', height: '50%', backgroundColor: '#fff', padding: '65px 0px', objectFit: 'contain' },
    	dataList : [] 
    },
    methods : {
    	getList : function() { // 피스 목록 불러오기
            var options = {
                params: {
                    tgtId : this.tgtId,
                },
            }
           	cf_ajax("/mb/mp/MBMP0101", options).then(this.getListCB);
    		
        },
        
        getListCB : function(data) {
        	this.dataList = data;
        	this.tgtNick = data[0].NICKNM;
        	
        	this.pf_img = data[0].PF_IMG;
        	this.def_img = data[0].DEF_IMG;
        },
    },
});
</script>